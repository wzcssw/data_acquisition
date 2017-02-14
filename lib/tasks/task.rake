namespace :task do
  desc "xinren data"
  task :set_data => :environment do
    (1..8013).each do |page|
      puts page
      hqms_biu(page)
    end
  end

    def hqms_biu page # 得到 id:city 键值对
      # 得到页面内容
      str = get_page('http://www.xinfadi.com.cn',"/marketanalysis/0/list/#{page}.shtml")
      # 得到document对象
      doc = Nokogiri::HTML(str)
      elements = doc.search("tr")  #.css(".province_selects")
      elements.each do |e|
        if e.children.first.attributes['style'].to_s == "text-align:left;padding-left:5px;"
          Vegetable.create(name: e.children[0].content,
                           min_val: e.children[1].content,
                           ave_val: e.children[2].content,
                           max_val: e.children[3].content,
                           v_type: e.children[4].content,
                           unit: e.children[5].content,
                           send_date: e.children[6].content
                          )
        end
      end
    end


    def get_page (url,path) # 发送数据
      # 连接对象
      conn = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      response = conn.get path
      response.body
    end

    def self.get_elements (url,path)
         str = get_page(url,path)
         JSON.parse(str)
    end


    # 待验证码的东东 相关网站 https://www.juhe.cn
    task :crack_code => :environment do
      # Foursome.all.distinct.select(:name).distinct.each do |tmp| #遍历关键字
      # end
      # 首先下载页面内容
      conn = Faraday.new(:url => 'http://218.246.22.53') do |f|
        f.use :cookie_jar
        f.request  :url_encoded             # form-encode POST params
        f.response :logger                  # log requests to STDOUT
        # faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        f.adapter :net_http_persistent
      end
      result = conn.get '/unitsearch.aspx'
      # 解析返回的文本
      doc = Nokogiri::HTML(result.body)
      eventvalidation = doc.search('#__EVENTVALIDATION').first.attributes['value']
      view_state = doc.search('#__VIEWSTATE').first.attributes['value']
      # 破解验证码
      code = crack_code conn
      option = Hash.new
      option['ctl00$ContentPlaceHolder1$txtName'] = '协和医院'
      option['ctl00$ContentPlaceHolder1$checkcode'] = code
      option['__EVENTVALIDATION'] = eventvalidation
      option['__VIEWSTATE'] = view_state
      option['ctl00$ContentPlaceHolder1$ButtonSearch'] = '查询'
      # 发送参数得到结果
      final_result = conn.post '/unitsearch.aspx', option
      # 解析结果
      obj = Nokogiri::HTML(final_result.body)
      eles = obj.search('a')
      e = eles.select{|x| x.attributes['target'].to_s=='_blank' }[0]
      detail_url = e.attributes['href']# 详情链接
      puts "--------  得到详情链接: #{detail_url}  --------"
      # 抓取详情
      extreme_result_option = Hash.new
      detail_result = conn.get('/'+detail_url).body if detail_url.present?
      # 解析详情
      detail_obj = Nokogiri::HTML(detail_result.body)
      extreme_result_option[:unitname] = detail_obj.search('#ContentPlaceHolder1_lblUnitName').first
      # 未完待续...
    end

    # 破解验证码
    def crack_code target_conn # 使用注入的链接以维持会话
      app_key = 'bab3a21144e3804bdd6891c23a8b2553'
      app_url = "http://op.juhe.cn"
      conn = Faraday.new(:url => app_url ) do |f|
        f.request :multipart
        f.request :url_encoded
        # faraday.adapter :net_http # This is what ended up making it work
        f.adapter :net_http_persistent
      end
      # 存储验证码
      File.open('public/codes/tmp.gif', 'wb') { |fp| fp.write(target_conn.get('/pn.aspx').body) }
      payload = { key:app_key,codeType:1005, image: Faraday::UploadIO.new('public/codes/tmp.gif', 'image/gif') }
      result = conn.post '/vercode/index', payload
      result_obj = JSON.parse(result.body)
      puts "--------  验证码接口返回: #{result_obj}  --------"
      code = nil
      if result_obj['error_code'] == 0
        code = result_obj['result']
      end
    end
end

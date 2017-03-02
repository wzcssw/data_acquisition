namespace :task do
    desc "haodaifu data"
    task :go => :environment do
      get_province
      get_hospital
      get_department
    end

    def get_province # 获得省份信息
      # 得到页面内容 
      str = get_page('http://www.haodf.com','/yiyuan/all/list.htm')
      # 得到document对象
      doc = Nokogiri::HTML(str)
      # HaodaifuProvince  
      elements = doc.search(".kstl2")  #.css(".province_selects")
      elements.each do |e|
        url = e.children[1].attributes['href'].to_s.lstrip.rstrip
        province = e.content.to_s.lstrip.rstrip
        HaodaifuProvince.create(name: province,url: url)
      end
      elements = doc.search(".kstl")  #.css(".province_selects")
      elements.each do |e|
        url = e.children[1].attributes['href'].to_s.lstrip.rstrip
        province = e.content.to_s.lstrip.rstrip
        HaodaifuProvince.create(name: province,url: url)
      end
    end

    def get_hospital # 获得所有医院信息
      HaodaifuProvince.all.each do |h|
        puts '<<<<<<<<<<<<<<<<' << h.name << '>>>>>>>>>>>>>>>>>>>>'
        url = h.url.split('.com')[1]
        str = get_page('http://www.haodf.com',url).force_encoding("gbk").encode('utf-8')
        doc = Nokogiri::HTML(str)
        elements = doc.search(".m_title_green")
        elements.each do |e|
          # url = e.children[1].attributes['href'].to_s.lstrip.rstrip
          area = e.content.to_s.lstrip.rstrip # 区
          # puts area
          e.next_element.search("a").each do |x|
            url = x.attributes['href'].to_s.lstrip.rstrip
            name = x.content.to_s.lstrip.rstrip
            HaodaifuHospital.create(name: name,url: url,h_area: area,h_type: h.name)
          end
        end
      end
    end

    def get_department # 获得所有医院的所有科室信息
      HaodaifuHospital.all.each do |hdf|
        puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>    " <<  hdf.id.to_s << "    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        str = get_page('http://www.haodf.com',hdf.url)
        doc = Nokogiri::HTML(str)
        elements = doc.css(".font14")  #.css(".province_selects")
        elements.each do |e|
          if e.attributes['width'].to_s.lstrip.rstrip == "12%"
            p e.content.to_s.lstrip.rstrip << '============================='# 类别名
            e.next_element.search("a").each do |x|
              if x.attributes['class'].to_s.lstrip.rstrip == "blue"
                url = x.attributes['href'].to_s.lstrip.rstrip
                name = x.content.to_s.lstrip.rstrip# 科室名 
                p name
                p url
                HaodaifuDepartment.create(name: name,url: url,category: e.content.to_s.lstrip.rstrip,h_provice: hdf.h_type,h_area: hdf.h_area,h_name: hdf.name)
              end
            end
          end
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
end

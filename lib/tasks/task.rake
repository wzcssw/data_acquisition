namespace :task do
  # --------------------------- START
  def get_page (url,path) # 发送数据
    # 连接对象
    conn = Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    begin
      response = conn.get path
    rescue => exception
      puts "有连接失败:"<< path << "错误为:" << exception.to_s
      return ""
    end
    return "" if response.status != 200
    response.body
  end
  # --------------------------- END



  # --------------------------- START trim问题；循环时循环项未记录问题
  def biu (qcc_param)
    path = qcc_param.shareUrl
    str = get_page("http://www.qichacha.com",path)
    if str != ""
      doc = Nokogiri::HTML(str)
      cc = doc.search("#company-top").search(".row .title")
      if cc[0].blank?
        p  str
        puts "标题未找到: " << path
        return 
      end
      main_title = cc[0].xpath('text()').text.gsub("\n","").lstrip.rstrip
      elements = doc.search(".ntable")
      elements = doc.search("#Sockinfo")
      ele = elements[0] if elements.present?
      i = 0
      if ele.blank?
        puts path << "没有ele"
      return 
      end
      ele.search("tr").each do |e|
        i+=1
        if i!=1 # 从第2个tr开始
          topic = ""
          shareUrl = ""
          shareholder_type = ""
          a = e.search("td")[0].search("a")[0]
          shareholder_type = e.search("td")[4].content.to_s.lstrip.rstrip
          shareUrl =  a['href'].to_s.lstrip.rstrip
          topic =  a.content.to_s.lstrip.rstrip
          qcc = Qcc.where(shareUrl: shareUrl).first
          if qcc.blank?
            if  ["自然人股东", "境内中国公民","有限合伙人","个人财产出资","个人独资企业","国家授权投资部门","其他","集体所有制","社会公众股","事业法人"].include? shareholder_type
              Qcc.create(shareUrl: shareUrl,topic: topic,shareholder_type: shareholder_type,parentid: main_title,finished: true)
            else
              Qcc.create(shareUrl: shareUrl,topic: topic,shareholder_type: shareholder_type,parentid: main_title)
            end
          else # 已经存在的项
            Qcc.create(shareUrl: shareUrl,topic: topic,shareholder_type: shareholder_type,parentid: main_title,finished: true)
          end
        end
        qcc_param.update(finished: true) # 做查询本条结束标记
        puts "#{topic} ..... ok"
      end
      #
    end
  end
  # --------------------------- END


  # --------------------------- START 3802条
  task :set_data => :environment do
    999999.times do |a| 
      count = Qcc.where(finished: false).count
      Qcc.where(finished: false).each do |q|
        puts "-------- 本次查询#{count}个条目 --------#{a} times"
        biu(q)
        sleep(rand(1.7..3.5))
      end
    end
  end
  # --------------------------- END

  # --------------------------- START
  task :cook => :environment do
    result = []
    Qcc.all.each do |x|
      obj = {}
      obj[:id] = x.topic
      obj[:parentid] = x.parentid
      obj[:expanded] = false
      obj[:topic] = x.topic
      obj[:shareUrl] = x.shareUrl
      result << obj
    end
    require 'tmpdir'
    
    aFile = File.new("/Users/tx2017/Desktop/data_acquisition/cheng.json", "r+")
    if aFile
      aFile.syswrite(result.to_json)
    else
      puts "Unable to open file!"
    end
  end
  # --------------------------- END

end
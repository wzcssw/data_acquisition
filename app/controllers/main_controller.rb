class MainController < ApplicationController
  def index
      sum = 0.0
      iter = 0
     (2000556..9000000).each do |i|
       iter+=1
       path = '/wx/doctor/' << i.to_s << '/feeds'
       # 得到页面内容
       str = ""
       begin
         str  = get_page('http://xingren.com',path)
       rescue
         puts "网络异常~"
         redo
       end

       # 得到document对象
       doc = Nokogiri::HTML(str)

       name = nil
       title = nil
       administrative = nil
       area = nil
       work_time = nil
       head = nil
       description = nil

       if str.length > 1200 # 有数据的情况
         name_span = doc.at(".name")
         if !name_span.blank?
           name = name_span.content
         end

         title_span = doc.at(".title")
         if !title_span.blank?
           title = title_span.content
         end

         hospital_span = doc.at(".hospital")
         if !hospital_span.blank?
          #  result << "<br/>hhhh:"+hospital_span
           strs = hospital_span.content.split("|")
           administrative = strs[0] if !strs[0].blank?
           area = strs[1] if !strs[1].blank?
         end

         time_span = doc.at(".profile-extra")
         if !time_span.blank?
           work_time = time_span.xpath("//p")[0].content
         end

         head_span = doc.at(".avt")
         if !head_span.blank?
           head = head_span.attributes['src']
         end

         folded_span = doc.at(".folded")
         if !folded_span.blank?
           description = folded_span.content
           s = description[8,description.length]
         end

         begin
           Xingren.create(name:name,title:title,administrative:administrative,area:area,work_time:work_time,head:head,description:s)
         rescue => e
           puts  "有一条出错了:" << e.message
           Xingren.create(name:name,title:title,administrative:administrative,area:area,work_time:work_time,head:head,description:nil)
         end
       else
         sum+=1
         hav = iter - sum
         rate = hav / iter * 100

         puts " 共遍历数据 " + iter.to_s + "条."
         puts " 无数据页面共遇到 " + sum.to_s + "条."
         puts " 有数据页面共遇到 " + hav.to_s + "条."
         puts " 有效数据占 " + rate.to_s + "%."
       end

     end

     render text: 'ok'
  end


  def hqms
    # 得到id,城市键值对
    h = hqms_biu()

    h.each do |key,value|
        new_path = "/usp/roster/rosterInfo.jsp?hname=&provinceId=" << key.to_s
        # 得到页面内容
        str = get_page('https://www.hqms.org.cn',new_path)
        # 转换为JSON对象
        obj = JSON.parse(str)
        # 创建Hqm对象
        obj.each do |x|
          m = Hqm.new(x)
          m.proviceName = value
          m.save
        end
    end
    render text:'ok'
  end

  def hqms_biu # 得到 id:city 键值对
    result = ""
    h = Hash.new
    # 得到页面内容
    str = get_page('https://www.hqms.org.cn','/usp/roster/index.jsp')
    # 得到document对象
    doc = Nokogiri::HTML(str)

    elements = doc.search(".province_select//option")  #.css(".province_selects")
    elements.each do |e|
      # puts e.attributes['value']
      # puts e.content
      h[ e.attributes['value'].to_s ] = e.content if !e.attributes['value'].to_s.blank?
    end
    # puts h["7180"]
    h
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

end

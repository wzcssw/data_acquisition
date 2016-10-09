namespace :task do

    # 清空download文件夹
    task :truncate => :environment do
      FileUtils.rm_rf Dir.glob("download/*")
      puts "----- success  -----"
    end

    def get_clean (url,path) # 发送数据
      conn = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.adapter  Faraday.default_adapter
      end
      response = conn.get path
      response.body
    end

    def get_file_name path
      path.split('/').last
    end

    def get_file(url,path,local_path)
      conn = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      File.open("download#{local_path}", 'wb') { |fp| fp.write(conn.get(path).body) }
    end


    task :fuck_1024 => :environment do
      page_urls = []
      url = "http://t66y.com"
      path = "/thread0806.php?fid=16"
      # 走你
      result = get_clean url,path
      result = result.force_encoding("gbk").encode('utf-8')
      # 结构化
      doc = Nokogiri::HTML(result)
      elements = doc.search("a")
      elements.each do |e|
         # puts e.attributes['value']
         f_child = e.children.first
         if f_child.attributes['color'].to_s=="green"
           page_urls << e.attributes['href'].to_s
         end
       end
      puts "=== 最新内容共#{page_urls.length}条  ==="
      page_urls.each do |path|
        str = get_clean url,('/'<<path)
        str = str.force_encoding("gbk").encode('utf-8')
        # 结构化
        doc = Nokogiri::HTML(str)
        title = doc.search("title").first.content
        elements = doc.search("input")
        puts ">> 正在下载: " << title
        elements.each do |e|
           if e.attributes['type'].to_s=="image"
             next if e.attributes['src'].to_s == "http://ww4.sinaimg.cn/mw690/005uMz33gw1egsm41zq6qj30f80b4gm9.jpg"
             next if e.attributes['src'].to_s == "http://ww4.sinaimg.cn/mw690/6f8a57e2gw1f1bukzbw2mg20aa00b08v.gif"
             next if e.attributes['src'].to_s == "http://ww4.sinaimg.cn/mw690/6f8a57e2gw1f1bukzt8nvg202o00yjr9.gif"
             uri = URI(e.attributes['src'].to_s)
             Dir.mkdir("download/#{title[0,20]}") if !File.exist?("download/#{title[0,20]}")
             local_path ="/#{title[0,20]}/#{get_file_name(uri.request_uri)}"
             get_file("http://"<<uri.host,uri.request_uri,local_path)
             puts get_file_name(uri.request_uri)
           end
        end
      end
    end
end

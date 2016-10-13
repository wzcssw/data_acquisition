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


    task :love_1024 => :environment do
      word = "老" # 关键字
      page_urls = []
      url = "http://t66y.com"
      path = "/thread0806.php?fid=16"
      # 走你
      result = get_clean url,path
      result = result.force_encoding("gbk").encode('utf-8')
      # 结构化
      doc = Nokogiri::HTML(result)
      count_page = doc.search("input").first.attributes['value'].to_s.split("/")[1].to_i # 获得总页数
      (1..count_page).each do |page|
        path = "/thread0806.php?fid=16" << "&page=#{page}"
        result = get_clean url,path
        result = result.force_encoding("gbk").encode('utf-8')
        doc = Nokogiri::HTML(result)
        elements = doc.search("a")
        elements.each do |e|
           if e.content.to_s.include?('P]') && e.content.to_s.include?(word)
             page_urls << e.attributes['href'].to_s
           end
         end
        puts "=====         第#{page}页         ====="
        # puts "=== 最新内容共#{page_urls.length}条  ==="
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
end

namespace :task do
    task :go => :environment do
      # 连接对象
      url = "http://www.topit.me"
      conn = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter
      end
      (1..100).each do |page|
        src_arrs = []
        path = "/pop?p=#{page}"
        doc = Nokogiri::HTML(get_page(conn,path))
        doc.css(".img").each do |e| # 这里是为了处理网站的延迟加载导致的图像质量不一致的问题
          if e.attributes['src'].to_s!="http://img.topitme.com/img/style/blank.gif"
            src_arrs << e.attributes['src'].to_s
          else
            src_arrs << e.attributes['data-original'].to_s
          end
        end
        src_arrs.each do |path|
          file_name = get_file_name path # 得到文件名
          local_path = "/#{file_name}" # 本地存储路径
          get_file(url,path,local_path) # 下载
        end
      end
    end

    # 清空download文件夹
    task :truncate => :environment do
      FileUtils.rm_rf Dir.glob("download/*")
      puts "----- success  -----"
    end

    def get_page (target_conn,path) # 发送数据
      response = target_conn.get path do |req|
        req.headers['Cookie'] = "is_click=1;" # 脑残优美图竟然只用这一个cookie来反爬虫
      end
      response.body
    end

    def get_file_name path
      path.split('/').last
    end

    def get_file(url,path,local_path)
      conn = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      File.open("download#{local_path}", 'wb') { |fp| fp.write(conn.get(path).body) }
    end
end

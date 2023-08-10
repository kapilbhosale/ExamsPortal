class ProxyWorker
  include Sidekiq::Worker
  KEY= "etx2ptve29qm8jfuti6d3gvwxn2drcl24gnf813f"

  def perform
    proxies_to_create = {}

    1.upto(10).each do |page|
      url = "https://proxy.webshare.io/api/v2/proxy/list/?mode=direct&page=#{page}&page_size=100"
      resp = Faraday.get(url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Token #{KEY}"
      end
      if resp.status == 200
        json_response = JSON.parse(resp.body)
        json_response["results"].each do |proxy_data|
          if proxy_data['valid']
            proxies_to_create["#{proxy_data['proxy_address']}:#{proxy_data['port']}"] = {
              user_name: proxy_data["username"],
              password: proxy_data["password"],
              ip_and_port: "#{proxy_data['proxy_address']}:#{proxy_data['port']}",
              conn_string: "#{proxy_data["username"]}:#{proxy_data["password"]}@#{proxy_data['proxy_address']}:#{proxy_data['port']}"
            }
          end
        end
        puts "----proxies --- #{json_response['results'].count}"
      end
    end

    if proxies_to_create.present?
      ActiveRecord::Base.transaction do
        Proxy.delete_all
        Proxy.create!(proxies_to_create.values)
        puts "---Proxies updated"
      end
    end
  end
end

Sidekiq::Cron::Job.create(name: 'Proxy Update Worker - every 1 Hour', cron: '0 * * * *', class: 'ProxyWorker')
# execute at every Hour
require 'json'
require 'uri'
require 'net/https'

#
# 常識問題と答のMD5を得る
#
def get_joushiki()
  url = "https://joushiki.herokuapp.com/"
  begin
    uri = URI.parse(URI.escape(url)) # 何故かescape必要?
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Get.new(uri.path)
    res = http.request(req)
    return ["", "", ""] unless res
    JSON.parse(res.body)
  rescue
    return ["", "", ""]
  end
end

class TenXunMappingService
  attr_reader :namespace_id, :host

  def initialize
    @namespace_id = 1
    @host = 'https://ocr.tencentcloudapi.com'
  end

  # def identify
  #   RestClient::Request.execute(
  #     method: :post,
  #     url: @host,
  #     headers: authorization_token,
  #     timeout: 20
  #   )
  # end

  private

  def canonical_request
    http_request_method = "POST\n"
    canonical_url = "/\n"
    canonical_query_string = "\n"
    canonical_headers = "content-type:application/json; charset=utf-8\nhost:cvm.tencentcloudapi.com\n\n"
    @signed_headers = "content-type;host"
    # {"Limit": 1, "Filters": [{"Values": ["\u672a\u547d\u540d"], "Name": "instance-name"}]}）
    play_load = "{\"Limit\": 1, \"Filters\": [{\"Values\": [\"\\u672a\\u547d\\u540d\"], \"Name\": \"instance-name\"}]}\n"
    hashed_request_payload = Digest::SHA2.new(256).hexdigest(play_load).downcase
    "#{http_request_method}#{canonical_url}#{canonical_query_string}#{canonical_headers}#{@signed_headers}\n#{hashed_request_payload}"
  end

  def string_to_sign
    @algorithm = "TC3-HMAC-SHA256"
    request_timestamp = Time.now.to_i
    @credential_scope = Time.now.to_date.to_s + "/ocr/tc3_request"
    hashed_canonical_request = Digest::SHA2.new(256).hexdigest(canonical_request).downcase
    "#{@algorithm}\n#{request_timestamp}\n#{@credential_scope}\n#{hashed_canonical_request}\n"
  end

  def signature
    secret_date = OpenSSL::HMAC.hexdigest("SHA256", "TC3"+ENV['SECRET_KEY'], Time.now.to_date.to_s)
    secret_service = OpenSSL::HMAC.hexdigest("SHA256", secret_date, "ocr")
    secretSigning = OpenSSL::HMAC.hexdigest("SHA256", secret_service, "tc3_request")
    a = OpenSSL::HMAC.hexdigest("SHA256", secretSigning, string_to_sign)
    a.encode(Encoding::ISO_8859_1)
  end

  def authorization
    "#{@algorithm} Credential=#{ENV['SECRET_ID']}/#{@credential_scope}, SignedHeaders=#{@signed_headers}, Signature=#{signature}"
  end
end

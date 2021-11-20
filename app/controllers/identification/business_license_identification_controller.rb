class Identification::BusinessLicenseIdentificationController < ApplicationController
  include TencentCloud::Common
  include TencentCloud::Ocr::V20181119
  skip_before_action :verify_authenticity_token
  before_action :get_image_base64, :get_image_url

  def identify

    begin
      cred = Credential.new(secretId, secretKey)

      client = Client.new(cred, "ap-beijing")

      req = BizLicenseOCRRequest.new()
      req.ImageBase64 = get_image_base64
      req.ImageUrl = get_image_url

      resp = client.BizLicenseOCR(req)

      render :json => resp.serialize
    rescue TencentCloudSDKException => e
      puts e.message
      puts e.backtrace.inspect
    end

  end

  private

  def secretId
    "AKIDueCXiqqgLqDOPFwSnwsb7RfolX6Tksqd"
  end

  def secretKey
    "d5MRM6dy73pRs8FAsPjsukS0QfjiV9bs"
  end

  def get_image_base64
    params[:get_image_base64]
  end

  def get_image_url
    params[:get_image_url]
  end
end


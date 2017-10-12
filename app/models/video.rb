class Video < ApplicationRecord
  include ClipUploader[:clip]
  belongs_to :user
  has_many :plays


  def secret_url
    signer = Aws::CloudFront::UrlSigner.new(
      key_pair_id: ENV["CLOUDFRONT_KEY_ID"],
      private_key: ENV["CLOUDFRONT_PRIVATE_KEY"]
    )
    url = signer.signed_url(cloudfront_url, policy: policy.to_json)
  end

  def cloudfront_url
    domain_id = ENV["CLOUDFRONT_DOMAIN_ID"]
    "https://#{domain_id}.cloudfront.net/#{clip.id}"
  end

  def policy
    {
       "Statement" => [
          {
             "Resource" => cloudfront_url,
             "Condition" => {
                "DateLessThan" => {
                   "AWS:EpochTime" => 1.days.from_now.to_i
                }
             }
          }
       ]
    }
  end

  def update_views(play)
    new_views = views + play.duration
    update(views: new_views)
  end


end

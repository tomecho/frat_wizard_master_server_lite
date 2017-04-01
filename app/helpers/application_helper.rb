module ApplicationHelper
  def get_email_by_token(token)
    return false if token.nil?
    uri = URI.parse "https://graph.facebook.com/me?fields=email&access_token=#{token}"
    fb = Net::HTTP.get_response(uri)

    if fb && fb.code == '200'
      email = JSON.parse(fb.body)['email'] # if this exists then facebook has verified the token and found user for it
      return email if email
    end
    false
  end
end

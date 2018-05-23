module ApplicationHelper
  # returns nil or profile
  def get_facebook_profile_by_token(token, fields = [])
    return nil if token.nil?
    uri = URI.parse "https://graph.facebook.com/me?fields=#{fields.map(&:to_s).join(',')}&access_token=#{token}"
    fb = Net::HTTP.get_response(uri)

    if fb && fb.code == '200'
      return JSON.parse(fb.body)
    end
  end

  def request_for_api?(request)
    # if we have request.headers[:authorization].present? it can only be for api
    if request.headers["Authorization"].present?
      return true
    else
      return false
    end
  end

  def has_permission?(controller, action, user)
    binding.pry
    if ['user::omniauth_callbacks', 'devise/sessions'].include? controller
      return true
    else
      return user && user.has_permission(controller, action)
    end
  end
end

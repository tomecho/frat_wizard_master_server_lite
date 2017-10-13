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
    # TODO replace session[:user_id] with whatever omni auth comes up with
    # if we have a session[:user_id] this is not a request for the api
    # if we have request.headers[:accept].include? "application/json" this could be a either desktop or api request but we will assume its for api
    # if request.fullpath == '/home' this is for desktop site
    # if we have request.headers[:authorization].present? it can only be for api
    if session[:user_id] || request.fullpath == '/'
      return false
    elsif request.headers["Accept"].include? "application/json" || request.headers["Authorization"].present?
      return true # even if this is the desktop site just making an ajax request it isnt a big deal, they'll just get a 401
    end
    true # default is true
  end
end

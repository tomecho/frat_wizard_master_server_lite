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
    if request.headers["Authorization"].present? || request.path.starts_with("/api/")
      return true
    else
      return false
    end
  end

  def has_permission?(request, user)
    auth_paths = ['/users/sign_in', '/users/auth/facebook/callback']
    excluded_paths = ['/', '/home', '/verify_facebook_token']

    if (auth_paths + excluded_paths).include?(request.path || '')
      return true
    else
      return user && user.has_permission?(controller_name, action_name)
    end
  end

  # only renders link if we can visit it
  def safe_link_to(name = nil, url_options = nil, html_options = nil, &block)
    # Convert given options to a usable url, this allows:
    #   link_to(@object) do ... end
    #   link_to "Link text", @model ...
    #   link_to "Link text", model_method_path ...
    #   link_to "Link text", model_method_path(@model.id, ...) ...
    #   link_to "Link text", "http://www.google.com" ...

    # Use name to generate url if the first arg was an object
    if name.is_a? ActiveRecord::Base
      url = url_for(name)
      options = url_options
    else
      url = url_for(url_options)
      options = html_options
    end

    # Always create the link if it isn't a relative path and not permission controlled
    return link_to(name, url_options, html_options, &block) unless url.start_with?('/')

    # Assume get
    method = 'get'
    # Replace with specific method if provided, replacing put with patch to fix issue with some routes and rails 4
    method = options[:method].to_s.gsub('put', 'patch') if options && options[:method]

    # Try to recognize the route
    route = Rails.application.routes.recognize_path url, method: method

    # Return the link as normal if the current user has the permission
    return link_to(name, url_options, html_options, &block) if @current_user.has_permission?(route[:controller], route[:action])

    # Raise an error if the link is hidden but the user is omni and should see all links
    # raise "Link not rendered for omni user, please check this" if @current_user.groups.find_by(name: "omni").present?
  end
end

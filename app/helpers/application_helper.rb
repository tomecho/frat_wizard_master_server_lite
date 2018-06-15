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
	def safe_link_to(name = nil, options = nil, html_options = nil, &block)
		method = 'get' || options[:method]
		route = Rails.application.routes.recognize_path url, method: method

		if @current_user.has_permission?(route[:controller], route[:action])
			return ActionView::Helpers::UrlHelper.link_to(name, options, html_options)
		end
	end
end

module SessionsHelper

# Logs in the current user
	def log_in(user)	
		session[:user_id] = user.id
	end

# Remember a user in persistent session
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

# Return true if the given user is the current user
	def current_user?(user)
		user == current_user
	end
# Return the user corresponding to the remember token cookie
	def current_user
		if (user_id = session[:user_id])
		@current_user ||= User.find_by(id: session[:user_id])
	elsif (user_id = cookies.signed[:user_id])
		user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])	
				log_in user
				@current_user = user
			end
		end
	end
# return true if the user is logged in
	def logged_in?
		!current_user.nil?
	end

# Forgets a persistent session
	def forget(user)
		user.forget if logged_in?
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end
# Redirect to the store location or default
	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end
#Store the url strying to be access
	def store_location
		session[:forwarding_url] = request.original_url if request.get?
	end
end

























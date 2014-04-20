module SessionsHelper

   # Signs in and establishes the current user
   # current_user can be used in all controllers, helpers, and views to access signed_in user
   def sign_in(user)
      remember_token                     = User.new_remember_token
      cookies.permanent[:remember_token] = remember_token
      user.update_attribute(:remember_token, User.encrypt(remember_token))
      self.current_user = user
   end

   # Returns whether there is a current user
   def signed_in?
      !current_user.nil?
   end

   # Creates an instance variable @current_user to be used globally
   def current_user=(user)
      @current_user = user
   end

   # Used in conjunction with the previous method to allow @current_user to be used globally
   def current_user
      remember_token = User.encrypt(cookies[:remember_token])
      @current_user  ||= User.find_by(remember_token: remember_token)
   end

   # Sign out the user and delete all associated cookies
   def sign_out
      if current_user
         self.current_user = nil
      end
      cookies.delete(:remember_token)
      session.delete(:return_to)
      session.delete(:selected_section_id)
      session.delete(:selected_project_id)
   end

   # Redirects back to a saved url if present
   # Used to remember where people were trying to go before being redirected to sign in 
   def redirect_back_or(default)
      redirect_to(session[:return_to] || default)
      session.delete(:return_to)
   end

   # Saves the location that a user was trying to access before a redirect
   def store_location
      session[:return_to] = request.url if request.get?
   end
end

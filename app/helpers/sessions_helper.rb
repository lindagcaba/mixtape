module SessionsHelper
  def sign_in(user)
    cookies.signed.permanent[:remember_token] =[user.id, user.salt]   
    current_user = user
  end

  def signed_in?
   !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user||= user_from_token
  end

  def sign_out
  cookies.delete(:remember_token)
  current_user = nil  
 end
  private 
    def user_from_token
      User.authenticate_with_salt(*remember_token)
    end

  
    def remember_token
      cookies.signed[:remember_token] ||[nil,nil]
    end
    def deny_access
      flash[:warning] = "Please Sign in to access page"
      redirect_to signin_path
    end
end

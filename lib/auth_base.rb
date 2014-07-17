# encoding: utf-8
module AuthBase
  protected 
  def is_logged_in?
    @logged_in_user = User.find(session[:user]) if session[:user]
  end
  def logged_in_user
    return @logged_in_user if is_logged_in?
  end
  def logged_in_user=(user)
    if !user.nil?
      session[:user] = user.id
      session[:expires_at] = 20.minutes.from_now
      @logged_in_user = user
    end
  end
  def login_required
    unless is_logged_in?
      flash[:error] = '对不起，请先登陆，再进行对应的操作'
      redirect_to "/session/login?from=#{request.url}&m=#{request.method}"
    end
  end
  def lower?(str)
    /[a-z]/ =~ str
  end
  def upper?(str)
    /[A-Z]/ =~ str
  end
  def num?(str)
    /[0-9]/ =~ str
  end
  def self.included(base)
    base.send :helper_method,:is_logged_in?,:logged_in_user
  end
end
class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :set_locale
  
  before_filter :authenticate
  
protected

  def unauthenticated
    redirect_to :root
  end

  def set_locale
    set_default_locale
    set_current_locale
  end
  
  def set_default_locale
    I18n.default_locale = case request.domain(0)
      when "com"
        :en
      else
        :ru
    end
  end
  
  def set_current_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end

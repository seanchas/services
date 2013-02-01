class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :set_locale
  
  before_filter :authenticate

  after_filter :clear_cache_control
  
  helper_method :authenticated_requisite, :authenticated_requisite?
  
  def rescue_action_in_public(exception)
    case exception
      when ActionController::UnknownAction, ActionController::RoutingError, ActiveRecord::RecordNotFound
        render :template => 'welcome/404', :layout => 'error'
      else
        render :template => 'welcome/500', :layout => 'error'
    end
  end

protected

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


  def authenticated_requisite
    authenticated_user.infosell_requisite if authenticated?
  end
  alias :authenticated_requisite? :authenticated_requisite

  def authenticated_requisite!
    redirect_to :root unless authenticated_requisite?
  end

  def clear_cache_control
      response.headers.delete "Cache-Control"
  end
  
end

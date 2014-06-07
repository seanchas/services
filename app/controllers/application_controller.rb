class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :redirect_to_default_domain

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

  # redirects from .ru to .com by default
  def redirect_to_default_domain
    redirect_to "#{request.protocol}#{request.host.split('.').slice(0...-1).push('com').join('.')}:#{request.port}#{request.request_uri}" if request.domain(0) == 'ru'
  end

  def set_locale
    set_default_locale
    set_current_locale
  end
  
  def set_default_locale
    I18n.default_locale = :ru
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
    # response.headers.delete "Cache-Control"
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
end

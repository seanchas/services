module ApplicationHelper

  def title(title, title_visible = true)
    content_for(:title, title)
    @title_visible = title_visible
  end
  
  def title_present?
    !!@content_for_title
  end
  
  def title_visible?
    title_present? && @title_visible
  end
  
  def domains_menu
    current_url = "#{request.scheme}://#{request.host}"
    navigation.ul :html => { :class => "tabbed_menu left" } do |ul|
      t(:domains, :scope => [:shared, :headline]).each do |title, url|
        ul.li h(title), url, url == current_url ? :all : :none
      end
    end
  end
  
  def locales_menu
    navigation.ul :html => { :class => "tabbed_menu right" } do |ul|
      t(:locales, :scope => [:shared, :headline]).each do |locale, language|
        ul.li h(language), root_path(:locale => locale) unless I18n.locale == locale
      end
    end
  end
  
  def authentication_menu
    navigation.ul :html => { :class => "tabbed_menu authentication alt_links" } do |ul|
      if authenticated?
        ul.li h(authenticated_user.screen_name),  t(".profile"), :html => { :class => :user }
        ul.li t(".logout").first,                 t(".logout").last + "?return_to=#{request.url}"
      else
        ul.li t(".login").first,                  t(".login").last + "?return_to=#{request.url}"
        ul.li t(".registration").first,           t(".registration").last
      end
    end
  end
  
  def main_menu
    navigation.ul :html => { :class => "tabbed_menu" } do |ul|
      ul.li t(:title, :scope => :services),   services_path,  :services, :orders => [:new, :create]
      ul.li t(:title, :scope => :requisites), requisite_path, :requisites                           if authenticated?
      ul.li t(:title, :scope => :orders),     orders_path,    :orders => [:index, :edit, :update]   if authenticated_requisite?
    end
  end
  
  def services_contextual_menu(service)
    navigation.ul :html => { :id => :contextual_menu, :class => :tabbed_menu } do |ul|
      ul.li t(:title, :scope => [:services, :show]),    service_path(service),            :services => :show
      ul.li t(:title, :scope => [:orders,   :new]),     new_service_order_path(service),  :orders => [:new, :create]  if authenticated? && authenticated_user.infosell_requisite && !service.blocks.empty?
      ul.li t(:title, :scope => [:services, :offer]),   offer_service_path(service),      :services => :offer         if service.offer?
      ul.li t(:title, :scope => [:services, :prices]),  prices_service_path(service),     :services => :prices        if service.prices?
    end
  end

end

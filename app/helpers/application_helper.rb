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
        ul.li h(authenticated_user.screen_name),  Passport::profile_url, :html => { :class => :user }
        ul.li t(".logout"),                       Passport::logout_url + "?return_to=#{request.url}"
      else
        ul.li t(".login"),                        Passport::login_url + "?return_to=#{request.url}"
        ul.li t(".registration"),                 Passport::registration_url
      end
    end
  end
  
  def main_menu
    navigation.ul :html => { :class => "tabbed_menu" } do |ul|
      ul.li t(:title, :scope => :services), services_path, :services
      ul.li t(:title, :scope => :requisites), requisite_path, :requisites
    end
  end
  
end

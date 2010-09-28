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
  
end

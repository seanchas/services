module AdminHelper

  def main_menu
    navigation.ul do |ul|
      ul.li content_tag(:p, t(:menu_title, :scope => [:admin, :infosell_resources])), admin_infosell_resources_path, :"admin/infosell_resources"
      ul.li content_tag(:p, t(:menu_title, :scope => [:admin, :infosell_resources_relations])), admin_infosell_resources_relations_path, :"admin/infosell_resources_relations"
      ul.li content_tag(:p, t(:menu_title, :scope => [:admin, :users])), admin_users_path, :"admin/users"
    end
  end

end

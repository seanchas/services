module OrdersHelper
  
  def contextual_menu
    navigation.ul :html => { :id => :contextual_menu, :class => :tabbed_menu } do |ul|
      ul.li t(".new"),    orders_path(:anchor => :new)
      ul.li t(".opened"), orders_path(:anchor => :opened)
      ul.li t(".closed"), orders_path(:anchor => :closed)
    end
  end
  
end

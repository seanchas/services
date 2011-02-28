module OrdersHelper
  
  def contextual_menu(orders)
    states = orders.collect(&:state).uniq
    navigation.ul :html => { :id => :contextual_menu, :class => :tabbed_menu } do |ul|
      ul.li t(".new"),    orders_path(:anchor => :new),     :none, :html => { :"data-anchor" => :new } if states.include?(:new)
      ul.li t(".opened"), orders_path(:anchor => :opened),  :none, :html => { :"data-anchor" => :opened } if states.include?(:opened)
      ul.li t(".closed"), orders_path(:anchor => :closed),  :none, :html => { :"data-anchor" => :closed } if states.include?(:closed)
    end
  end
  
end

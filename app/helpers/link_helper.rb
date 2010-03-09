module LinkHelper
  def order_edit_link(order, display)
    link_to display, :controller => :orders, :action => :edit, :id => order
  end
  
  def view_per_page_link(controller, action, per_page)
    link_to per_page.to_s, :controller => controller, :action => action, :per_page => per_page
  end
  
  def dish_edit_link(dish, display)
    link_to display, :controller => :menus, :action => :edit_dish, :id => dish
  end
  
  def menu_edit_link(menu, display)
    link_to display, :controller => :menus, :action => :edit_menu, :id => menu
  end
  
  def menu_dish_quantity(menu)
    return MenuDish.find_all_by_menu_id(menu).length
  end
end
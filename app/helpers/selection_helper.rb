module SelectionHelper
  def district_selection(default = "")
    select_tag :district,            
            options_for_select(District.get_all_selection, default),
            {:class => "dropdown"}
  end
  
  def delivery_time_selection(default = "")
    select_tag :delivery_time,            
            options_for_select(time_list, default),
            {:class => "dropdown"}
  end
  
  def time_list
    [
      ["11:30", "11:30"],
      ["12:00", "12:00"],
      ["12:30", "12:30"],
      ["13:00", "13:00"]
    ]
  end
  
  def zone_selection(default = "")
    select_tag :zone,            
            options_for_select(Zone.find(:all).map{|z| [z.name, z.id]}, default),
            {:class => "dropdown"}
  end
  
  def zone_list
    [
      ["A1", "A1"],
      ["A2", "A2"],
      ["A3", "A3"],
      ["A4", "A4"],
      ["A5", "A5"],
      ["B1", "B1"],
      ["B2", "B2"],
      ["B3", "B3"],
      ["B4", "B4"],
      ["B5", "B5"]
    ]
  end
  
  def status_selection(default = "")
    select_tag :status,            
            options_for_select(status_list, default),
            {:class => "dropdown"}
  end
  
  def status_updater(default ="", id = 0)
    select_tag :status,            
            options_for_select(status_list, default),
            {:class => "dropdown", :id => "status_update_#{id.to_s}", :name => "status_update_#{id.to_s}"}
  end
  
  def status_list
    [
      ["Mới", "new"],
      ["Đã giao - tốt", "good"],
      ["Đã giao - xấu", "bad"],
      ["Hủy", "cancel"],
      ["Không giao", "none"]
    ]
  end
  
  def categories_list(default = "")
    select_tag :category_id,
              options_for_select(Category.get_all_selection, default), {:class => "dropdown"}
  end
  
  def dishes_list(name, id, default = "")
    select_tag name, options_for_select(Dish.get_all_selection_by_category_id(id), default), {:class => "dropdown"}
  end
  
  def menu_list(default = "")
    select_tag :menu_id, options_for_select(Menu.get_all_selection, default), {:class => "dropdown"}
  end
end

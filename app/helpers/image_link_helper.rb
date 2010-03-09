module ImageLinkHelper
  def image_link(path, controller, action, object)
    link_to image_tag(path), {:controller => controller, :action => action, :id => object}
  end
  
  def image_link_with_confirm(path, controller, action, confirm, object)
    link_to image_tag(path), {:controller => controller, :action => action, :id => object}, {:confirm => confirm}
  end
end

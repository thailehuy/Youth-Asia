module TextDisplayHelper
  def category_name(object_id)
    category = Category.find_by_id(object_id)
    return category.name
  end
end

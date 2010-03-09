module AjaxHelper
  def prepare_customer_info(customer_id)
    customer = Customer.find_by_id(customer_id)
    render :update do |page|
      page[:customer_id].value = customer.id
      page[:customer_name].value = customer.name
      page[:address].value = customer.address
      page[:district].value = customer.district_id
      page[:phone].value = customer.phone
      page[:mobile].value = customer.mobile
      if customer.company
        page[:company_name].value = customer.company.name
        page[:company_id].value = customer.company_id
        page[:email].value = customer.company.email
        page[:zone].value = customer.company.zone_id
      end
      page[:customer_name].value = customer.name
    end
  end
end

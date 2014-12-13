class HraTaxFormula < TaxFormula
  extend ActiveSupport::Memoizable

  attr_accessor :rent_paid

  def employee_tds
    EmployeeTaxDetail.for_employee(employee).last
  end
  memoize :employee_tds
  
  def eligible_for_employee?
    !!employee_tds
  end
  
  def calculate
    if eligible_for_employee?
      # Get the amount to be calculated
      return amount - exemption
      # compute the applied HRA
      # compute the exmpt HRA
      # Return taxable amount for the HRA
    end
    amount
  end

  def rent_greater_than_10_percent_of_basic
    paid = rent_paid || employee_tds.try(:monthly_rent_paid) || amount
    ([(paid || 0) - ((basic || 0) *10/100.0),0.0].max).round(1)
  end
 
  def metro_based_exemption
    percentage_allowed = INDIAN_METROS.include?(employee.address.try(:city).try(:upcase)) ? 50 : 40
    ((basic || 0) * percentage_allowed/100.0).abs
  end
  
  def exemption
    [amount, rent_greater_than_10_percent_of_basic, metro_based_exemption].min
  end
  
end
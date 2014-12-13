class RetirementGratuity

  EARN_RATIO = 15/26
  EARN_RATION_NO_1972 = 1/2
  MAX_LIMIT = 350000
  MIN_EMPLOYMENT_YEARS = 5

  attr_accessor :employee, :resignation_date,
                :covered_under_pg72, :gratuity_due_to_death,
                :retirement_age

  def initialize(employee,resignation_date = Date.today,
                 covered_under_pg72 = true,
                 retirement_age = 58,
                 gratuity_due_to_death = false)
    @employee = employee
    @resignation_date = resignation_date
    @covered_under_pg72 = covered_under_pg72
    @gratuity_due_to_death = gratuity_due_to_death
    @retirement_age = retirement_age
  end

  def last_drawn_salary
    ep = employee.effective_package(resignation_date)
    ep.basic + ep.lookup_amount_for("DA")
  end

  def number_of_years_in_service
    if gratuity_due_to_death
      resignation_date - employee.commencement_date
    else
      employee.date_of_birth.years_since(retirement_age) - resignation_date
    end
  end

  def gratuity_base
    if covered_under_pg72?
      last_drawn_salary * EARN_RATIO * number_of_years_in_service.round
    else
      last_drawn_salary * EARN_RATIO_NO_1972 * number_of_years_in_service.floor
    end
  end

  def gratuity
    [gratuity_base,MAX_LIMIT].min
  end

  def eligible?
    number_of_years_of_service >= MIN_EMPLOYMENT_YEARS or gratuity_due_to_death?
  end

end

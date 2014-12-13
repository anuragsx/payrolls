class AddDescriptionToCalculators < ActiveRecord::Migration
  def self.up
    add_column :calculators, :description, :text

    #Let's add Some Description to every calculator
    begin
    SimpleLeaveCalculator.first.update_attribute("description","The leave/absence information entered is used to calculate the number of days for which the pay must be deducted")
    LeaveAccountingCalculator.first.update_attribute("description","Employer may grant a number of paid leaves to an employee for a period or specify how many can be earned depending on the days worked.")
    BasicCalculator.first.update_attribute("description","Only deals with fixed amount payable to employee, no other separate salary heads.")
    SimpleAllowanceCalculator.first.update_attribute("description","This package manager allows you to define the required salary heads individually on each employee")
    FlexibleAllowanceCalculator.first.update_attribute("description","This package manager allows you to define defaults on company, department or designation level which automatically apply to all employees that fall within the defined parameters.")
    DearnessReliefCalculator.first.update_attribute("description","This calculator is suitable for certain businesses and Govt. agencies that give out a certain government proscribed percentage as additional Dearness Relief on top of existing basic package to employees.")
    LoanCalculator.first.update_attribute("description","Some businesses extend loans to employees for various reasons. They specify the period for which the loan is extended or the installment that must be deducted at monthly intervals.")
    AdvanceCalculator.first.update_attribute("description","This calculator allows the business to give an advance to an employee during a month as advance. The advance given is then deducted from the salary given to the employee.")
    EsiCalculator.first.update_attribute("description","This calculator is used by businesses that are registered under ESI and have statutory obligations towards making deposits for and on behalf of their employees.")
    IncomeTaxCalculator.first.update_attribute("description","This calculator automatically deducts the TDS on an employee when they fall in the Tax net. The TDS deducted is based on the total earnings that the employee has had with the business so far.")
    SimpleIncomeTaxCalculator.first.update_attribute("description","TDS is calculated manually by the business for the employee, the payroll is used to simply update the fixed amount to be deducted as TDS each month.")
    PfCalculator.first.update_attribute("description","This calculator is used by businesses that are registered under Provident Fund and have statutory obligations towards making deposits for and on behalf of their employees.")
    InsuranceCalculator.first.update_attribute("description","This calculator allows businesses to deduct the monthly insurance policy premium and deposit it with an insurance company on a monthly basis until the policy premiums are required to be paid.")
    ExpenseClaimCalculator.first.update_attribute("description","This calculators assists the business by allowing monthly expense claims to be inserted on an employee with a description.")
    BonusCalculator.first.update_attribute("description","This calculator reports the total earnings for eligible employees and an exact bonus payout on each employee.")
    ProfessionalTaxCalculator.first.update_attribute("description","This calculator helps you determine your expenditure and deposit for Professional Tax.")
    GratuityCalculator.first.update_attribute("description","Certain Govt. agencies contribute a percentage of the employees earnings on a monthly basis towards a gratuity fund. Suitable if you are a Govt. Agency.")
    LabourWelfareCalculator.first.update_attribute("description","This calculator helps those companies remain compliant.")
    rescue
      nil
    end
  end

  def self.down
    remove_column :calculators, :description
  end
end

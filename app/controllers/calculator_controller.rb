class CalculatorController < ApplicationController

  @@calculators = {}
  before_filter :calculator_check

  def self.concerned_calculators(*params)
    @@calculators[self.to_s] ||= Array(params)
  end

  def calculator_check
    c = Array(calculator).map{|c|(c.to_s + "_calculator").classify}
    if @company.calculators.in_type(c).empty?
      flash[:error] = t('calculator.messages.unavailable_module')
      redirect_to company_calculators_path
    end
  end

  def calculator
    (@@calculators[self.class.to_s]) || controller_name.singularize
  end

end
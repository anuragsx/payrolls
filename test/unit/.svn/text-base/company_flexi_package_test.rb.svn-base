require File.dirname(__FILE__) + '/../test_helper'

class CompanyFlexiPackageTest < ActiveSupport::TestCase

  should_belong_to :company
  should_belong_to :salary_head
  should_have_many :flexible_allowances

  should_validate_presence_of :company_id, :salary_head_id, :lookup_expression, :position

#  def test_all_charges_for_company
#    setup_comapny_flexi_package
#    c = Factroy(:company)
#     p"_______________________"
#     p c
#    e = Factory(:employee, :company => c)
#    p CompanyFlexiPackage.all_charges_for_company(c, e)
#    p "_______________________________"
#  end
#
#  def test_determine_allowance
#    setup_comapny_flexi_package
#    Factory(:constant_flexible_allowance)
#    p @company_flexi.determine_allowance("company")
#    p "+++++++++++++++++++++++++++"
#  end

  private

  def setup_comapny_flexi_package   
    @company_flexi = Factory(:company_flexi_package)
  end

end

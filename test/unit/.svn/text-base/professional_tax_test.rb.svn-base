
require File.dirname(__FILE__) + '/../test_helper'

class ProfessionalTaxSlabTest < ActiveSupport::TestCase

  should_validate_presence_of :zone, :salary_min, :salary_max, :tax_amount, :applicable_date
  should_validate_numericality_of :salary_min, :salary_max, :tax_amount


  should_have_named_scope "for_zone(2)", :conditions => ["zone = ?",2]
  should_have_named_scope "for_gross(10000)", :conditions => ["? between salary_min and salary_max",10000]
  #should_have_named_scope "for_date(Date.parse('2008-05-07'))", :conditions => ["? > applicable_date and ? = if null(applicable_month,?)",
  #                                                  Date.parse('2008-05-07'),05,05],
  #                                                  :limit => 1,
  #                                                  :order => 'applicable_date desc, applicable_month desc'


  def test_zone
    setup
  end

  def setup
    @tax_slab = Factory(:professional_tax_slab)
  end

end




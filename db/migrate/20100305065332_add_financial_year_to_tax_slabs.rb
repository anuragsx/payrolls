class AddFinancialYearToTaxSlabs < ActiveRecord::Migration
  def self.up
    add_column :tax_slabs, :financial_year, :string

    TaxSlab.reset_column_information
    TaxSlab.all.each do |ts|
      ts.update_attribute(:financial_year, 2009)
    end
    women = TaxCategory.find_or_create_by_category("Females")
    women.tax_slabs.create(:min_threshold => 0, :max_threshold => 190000.0, :tax_rate => 0.0, :financial_year => 2010)
    women.tax_slabs.create(:min_threshold => 190001.0, :max_threshold => 500000.0, :tax_rate => 10.0, :financial_year => 2010)
    women.tax_slabs.create(:min_threshold => 500001.0, :max_threshold => 800000.0, :tax_rate => 20.0, :financial_year => 2010)
    women.tax_slabs.create(:min_threshold => 800001.0, :tax_rate => 30.0, :financial_year => 2010)
    male = TaxCategory.find_or_create_by_category("Males")
    male.tax_slabs.create(:min_threshold => 0, :max_threshold => 160000.0, :tax_rate => 0.0, :financial_year => 2010)
    male.tax_slabs.create(:min_threshold => 160001.0, :max_threshold => 500000.0, :tax_rate => 10.0, :financial_year => 2010)
    male.tax_slabs.create(:min_threshold => 500001.0, :max_threshold => 800000.0, :tax_rate => 20.0, :financial_year => 2010)
    male.tax_slabs.create(:min_threshold => 800001.0, :tax_rate => 30.0, :financial_year => 2010)
    over65 = TaxCategory.find_or_create_by_category("Senior Citizen(Over 65)")
    over65.tax_slabs.create(:min_threshold => 0, :max_threshold => 240000.0, :tax_rate => 0.0, :financial_year => 2010)
    over65.tax_slabs.create(:min_threshold => 240001.0, :max_threshold => 500000.0, :tax_rate => 10.0, :financial_year => 2010)
    over65.tax_slabs.create(:min_threshold => 500001.0, :max_threshold => 800000.0, :tax_rate => 20.0, :financial_year => 2010)
    over65.tax_slabs.create(:min_threshold => 800001.0, :tax_rate => 30.0, :financial_year => 2010)
  end

  def self.down
    
    remove_column :tax_slabs, :financial_year
  end
end

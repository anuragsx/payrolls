class CompanyFlexiPackage < ActiveRecord::Base

  LOOKUP_EXPRESSION = ["Company","Department","Employee"]

  belongs_to :company
  belongs_to :salary_head
  has_many :flexible_allowances,:dependent => :destroy
  accepts_nested_attributes_for :flexible_allowances, :allow_destroy => true

  validates :company_id, :salary_head_id, :lookup_expression, :position, :presence => true
  validate_on_create :check_existing
  before_save :remove_blank_flexible_allowances

  scope :for_company, lambda{|c|{:conditions => ["company_id = ?",c]}}
  scope :for_head, lambda{|c|{:conditions => ["salary_head_id = ?",c]}}
  scope :positionally, :order => "salary_head_id,position"

  def self.all_charges_for_company(company,employee)
    company_allowances = for_company(company).positionally.all.group_by{|x|x.salary_head}
    company_allowances.keys.map do |head|
      # For each head determine the ultimate charge
      fallbacks = company_allowances[head]
      fallbacks.detect{|f|
        category = f.lookup_expression == "Employee" ? employee : employee.send(f.lookup_expression.downcase)
        @val = f.determine_allowance(category)
        !!@val
      }
      @val
    end.reject{|j|j.blank?}
  end

  def determine_allowance(category)
    FlexibleAllowance.for_head(salary_head).for_category(category).for_company(company).first
  end

  def self.search(company,employee)
    cf= []
    company_allowances = CompanyFlexiPackage.all(:order => "position",:conditions => "company_id = #{company.id} and lookup_expression = 'Employee'").group_by(&:salary_head_id)
    flexi_allowance = FlexibleAllowance.find_all_by_category_type_and_category_id_and_company_id("Employee",employee.id,company.id)
    flexi_allowance.each do |e|
      cf << e.company_flexi_package
    end    
    company_allowances = company_allowances.values.flatten - cf    
  end

  def create_company_flexi_package(params,company)
    head = params[:simple_allowance]
    if head && params[:lookup]
      begin
        self.transaction do
          head.each do |key,value|
            params[:lookup][key].each do |k,l|
              unless l.blank?
                CompanyFlexiPackage.create!(:company => company, :salary_head_id => value,:lookup_expression => l,:position => k)
              end
            end
          end
          true
        end        
      rescue StandardError => e
        errors.add_to_base(e.to_s)
        false
      end
    else
      errors.add_to_base("You have not choosen any salary Head")
      false
    end
  end

  private

  def remove_blank_flexible_allowances   
    flexible_allowances.delete_if do |f|     
      f.value.blank? or f.category_type.blank? or f.category_id.blank?
    end
  end

  def check_existing   
    f=CompanyFlexiPackage.find_by_company_id_and_salary_head_id_and_lookup_expression(company_id,salary_head_id,lookup_expression)
    if f
      false
      errors.add_to_base("Package is already created or you choose multiple package")
    else
      true
    end
  end

end

class CompanyGrade < ActiveRecord::Base

  belongs_to :company
  has_many :employee_packages

  validates :pay_scale, :company_id, :presence => true

  def pay_scale_and_name
    "(#{name}) #{pay_scale} "
  end

end

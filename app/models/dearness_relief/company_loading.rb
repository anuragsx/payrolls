class CompanyLoading < ActiveRecord::Base

  belongs_to :company
  has_many :salary_slip_charges, :as => :reference

  validates :company_id, :loading_percent, :presence => true
  validates_numericality_of :loading_percent, :less_than => 100, :greater_than => 0

  scope :for_company, lambda{|c| {:conditions => ["company_id = ?",c]}}
  scope :effective_for_date, lambda{|d| {:conditions => ["created_at < ?",d], :order => 'created_at desc', :limit => 1}}

end

class CompanyBonus < ActiveRecord::Base
  belongs_to :company

  scope :for_company, lambda{|company| {:conditions => {:company_id => company}}}
  scope :for_date, lambda{|date| {:conditions => ["release_date >= ?", date], :order => 'release_date', :limit => 1}}

  validates :company_id, :release_date, :bonus_percent, :presence => true
  validates :bonus_percent, :greater_than => 0, :less_than => 100, :numericality => { :only_integer => true }

  def formatted_release_date
    "#{Time::RFC2822_MONTH_NAME[release_date.month-1]} #{release_date.year}"
  end
  
end

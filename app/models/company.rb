class Company < ActiveRecord::Base
  require 'memoist'
  extend Memoist
  #extend ActiveSupport::Memoizable


  attr_accessible :name, :subdomain, :package_id, :owner_attributes, :pan, :tan, :address_attributes, :round_by,
      :want_protected_pdf, :pdf_password, :default_employee_pdf_password
  
  authenticates_many :user_sessions
  has_one :owner, :class_name => 'User',:dependent => :destroy
  has_one :bank, :dependent => :destroy
  accepts_nested_attributes_for :owner,:allow_destroy => true

  has_many :departments, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :employees, :dependent => :destroy
  has_many :active_employees, :class_name => 'Employee', :conditions => ["status = 'active'"]
  has_many :salary_sheets, :dependent => :destroy
  has_many :salary_slips, :dependent => :destroy
  has_many :company_calculators, :order => 'position', :dependent => :destroy
  has_many :calculators, :through => :company_calculators, :order => 'position'
  has_many :employee_packages # Probably not really used
  belongs_to :package
  has_many :leave_types, :through => :company_leaves
  has_many :company_grades
  #has_many :creditcards
  
  has_one :address, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :address, :allow_destroy => true
  #TODO
  #has_attached_file :logo, :styles => {:medium => "300x149>", :thumb => "75x75>",:large=>"400x400>" },
    #:default_url=>""
  #validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png','image/jpg']
  #validates_presence_of :name, :package
  validates :name, :package, :presence => true
  #validates_uniqueness_of :subdomain, :on => :create
  validates :subdomain, :uniqueness => true

  validates :subdomain, :length => { :in => 3..20 }, :on => :create
  #validates_length_of :subdomain, :within => 3..20, :on => :create


  #validates_exclusion_of :subdomain, :in => , :on => :create

  validates :subdomain, :exclusion => { :in => $subdomain_exclusion }, :on => :create

  #validates_format_of :subdomain, :with => /^[A-Za-z0-9-]+$/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :on => :create

  validates :subdomain, :format => { :with => /^[A-Za-z0-9-]+$/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :on => :create}

  #validates_presence_of :pdf_password, :default_employee_pdf_password, :if => Proc.new { |com| com.want_protected_pdf}
  validates :pdf_password, :default_employee_pdf_password, :presence => true, :if => Proc.new { |com| com.want_protected_pdf}

#  before_save :validate_credit_card
#  attr_accessor :creditcard
  attr_writer :package_name
  attr_reader :calculator_types

  
  def before_save
    unless want_protected_pdf
      self.pdf_password = ""
      self.default_employee_pdf_password = ""
    end
  end
  
  def calculator_types
    @calculator_types ||= calculators.index_by{|c|c.type}
  end
  
  def calculator_exists?(cal_type)
    calculator_types.key?((cal_type.to_s.singularize+"_calculator").classify)
  end

  def find_owner
    owner = self.users
    owner.first
  end

  def allowance_heads
  end

  def leave_calculator
    calculators.detect{|c|c.is_leave?}
  end

  def package_calculator
    puts "-----------------------------"
    puts calculators.inspect
    calculators.detect{|c|c.is_package?}
  end

  def allowance_calculators
    calculators.select{|c|c.is_allowance?}
  end

  def deduction_calculators
    calculators.select{|c|c.is_deduction?}
  end

  def subtotal_calculators
    calculators.select{|c|c.is_subtotal?}
  end

  def has_calculator?(calculator)
    !!calculators.detect{|c| c.class == calculator}
  end

  def package_name=(name)
    self.package = Package.find_by_name(name)
  end

  def max_employees
    self.package.max_employees
  end

  def can_add_employees?
    max_employees.to_i > self.employees.count
  end

  def complete_address
    address.complete_address if address
  end

  def round
    round_by || 0
  end
  memoize :round

  private

  #  def validate_credit_card
  #    creditcards.build(@creditcard).check_credit_card if @creditcard
  #  end

end
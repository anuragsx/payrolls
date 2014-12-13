class Address < ActiveRecord::Base

  attr_accessible :address_line1, :address_line2, :address_line3, :city, :pincode, :phone_number, :state, :mobile_number

  belongs_to :addressable, :polymorphic => true
  before_validation :check_mobile_format

  #validates_format_of :pincode, :with => /\d\d\d\d\d\d/, :allow_blank => true
  validates :pincode, :format => { :with => /\d\d\d\d\d\d/,
                                   :allow_blank => true }
  validates :mobile_number, :format => {:with => /\A(\+\d{12})\Z/,
    :allow_blank => true, :message => "should be correct format"}

  validates :mobile_number, :presence => true , :if => proc {|obj| obj.company_address? }
  #validates_presence_of :mobile_number , :if => proc {|obj| obj.company_address? }

  attr_reader :complete_address

  def pin_code_with_label
    return "Pin Code : #{pincode}" unless pincode.blank?
  end

  def complete_addresslines
    [address_line1,address_line2,address_line3].compact.join(", ")
  end

  def complete_address
    [address_line1,address_line2,address_line3,city, pin_code_with_label, state].compact.reject{|x|x.blank?}.join(", ")
  end

  def check_mobile_format
    self.mobile_number = mobile_number.gsub(' ','')  if mobile_number
  end

  def company_address?
    self['addressable_type'] == 'User'
  end

end

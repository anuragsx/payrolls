class EsiType < ActiveRecord::Base

  validates :name, :employee_size, :employee_contrib_percent,
                        :employer_contrib_percent, :basic_threshold, :presence => true

end

module LabourWelfareCategoriesHelper
  def build_slab(slab)
    max = slab.salary_max
    last_string = (max == 999999 ? "and above" : "#{t('common.to')} #{max.to_i}")
    "#{slab.salary_min.to_i} #{last_string}"
  end

  def get_frequency(count)
    if count.to_i == 1
      "Annual"
    elsif count.to_i == 2
      "Half-Yearly"
    elsif count.to_i == 4
      "Quarterly"
    elsif count.to_i == 12
      "Monthly"
    else
      "Not Applicable"
    end
  end
end

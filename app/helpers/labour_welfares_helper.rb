module LabourWelfaresHelper

  def get_partial(count)
    if count.to_i == 1
      "annual"
    elsif count.to_i == 2
      "half_yearly"
    elsif count.to_i == 4
      "quarterly"
    elsif count.to_i == 12
      "monthly"
    end
  end
    
end

class LabourWelfareCategoriesController < ApplicationController
  def index
    @welfares = LabourWelfare.all.sort{|a,b| a.zone <=> b.zone}
  end

  def slabs
    @welfare = LabourWelfare.find(params[:id])
    @slabs = @welfare.labour_welfare_slabs
  end
end

pdf = Prawn::Document.new()
pdf.font "Courier"
pdf.font_size =10
page = 0
pdf.header [0,730] do
  pdf.text "Page: #{page+=1}",:size=>9, :align=>:left
  pdf.text @company.name, :align=>:center,:style => :bold, :size => 15
  pdf.text @company.complete_address, :align=>:center, :size => 10
  pdf.text "#{@employee.name} leaves for #{@this_year}", :align=>:center,:style => :bold, :size => 12
end
pdf.move_down(40)
data = (@monthlies.map do |leave|
  [leave.created_at.to_s(:short_month_and_year),
  leave.try(:present) || 0,
  leave.try(:absent) || 0,
  leave.try(:late_hours) || 0,
  leave.try(:overtime_hours) || 0,
  ]
end) << ["Total", @monthlies.sum(0){|x|x.present || 0}, @monthlies.sum(0){|x|x.absent || 0},
         @monthlies.sum(0){|x|x.overtime_hours || 0}, @monthlies.sum(0){|x|x.late_hours || 0}]
pdf.table data,
  :headers => ['Month', "Present", "Absent", "Late hours", "Over time hours"],
  :font_size => 10,
  :border_style => :grid,
  :vertical_padding => 2,
  :border_color =>"a09d9d",
  :width => 550,
  :header_color=>"dddddd"

pdf.footer([-10,5],:width =>560) do
  pdf_footer(pdf)
end



pdf = Prawn::Document.new()
pdf.font "Courier"
pdf.font_size =10
pdf.text @company.name, :align=>:center,:style => :bold, :size => 15
pdf.text @company.complete_address, :align=>:center, :size => 10
pdf.text "Leave detail for #{@salary_sheet.formatted_run_date}", :align=>:center,:style => :bold, :size => 12
pdf.move_down(30)
data = (@leaves.map do |leave|
  [leave.employee.name,
  leave.present,
  leave.late_hours,
  leave.overtime_hours,
  leave.absent
  ]
end) << ["Total",@leaves.sum('present'),@leaves.sum('late_hours'),@leaves.sum('overtime_hours'),@leaves.sum('absent')]
pdf.table data,
  :headers => ['Employee',"Present","Late hours ","Over time hours ",
               "Absent"],
  :font_size => 10,
  :border_style => :grid,
  :vertical_padding => 2,
  :border_color =>"a09d9d",
  :width => 550,
  :header_color=>"dddddd"
pdf.footer([-10,5],:width =>560) do
  pdf_footer(pdf)
end



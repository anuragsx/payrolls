pdf = Prawn::Document.new(:page_layout=>:landscape,:page_size => 'A4',:margin_left => 10,:margin_right => 10)
pdf.font "Courier"
pdf.font_size =10
pdf.styles :present => {:color => "7F7F7F" }
body = []
@presenter.employees.each do |emp|
  data =[emp.name]
  @presenter.dates.each{|x| data <<  @presenter.type(emp,x)}
  body << data
end
pdf.bounding_box [-30,540] ,:width=> 880,:height => 520 do
pdf.text @company.name, :align=>:center, :size => 15
pdf.text @company.complete_address, :align=>:center, :size => 10
pdf.text "Attendance Sheet for #{@date.to_s(:date_month_and_year)}", :align => :center, :size => 12
  unless body.blank?
    pdf.table body,
      :headers => ["Name"].concat(@presenter.dates.map{|x|x.day}),
      :header_color=>"EFEFEF",
      :font_size => 10,
      :border_style => :grid,
      :column_widths => {0 => 130,1 => 22,2 => 22,3=> 22, 4=>22, 5=>22,
                         6=>22,7=>22,8=>22,9=>22},
      :width=> 820,
      :border_color =>"DFDFDF"
  end
end
pdf.footer([-20,20],:width => 820) do
  pdf.text "Note:  <span class='present'>*</span> => Present,  X => Absent,  cl => Casual Leave,  pl => Privilege Leaves,  sl  => Sick Leaves.",:font_size => 6
end



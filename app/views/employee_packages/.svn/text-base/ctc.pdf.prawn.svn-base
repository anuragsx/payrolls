pdf.font "Courier"
pdf.font_size 12
page = 0
pdf.header [0,740] do
  pdf.text "Page: #{page+=1}",:size=>9, :at => [0,720]
  pdf.text Time.now.to_s(:salaree_time), :at=>[430,720], :size => 9 
  pdf.text @company.name, :align=>:center, :style => :bold
  pdf.text @company.complete_address, :align=>:center, :size=>10
  pdf.text "CTC of #{@employee.name.capitalize}", :align=>:center
  pdf.move_down 20
  pdf.text "Effective from #{@employee_package.start_date.strftime('%B %Y')}", :align=>:center
  pdf.text "Ends On #{@employee_package.end_date.strftime('%B %Y')}", :align=>:center if @employee_package.end_date.year != 9999
end
pdf.footer([-10,5],:width =>560) do
  pdf_footer(pdf)
end
pdf.bounding_box [0,660], :width=> 200 ,:height => 490 do
  data = [["Basic", @employee_package.basic, @employee_package.basic * 12]]
  @employee_package.additional_package_for_month.each do |arr|
    arr.each do |head, value|
      data << [head.name,value, value * 12]
    end
  end
  data << ["<b>Total CTC</b>", "", @employee_package.ctc]
  pdf.table data,
    :row_colors => ["eeeeee","ffffff"],
    :headers => ["Salary Head","Monthly","CTC"],
    :align_headers => :center,
    :header_color=>"dddddd",
    :border => 0,
    :width => 560,
    :horizontal_padding => 3,
    :border_color =>"a09d9d",
    :border_style => :grid
end

pdf.font "Courier"
pdf.font_size  12
pdf.header [-20,740] do
  pdf.text Time.now.to_s(:salaree_time), :at=>[460,710],:size=>8
  pdf.text "Page: #{pdf.page_count}",:size=>8, :at => [0,710]
  pdf.text @company.name, :align => :center
  pdf.text @company.complete_address, :align => :center
  pdf.text "Insurance Premium for: #{@salary_sheet.formatted_run_date}", :align=>:center
  pdf.text DEFAULT_INSURANCE_COMPANY,:align=>:center
end
pdf.footer([-20,5],:width =>580) do
  pdf_footer(pdf)
end
data = Array.new
@charges.each_with_index do |charge,i|
  data << [i+1,charge.employee.name.titleize,charge.reference.name,charge.amount.abs]
end
data << [{:text => "<b>Total</b>", :colspan => 3},{:text => "<b>#{@charges.sum(&:amount).abs}</b>"}]
pdf.bounding_box [-20,690], :width=>580, :height=> 680 do
  pdf.table data,
    :row_colors => ["eeeeee","ffffff"],
    :font_size => 10,
    :headers => ["S.no.","Employee Name","Policy No","Premium Amount"],
    :align_headers => :center,
    :header_color=>"dddddd",
    :border => 0,
    :width => 580,
    :horizontal_padding => 3,
    :border_color =>"a09d9d",
    :border_style => :grid,
    :align => {3 => :right },
    :position=>:center
end
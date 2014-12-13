pdf.font "Courier"
sm=10
sn=0

pdf.header [-20,740] do
    pdf.text Time.now.to_s(:salaree_time), :at=>[480,710], :size => sm-2
    pdf.text "Page: #{sn+=1}",:size=>sm-2, :at => [0,710]
    pdf.move_down(30)
    pdf.text @company.name, :align => :center
    pdf.text @company.complete_address, :align => :center, :size => sm
    pdf.move_down(10)
    pdf.text "EMI Sheet for: #{@salary_sheet.formatted_run_date}", :align=>:center
end
pdf.footer([-20,5],:width => 560) do
  pdf_footer(pdf)
end
data = Array.new
@charges.each_with_index do |charge,i|
   data << [i+1,charge.employee.name.titleize,charge.amount.abs]
end
data << [{:text => "<b>Total</b>", :colspan => 2},{:text => "<b>#{@charges.sum{|x|x.amount}.abs}</b>"}]

pdf.bounding_box [-10,650], :width=>580 ,:height => 750 do
    pdf.table data,
              :row_colors => ["eeeeee","ffffff"],
              :font_size => sm-1,
              :headers => ["S.no.","Employee Name","EMI"],
              :align_headers => :center,
              :header_color=>"dddddd",
              :border => 0,
              :width => 580,
              :horizontal_padding => 3,
              :border_color =>"a09d9d",
              :border_style => :grid,
              :align=> {2 => :right},
              :position=>:center              
end
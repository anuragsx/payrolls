pdf.footer([-10,5],:width =>560) do
  pdf_footer(pdf)
end
pdf.font "Courier"
sm=10
p=0
pdf.header [0,740] do
  pdf.text Time.now.to_s(:salaree_time), :at=>[430,720], :size => sm-2
  pdf.text "Page: #{p+=1}",:size=>sm-2, :at => [0,720]
  pdf.text @company.name, :align=>:center, :size=> 20
  pdf.text @company.complete_address, :align=>:center, :size=>13
  pdf.move_down 10
  pdf.text "Expenses", :align=>:center, :size=> sm+3
end
pdf.bounding_box [-10,680], :width=>570 ,:height => 650 do
  @expenses.each do |month,expenses|
    pdf.text "For month #{Date.new(@this_year,month,1).to_s(:month_and_year)}", :align => :center, :size => sm+1
    pdf.table expenses.map{|expense| [expense.employee.name, expense.amount]},
      :row_colors => ["eeeeee","ffffff"],
      :font_size => sm-1,
      :headers => ["Employee name","Amount"],
      :align_headers => :center,
      :header_color=>"dddddd",
      :border => 0,
      :width => 580,
      :horizontal_padding => 3,
      :border_color =>"a09d9d",
      :border_style => :grid,
      :position=>:center
    pdf.start_new_page
  end
end
pdf.footer([-20,5],:width =>580) do
  pdf_footer(pdf)
end
pdf.font "Courier"
pdf.font_size 12
pdf.header [-20,740] do
    pdf.text Time.now.to_s(:salaree_time), :at=>[480,710], :size => 8
    pdf.text "Page: #{pdf.page_count}",:size=>8, :at => [0,710]
    pdf.text @company.name, :align=>:center
    pdf.text @company.complete_address, :align=>:center
   pdf.text "Insurance Register", :align=>:center
end
unless @insurances.blank?
  data = Array.new
  pdf.bounding_box [-20,700], :width=>580 ,:height =>680 do
    @insurances.each_with_index do |insurance,i|
      data << [i+1,insurance.employee.name,insurance.description,insurance.monthly_premium.round(2)]
    end
    data << [{:text => "Total",:colspan => 3,:font_style => :bold},@insurances.sum(&:monthly_premium).round(2)]
    pdf.table data,
              :row_colors => ["eeeeee","ffffff"],
              :font_size => 10,
              :headers => ["S.No.","Employee name","Policy Name","Monthly Premium"],
              :align_headers => :center,
              :header_color=>"dddddd",
              :border => 0,
              :width => 580,
              :horizontal_padding => 3,
              :border_color =>"a09d9d",
              :border_style => :grid,
              :position=>:center
  end
end




pdf.font "Courier"
pdf.font_size 12
page = 0
pdf.header [0,740] do
   pdf.text "Page: #{page+=1}",:size=>9, :at => [0,720]
   pdf.text Time.now.to_s(:salaree_time), :at=>[430,720], :size => 9
   pdf.text @company.name, :align=>:center,:style => :bold
   pdf.text @company.complete_address, :align=>:center, :size=>10
   pdf.text "Bonus Register of #{@bonuses.first.charge_date.year}", :align=>:center
end
pdf.footer([-10,5],:width =>560) do
  pdf_footer(pdf)
end
pdf.bounding_box [0,660], :width=> 200 ,:height => 490 do
  data = (@bonuses.map do |bonus|
    [@bonuses.index(bonus)+1,Employee.find_by_id(bonus.reference_id).name ,
    bonus.amount,
    bonus.base_charge]
  end) << ["", Prawn::Table::Cell.new( :text => "<b>Total</b>"),
          Prawn::Table::Cell.new( :text => "<b>#{sprintf('%12s:',@bonuses.sum(&:base_charge))}</b>"),
          Prawn::Table::Cell.new( :text => "<b>#{@bonuses.sum(&:amount)}</b>")
          ]
  pdf.table data,
    :row_colors => ["eeeeee","ffffff"],
    :headers => ["S.no.","Name","Amount","Base Charge"],
    :align_headers => :center,
    :header_color=>"dddddd",
    :border => 0,
    :width => 560,
    :horizontal_padding => 3,
    :border_color =>"a09d9d",
    :border_style => :grid
end

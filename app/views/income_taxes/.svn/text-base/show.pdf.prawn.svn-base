page = 0
pdf.header [-10,740] do
   pdf.text "Page: #{page+=1}",:size=>9, :at => [0,720]
   pdf.text Time.now.to_s(:salaree_time), :at=>[430,720], :size => 9
   pdf.text @company.name, :align=>:center,:style => :bold
   pdf.text @company.complete_address, :align=>:center, :size=>10
   pdf.text "Income Tax Register For #{@presenter.month_date}", :align=>:center
end

pdf.footer([-10,5],:width =>560) do
  pdf_footer(pdf)
end
pdf.font "Courier"
pdf.font_size 12
pdf.bounding_box [-10,660], :width=> 560 do
  @presenter.departments.each do |dept|
    pdf.text "Department:#{dept[:name]}",:style => :bold_italic
    index =0
    data = dept[:slips].map{|slip| [index+1,slip[:name],slip[:tax],slip[:edu_cess],slip[:tds]]}
    data << [{:text => 'Total',:colspan => 2},dept[:total_tax],dept[:total_edu_cess],dept[:total_tds]]
    pdf.table data,
      :headers => ["S.no.","Employee","Income Tax","Edu Cess","Total Income Tax"],
      :align_headers => :center,
      :header_color=>"dddddd",
      :border => 0,
      :width => 560,
      :horizontal_padding => 3,
      :border_color =>"a09d9d",
      :border_style => :grid
    pdf.start_new_page
  end
  i =0
  summary_data = @presenter.departments.map{|dept|[i+1,dept[:name],dept[:total_tax],dept[:total_edu_cess],dept[:total_tds]]}
  summary_data  <<  [{:text => "Net",:colspan => 2},
            @presenter.total_tax,@presenter.total_edu_cess,@presenter.total_tds]
 
  pdf.table summary_data,
    :headers => ["#","Department Name","Total Income Tax",
                 "Total Edu Cess","Total Income Tax"],
    :align_headers => :center, :header_color=>"dfdfdf", :width => 560,
    :border_width => 1, :border_color =>"9F9F9F",
    :border_style => :grid, :position=>:center
end

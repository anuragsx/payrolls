include SalarySheetsHelper
module Presenter

  def prawn_generated_salary_sheet_pdf(file_name=nil)
    @salary_sheet = @presenter.salary_sheet
    @company = @presenter.company
    pdf = Prawn::Document.new(:page_layout=>:landscape, :page_size => "A4")
    (pdf.encrypt_document :user_password => @company.pdf_password)if @company.want_protected_pdf
    pdf.font "Courier"
    pdf.font_size 12
    salary_sheet_pdf(pdf)
    @presenter.departments.each do |department|
      department[:slips].map do |s|
        pdf.start_new_page(:layout=> :portrait,:size => "A4")
        salary_slip_pdf(pdf,department[s])
      end
    end
    unless @company.bank.blank?
      pdf.start_new_page(:layout=> :portrait,:size => "LETTER")
      bank_statement_pdf(pdf)
    end
    pdf.start_new_page(:layout=> :portrait,:size => "LETTER")
    @presenter = SalarySheetEsiPresenter.new(@company,@salary_sheet)
    esis(pdf)
    pdf.start_new_page(:layout=>:landscape,:size => "A4")
    @presenter = SalarySheetPfPresenter.new(@company,@salary_sheet)
    pfs(pdf)
    if file_name
      pdf.render_file(file_name)
    else
      send_data(pdf.render,:filename => company_file_name(:duration => @presenter.month_date), :type => 'application/pdf')
    end
  end

  def prawn_generated_salary_slip_pdf(file_name=nil)
    @company = @presenter.company
    pdf = Prawn::Document.new(:page_size => "A4")
    pdf.font "Courier"
    (pdf.encrypt_document :owner_password => @company.pdf_password,:user_password => @presenter.employee.pdf_password || @company.default_employee_pdf_password )if @company.want_protected_pdf
    salary_slip_pdf(pdf,@presenter)
      pdf.render_file(file_name)
      #send_data(pdf.render,:filename => company_file_name(:duration => @presenter.month_date), :type => 'application/pdf')
    end

  def prawn_generated_bank_statement_pdf(salary_sheet)
    pdf = Prawn::Document.new(:size => "A4")
    pdf.font "Times-Roman"
    @company = salary_sheet.company
    @salary_sheet = salary_sheet
    bank_statement_pdf(pdf)
    send_data(pdf.render, :filename => company_file_name(:controller_name => '', :duration => @salary_sheet.formatted_run_date), :type => 'application/pdf')
  end

  def prawn_generated_pfs_pdf
    pdf = Prawn::Document.new(:page_layout=>:landscape,:page_size => "A4")
    pdf.font "Courier"
    pdf.font_size 12
    pfs(pdf)
    send_data(pdf.render, :filename => company_file_name(:action => "register", :duration => @presenter.short_date), :type => 'application/pdf')
  end

  def prawn_generated_esis_pdf
    pdf = pdf = Prawn::Document.new
    pdf.font "Courier"
    pdf.font_size 12
    esis(pdf)
    send_data(pdf.render, :filename => company_file_name(:action => "register", :duration => @presenter.month_date), :type => 'application/pdf')
  end

  def prawn_generated_gratuties_pdf
    pdf = Prawn::Document.new(:page_layout=>:landscape,:page_size => "A4")
    pdf.font "Courier"
    pdf.font_size 12
    gratuities(pdf)
    send_data(pdf.render, :filename => company_file_name(:action => "register", :duration => @presenter.short_date), :type => 'application/pdf')
  end
  
  def prawn_generate_condensed_salary_slip
    pdf = Prawn::Document.new(:page_size => 'A4',:margin_top => 5, :page_layout => :portrait)
    pdf.font "Courier"
    pdf.font_size 10
    x_axis = 820
    count =0
    size = @salary_sheet.salary_slips.size
    @salary_sheet.salary_slips.each do |slip|
      @presenter = SalarySlipPresenter.new(slip)
      count , x_axis = condensed_salary_slip(pdf,@presenter,count,x_axis)
      size -= 1
      if count == 4
        x_axis = 820
        count= 0
        pdf.start_new_page(:size => "A4",:top_margin=>10, :layout => :portrait)unless size== 0
      end
    end
    send_data(pdf.render, :filename => company_file_name(:action => "short", :duration => @salary_sheet.formatted_run_date), :type => 'application/pdf')
  end

  private
  def condensed_salary_slip(pdf,salary_slip,count,x_axis)
    pdf.font_size 8
    pdf.bounding_box [-10,x_axis-30], :width=>560 do
      pdf.text "#{@company.name} #{@company.complete_address}", :align=>:center,:style => :bold
      pdf.text "Salary Slip : #{@presenter.month_date}", :align=>:center
    end
    pdf.cell [-10, x_axis-45], :width=>80, :height=> 41,:border_color =>"a09d9d",:borders => [:left,:top]
    pdf.cell [69, x_axis-45], :width=>201, :height=> 41,:border_color =>"a09d9d",:borders => [:right,:top]
    pdf.bounding_box [-10,x_axis-45], :width=>280 do
      pdf.table [["Name",salary_slip.employee_detail[:name]],
        ["Department",salary_slip.department],
        ["Designation",salary_slip.employee_detail[:designation]]],
        :column_widths => {0 => 80,1 => 200},
        :align => {0 =>:left ,1 => :right},
        :border_width =>0,
        :width=>280,
        :vertical_padding => 1,
        :font_size => 8
    end
    pdf.cell [270, x_axis-45], :width=>180, :height=> 41,:border_color =>"a09d9d",:borders => [:top]
    pdf.cell [449, x_axis-45], :width=>101, :height=> 41,:border_color =>"a09d9d",:borders => [:right,:top]
    pdf.bounding_box [270,x_axis-45], :width=>280 do
      pdf.table [["PAN",salary_slip.employee_detail[:pan_no] || ""],
        ["Bank Account Number",salary_slip.employee_detail[:ac_no] || ""],
        ["PF Account Number",salary_slip.employee_detail[:pf_ac_no] || ""]],
        :column_widths => {0 => 180,1 => 100},
        :align => {0 =>:left ,1 => :right},
        :border_width =>0,
        :vertical_padding => 1,
        :font_size => 8
    end

    pdf.bounding_box [-10,x_axis-78], :width=>560 do
      pdf.table [["<b>ALLOWANCES</b>","<b>DEDUCTIONS</b>"]],
        :border_color =>"a09d9d",
        :column_widths => {0 => 280,1 => 280},
        :width => 560,
        :align => :center,
        :vertical_padding => 3,
        :font_size => 8
    end
    cell_length = [salary_slip.allowances.length,salary_slip.deductions.length,6].max
    cell_height = cell_length*12
    pdf.cell [-10, x_axis-93], :width=>180, :height=> cell_height,:border_color =>"a09d9d", :borders => [:top,:right,:left]
    pdf.cell [170, x_axis-93], :width=>100, :height=> cell_height,:border_color =>"a09d9d", :borders => [:top,:right,:left]
    pdf.bounding_box [-10,x_axis-93], :width=>280 do
      unless salary_slip.allowances.blank?
        pdf.table salary_slip.allowances.map{|c| [c.salary_head.name,c.base_charge,c.amount]}<< ["Gross Pay",salary_slip.gross_base_charge,salary_slip.gross.to_s],
          :column_widths => {0 => 100, 1 => 80, 2=> 100},
          :align => {0 =>:left ,1 => :right},
          :border_width =>0,
          :vertical_padding => 1,
          :font_size => 8
      end
    end

    pdf.cell [270, x_axis-93], :width=>180, :height=> cell_height,:border_color =>"a09d9d", :borders => [:top,:right,:left]
    pdf.cell [450, x_axis-93], :width=>100, :height=> cell_height,:border_color =>"a09d9d", :borders => [:top,:right,:left]
    pdf.bounding_box [270,x_axis-93], :width=>280 do
      unless salary_slip.deductions.blank?
        pdf.table salary_slip.deductions.map{|d|[d.salary_head.short_name,(d.amount*-1)]} <<["Gross Deduction",salary_slip.total_deduction.to_s],
          :column_widths => {0 => 180,1 => 100},
          :align => {0 =>:left ,1 => :right},
          :border_width =>0,
          :vertical_padding => 1,
          :font_size => 8
      end
    end
    pdf.cell [-10,(x_axis-93-cell_height)], :width=>560,:height => 15, :border_color =>"a09d9d",
      :text => sprintf('%s: %100.2f',"Net Take Home",salary_slip.net),:vertical_padding => 3,
      :font_style => :bold_italic,:horizontal_padding => 3,:font_size =>8,:borders => [:top,:bottom,:right,:left]
    x_axis = x_axis - 200
    [count +=1,x_axis]
  end


  def pfs(pdf)
    @presenter.departments.each do |department|
      pdf.footer([-20,5],:width =>800) do
        footer(pdf)
      end
      pdf.bounding_box [-30,550],:width =>820 do
        pdf.text "Page: #{pdf.page_count}",:align => :left,:size=>9
        pdf.move_up(5)
        pdf.text Time.now.to_s(:salaree_time),:align => :right,:size => 9
        company_information(pdf)
        pdf.text "PF Register: #{@salary_sheet.formatted_run_date}", :align=>:center
      end
      pdf.bounding_box [-30,510], :width=> 820 ,:height => 490 do
        pdf.text "Department: #{department[:name]}",:style => :bold_italic
        i = 0
        data = department[:slips].map do |slip|
          [i += 1,slip.salary_slip.employee.name.try("titleize"),
            slip.total_base_charge,
            slip.total_employee_contribution,
            slip.total_employer_pf_contribution,
            slip.total_employer_epf_contribution,
            slip.total_employer_contribution,
            slip.total_contribution]
        end
        data << ["","Total",
          department[:total_base_charge],
          department[:total_employee_contribution],
          department[:total_employer_pf_contribution],
          department[:total_employer_epf_contribution],
          department[:total_employer_contribution],
          department[:total_contribution]]

        pdf.table data,
          :row_colors => ["eeeeee","ffffff"],
          :headers => ["#","Name","Basic","Employee PF","Employer
            EPF","Employer PF","Employer Total","Total Contribution"],
          :align_headers => :center,
          :header_color=>"dddddd",
          :border => 0,
          :width => 820,
          :horizontal_padding => 3,
          :border_color =>"a09d9d",
          :border_style => :grid
      end
      pdf.start_new_page

    end
    pdf.bounding_box [-30,550],:width =>820 do
      pdf.text "Page: #{pdf.page_count}",:align => :left,:size=>9
      pdf.text Time.now.to_s(:salaree_time),:align => :right,:size => 9
      company_information(pdf)
      pdf.text "PF Register: #{@salary_sheet.formatted_run_date}", :align=>:center
    end
    @summary = [["Total Employee's contribution to EPF (A/C No. 1)",@presenter.total_employee_contribution],
      ["Total Employer's contribution to EPF (A/C No. 1)",@presenter.total_employer_epf_contribution],
      ["Total Employer's contribution to Pension (A/C No. 10)",@presenter.total_employer_pf_contribution],
      ["Administrative Charges (1.10% of Total Salary/Wages) (A/C No. 2)",@presenter.pension_admin],
      ["EDLI Charges (0.50% of Total Salary/Wages) (A/C No. 21)", @presenter.pension_edli],
      ["Inspection Charges (0.010% of Total Salary/Wages) (A/C No. 22)", @presenter.pension_inspection]
    ]
    pdf.bounding_box [-30,510], :width=> 820 ,:height => 490 do
      pdf.text "Summary",:style => :bold_italic
      pdf.table @summary << ["Total Challan Amount", @presenter.total_contribution],
        :row_colors => ["eeeeee","ffffff"],
        :border => 0,
        :width => 820,
        :horizontal_padding => 3,
        :border_color =>"a09d9d",
        :border_style => :grid
    end
  end

  def esis(pdf)
    @presenter.departments.each do |department|
      pdf.footer([-20,5],:width =>580) do
        footer(pdf)
      end
      pdf.bounding_box [-20,740],:width =>580 do
        pdf.text "Page: #{pdf.page_count}",:align => :left,:size=>9
        pdf.move_up(5)
        pdf.text Time.now.to_s(:salaree_time),:align => :right,:size => 9
        company_information(pdf)
        pdf.text "ESI Register: #{@presenter.month_date}", :align=>:center
      end
      pdf.bounding_box [-20,680], :width=>580, :height=>750 do
        pdf.text "Department: #{department[:name]}", :style => :bold_italic
        i = 0
        data = department[:slips].map do |slip|
          [i += 1,slip.salary_slip.employee.name.try("titleize"),
            slip.total_base_charge,slip.total_employee_contribution]
        end
        data << ["","Total",department[:total_base_charge],
          department[:total_employee_contribution]]
        pdf.table data,
          :row_colors => ["eeeeee","ffffff"],
          :headers =>["#","Name","Gross","Employee Total"],
          :align_headers => :center,
          :header_color=>"dddddd",
          :border => 0,
          :width => 580,
          :horizontal_padding => 3,
          :border_color =>"a09d9d",
          :border_style => :grid
      end
      pdf.start_new_page
    end
    pdf.bounding_box [-20,740],:width =>580 do
      pdf.text "Page: #{pdf.page_count}",:align => :left,:size=>9
      pdf.move_up(5)
      pdf.text Time.now.to_s(:salaree_time),:align => :right,:size => 9
      company_information(pdf)
      pdf.text "ESI Register: #{@presenter.month_date}", :align=>:center
    end
    summary = [["Total Employee's contribution",@presenter.total_employee_contribution],
      ["Total Employer's contribution", @presenter.total_employer_contribution],
      ["Grand Total", @presenter.total_contribution]
    ]
    pdf.bounding_box [-20,680], :width=>580, :height=>750 do
      pdf.text "Summary",:style => :bold_italic
      pdf.table summary,
        :row_colors => ["eeeeee","ffffff"],
        :border => 0,
        :width => 580,
        :horizontal_padding => 3,
        :border_color =>"a09d9d",
        :border_style => :grid
    end
  end

  def gratuities(pdf)
    @presenter.departments.each do |department|
      pdf.footer([-20,5],:width =>800) do
        footer(pdf)
      end
      pdf.header [-30,550],:width =>820 do
        pdf.text "Page: #{pdf.page_count}",:size=>9, :at => [0,510]
        pdf.text Time.now.to_s(:salaree_time), :at=>[700,510], :size => 9
        company_information(pdf)
        pdf.text "Gratuity Register: #{@salary_sheet.formatted_run_date}", :align=>:center
      end
      pdf.bounding_box [-30,510], :width=> 820 ,:height => 490 do
        pdf.text "Department: #{department[:name]}",:style => :bold_italic
        i = 0
        data = department[:slips].map do |slip|
          [i += 1,slip.salary_slip.employee.name.try("titleize"),
            slip.total_employee_earned,
            slip.total_employer_withheld]
        end
        data << ["","Total",
          department[:total_employee_earned],
          department[:total_employer_withheld]]
        pdf.table data,
          :row_colors => ["eeeeee","ffffff"],
          :headers => ["#","Name","Employee","Employer Total"],
          :align_headers => :center,
          :header_color=>"dddddd",
          :border => 0,
          :width => 820,
          :horizontal_padding => 3,
          :border_color =>"a09d9d",
          :border_style => :grid
      end
      pdf.start_new_page

    end
    @summary = [["Total Employee's contribution ",@presenter.total_employee_earned],
      ["Total Employer's contribution",@presenter.total_employer_withheld]]
    pdf.bounding_box [-30,510], :width=> 820 ,:height => 490 do
      pdf.text "Summary",:style => :bold_italic
      pdf.table @summary,
        :row_colors => ["eeeeee","ffffff"],
        :border => 0,
        :width => 820,
        :horizontal_padding => 3,
        :border_color =>"a09d9d",
        :border_style => :grid
    end
  end

  def bank_statement_pdf(pdf)
    @salary_slips = @salary_sheet.salary_slips.select{|s| !s.employee.account_number.blank? && s.employee.bank==@company.bank}
    slip_total = @salary_slips.map{|t| t.net}.sum
    sm=13
    pdf.header [-20,740] do
      pdf.text Time.now.to_s(:salaree_time), :at=>[450,710], :size => 10
    end
    pdf.footer([-20,5],:width =>580) do
      footer(pdf)
    end
    letter_header(pdf,@company.bank)
    pdf.move_down(30)
    pdf.text "Subject : Salary Transfer for #{Date.today.to_s(:month_and_year)}", :style => :bold,:size =>14
    pdf.bounding_box [0,480], :width => 550, :height => 200 do
      pdf.font_size = 14
      pdf.text "Dear Sir/Madam,"
      pdf.text " "
      pdf.text "#{@company.name} has an account in your bank (Account Number  #{@company.bank.company_account_number}). Kindly transfer the given salary amount of Rs.#{slip_total} from our account to the respective accounts given on the attached page."
    end
    letter_footer(pdf,@company)
    pdf.start_new_page
    pdf.bounding_box [-20,720], :width => 580, :height => 710 do
      data = Array.new
      pdf.text " "
      @salary_slips.each_with_index do |slip,i|
        employee = slip.employee
        data << [i+1,employee.name.try("titleize"),
          employee.account_number, slip.net] unless employee.account_number.blank?
      end
      data << [{:text => "<b>Total<b>",:colspan => 3},{:text => "<b>#{slip_total}</b>"}]

      pdf.table data,
        :row_colors => ["eeeeee","ffffff"],
        :font_size => sm-1,
        :headers => ["#","Name","Account No","Net Payable"],
        :align_headers => :center,
        :header_color=>"dddddd",
        :border => 0,
        :width => 550,
        :horizontal_padding => 3,
        :border_color =>"a09d9d",
        :border_style => :grid,
        :align=> {3 => :right},
        :position=>:center
    end
  end

  def letter_header(pdf,bank)
    pdf.move_down 100
    pdf.font_size = 13
    pdf.text "To,"
    pdf.text "The Manager,"
    pdf.text "#{bank.name.titleize},",:style => :bold
    pdf.text "#{bank.address.complete_addresslines}"
    pdf.text "#{bank.address.city}"
  end

  def letter_footer(pdf,company)
    pdf.text "Thanking You,"
    pdf.text " "
    pdf.text "Yours Faithfully,"
    pdf.text " "
    pdf.text " "
    pdf.text "#{company.owner.full_name}"
    pdf.text "(#{company.name})"
  end

  def salary_sheet_pdf(pdf)
    pdf.styles :code => {:white_space => :pre}
    @presenter.departments.each do |department|
      pdf.bounding_box [-30,550],:width =>820 do
        pdf.text "Page: #{pdf.page_count}",:align => :left,:size=>9
        pdf.move_up(5)
        pdf.text Time.now.to_s(:salaree_time),:align => :right,:size => 9
        company_information(pdf)
        pdf.text "Salary Sheet: #{@presenter.month_date}", :align=>:center, :size=> 10,:style => :italic
        pdf.text "Department: #{department[:name]}",:style => :bold_italic,:align=>:left
      end
      pdf.bounding_box [-30,490], :width=> 820 ,:height => 490 do
        pdf.text "Summaries", :style => :bold_italic, :align => :center
        s_no= 0
        body =[]
        allowances = @presenter.department_allowances(department)
        body << [{:text => "Allowances",:colspan => 3,:font_style => :bold_italic}]
        allowances[:heads].each {|key,value| body << [s_no+=1, key.short_name, value]}
        body << [{:text => "Total",:colspan => 2,:font_style => :bold_italic}, {:text => "#{allowances[:total]}",:font_style => :bold}]
        deductions = @presenter.department_deductions(department)
        body << [{:text => "Deductions",:colspan => 3,:font_style => :bold_italic}]
        deductions[:heads].each {|key,value| body << [s_no+=1, key.short_name, value]}
        body << [{:text => "Total",:colspan => 2,:font_style => :bold_italic}, {:text => "#{deductions[:total]}",:font_style => :bold}]
        body << [{:text => "Net",:colspan => 2, :font_style => :bold_italic}, {:text => "#{(allowances[:total] - deductions[:total])}",:font_style => :bold}]
        pdf.table body,
          :headers => ["S.No.","Salary Heads","Amount"],
          :column_widths => {0 => 60,1=> 400,2 => 360},
          :align_headers => :center,
          :width=> 820,
          :border_style => :grid,
          :align =>{2 => :right},
          :border_color =>"9F9F9F"
      end
      pdf.start_new_page
      pdf.bounding_box [-30,550],:width =>820 do
        pdf.text "Page: #{pdf.page_count}",:align => :left,:size=>9
        pdf.move_up(5)
        pdf.text Time.now.to_s(:salaree_time),:align => :right,:size => 9
        company_information(pdf)
        pdf.text "Salary Sheet: #{@presenter.month_date}", :align=>:center, :size=> 10,:style => :italic
        pdf.text "Department: #{department[:name]}",:style => :bold_italic,:align=>:left
      end
      pdf.bounding_box [-30,490], :width=> 820 ,:height => 470 do
        s_no= 0
        data = department[:slips].map do |slip|
          [s_no+=1,Prawn::Table::Cell.new( :text => "<code class='code'>#{employee_package_heads(department[slip])}</code>"),
            Prawn::Table::Cell.new( :text => "<code class='code'>#{ days_leaves(department[slip].attendance_detail)}</code>"),
            Prawn::Table::Cell.new( :text => "<code class='code'>#{allowances(department[slip])}</code>"),
            Prawn::Table::Cell.new( :text => "<code class='code'>#{deductions(department[slip])}</code>"),"<b>#{department[slip].net}</b>"," "]
        end
        pdf.table data << total_amount("Total",department)+[""],
          :headers => ["#","Name","Days Payable","Allowance","Deductions","Net","Signature"],
          :align_headers => :center, :header_color=>"dfdfdf", :width => 820, :horizontal_padding => 3,
          :border_width => 1, :border_color =>"9F9F9F", :border_style => :grid, :position=>:center,
          :column_widths => {0=>20,1=>160,2=>160,3=>170,4=>150,5=>70,6=>90},:align => {0 => :center,5 => :center}
        pdf.move_down(20)
        pdf.text "I,.....................,hereby certify that a sum of Rs.#{department[:total_net]}(#{department[:total_net].to_english}) has been buld. I further certify that the information  given above is true and correct based on the book of accounts, documents and other available records."
        pdf.move_down(20)
        pdf.text "Signature                ", :align => :right
        pdf.text "Place:", :align => :left
        pdf.text "Date:", :align => :left
        pdf.text "Full Name:               ", :align => :right
        pdf.text "Designation:             ", :align => :right
      end
      pdf.start_new_page
    end
    pdf.bounding_box [-30,550],:width =>820 do
      pdf.text "Page: #{pdf.page_count}",:align => :left,:size=>9
      pdf.move_up(5)
      pdf.text Time.now.to_s(:salaree_time),:align => :right,:size => 9
      company_information(pdf)
    end
    pdf.bounding_box [-30,490], :width=> 820 ,:height => 490 do
      data = @presenter.departments.map{|department|total_amount(department[:name],department)}
      data <<  gross_amount(@presenter)
      pdf.table data,
        :headers => ["#","Department Name","Total Leaves",
        "Total Allowance","Total Deductions","Total Net"],
        :align_headers => :center, :header_color=>"dfdfdf", :width => 820,
        :horizontal_padding => 3, :border_width => 1, :border_color =>"9F9F9F",
        :border_style => :grid, :position=>:center
    end
  end

  def salary_slip_pdf(pdf,salary_slip={})
    pdf.font_size 9
    pdf.footer([-10,15],:width =>540) do
      footer(pdf)
    end
    pdf.bounding_box [0,790],:width =>540 do
      pdf.text "Page: #{pdf.page_count}",:align => :left,:size=>9
      pdf.move_up(5)
      pdf.text Time.now.to_s(:salaree_time),:align => :right,:size => 9
      company_information(pdf)
      pdf.text "Salary Slip : #{@presenter.month_date}", :align=>:center
    end
    pdf.cell [-10, 745], :width=>80, :height=> 41,:border_color =>"a09d9d",:borders => [:left,:top]
    pdf.cell [69, 745], :width=>201, :height=> 41,:border_color =>"a09d9d",:borders => [:right,:top]
    pdf.bounding_box [-10,745], :width=>280 do
      pdf.table [["Name",salary_slip.employee_detail[:name]],
        ["Department",salary_slip.department],
        ["Designation",salary_slip.employee_detail[:designation]]],
        :column_widths => {0 => 80,1 => 200},
        :align => {0 =>:left ,1 => :right},
        :border_width =>0,
        :width=>280,
        :vertical_padding => 1,
        :font_size => 10
    end
    pdf.cell [270, 745], :width=>180, :height=> 41,:border_color =>"a09d9d",:borders => [:top]
    pdf.cell [449, 745], :width=>101, :height=> 41,:border_color =>"a09d9d",:borders => [:right,:top]
    pdf.bounding_box [270,745], :width=>280 do
      pdf.table [["PAN",salary_slip.employee_detail[:pan_no] || ""],
        ["Bank Account Number",salary_slip.employee_detail[:ac_no] || ""],
        ["PF Account Number",salary_slip.employee_detail[:pf_ac_no] || ""]],
        :column_widths => {0 => 180,1 => 100},
        :align => {0 =>:left ,1 => :right},
        :border_width =>0,
        :vertical_padding => 1,
        :font_size => 10
    end

    pdf.bounding_box [-10,705], :width=>560 do
      pdf.table [["<b>ALLOWANCES</b>","<b>DEDUCTIONS</b>"]],
        :border_color =>"a09d9d",
        :column_widths => {0 => 280,1 => 280},
        :width => 560,
        :align => :center,
        :vertical_padding => 3,
        :font_size => 10
    end
    cell_length = [salary_slip.allowances.length,salary_slip.deductions.length].max
    cell_height =cell_length*23+30
    pdf.cell [-10, 689], :width=>180, :height=> cell_height,:border_color =>"a09d9d", :borders => [:top,:right,:left]
    pdf.cell [170, 689], :width=>100, :height=> cell_height,:border_color =>"a09d9d", :borders => [:top,:right,:left]
    pdf.bounding_box [-10,689], :width=>280 do
      pdf.table [["<b>Description</b>", "<b>Amount</b>"]],
        :column_widths => {0 => 180,1 => 100},
        :align => {0 =>:left ,1 => :right},
        :border_color =>"a09d9d",
        :row_colors => ["dfdfdf"],
        :vertical_padding => 3,
        :font_size => 10
      unless salary_slip.allowances.blank?
        pdf.table salary_slip.allowances.map{|c| [c.salary_head.name,c.amount]},
          :column_widths => {0 => 180,1 => 100},
          :align => {0 =>:left ,1 => :right},
          :border_width =>0,
          :vertical_padding => 1,
          :font_size => 10
      end
    end

    pdf.cell [270, 689], :width=>180, :height=> cell_height,:border_color =>"a09d9d", :borders => [:top,:right,:left]
    pdf.cell [450, 689], :width=>100, :height=> cell_height,:border_color =>"a09d9d", :borders => [:top,:right,:left]
    pdf.bounding_box [270,689], :width=>280 do
      pdf.table [["<b>Description</b>", "<b>Amount</b>"]],
        :column_widths => {0 => 180,1 => 100},
        :align => {0 =>:left ,1 => :right},
        :border_color =>"a09d9d",
        :row_colors => ["dfdfdf"],
        :font_size => 10,
        :vertical_padding => 3
      unless salary_slip.deductions.blank?
        pdf.table salary_slip.deductions.map{|d|[d.salary_head.short_name,(d.amount*-1)]},
          :column_widths => {0 => 180,1 => 100},
          :align => {0 =>:left ,1 => :right},
          :border_width =>0,
          :vertical_padding => 1,
          :font_size => 10
      end
    end
    pdf.bounding_box [-10,(699-cell_height)],:width =>560 do
      pdf.table [["<b>Gross Pay</b>","<b>" + salary_slip.gross.to_s + "</b>",
          "<b>Gross Deduction</b>","<b>" + salary_slip.total_deduction.to_s + "</b>"]],
        :width => 560,
        :border_color =>"a09d9d",
        :column_widths => {0 => 180,1 => 100,2=> 180,3=>100},
        :align => {0 =>:left ,1 => :right,2 =>:left ,3 => :right},
        :font_style => :bold_italic,
        :vertical_padding => 3,
        :font_size => 10
    end
    pdf.cell [-10,(683-cell_height)], :width=>560,:height => 17, :border_color =>"a09d9d",
      :text => sprintf('%s: %77.2f',"Net Take Home",salary_slip.net),:vertical_padding => 3,
      :font_style => :bold_italic,:horizontal_padding => 3,:font_size => 10,:borders => [:bottom,:right,:left]
    unless salary_slip.attendance_detail.blank? || salary_slip.leave_detail.blank?
      pdf.bounding_box [-10,(668-cell_height)], :width=>560 do
        pdf.table [["<b>Attendance</b>","<b>Leave Detail</b>"]],
          :border_color =>"a09d9d",
          :column_widths => {0 => 180,1 => 380},
          :align => :center,
          :vertical_padding => 3,
          :font_size => 10,
          :row_colors => ["dfdfdf"]
      end
      pdf.cell [-10, (683-cell_height)], :width=>180, :height=> 135,:border_color =>"a09d9d",:borders => [:left,:bottom,:right]
      pdf.bounding_box [-10,(650-cell_height)], :width=>280 do        unless salary_slip.attendance_detail.blank?
          pdf.table salary_slip.attendance_detail.map{|k,v|[k.to_s.titleize,v]},
            :column_widths => {0 => 100,1 => 80},
            :align => {0 =>:left ,1 => :right},
            :border_width =>0,
            :vertical_padding => 1,
            :font_size => 10
        end
      end
      pdf.cell [170, (650-cell_height)], :width=>380, :height=> 102,:border_color =>"a09d9d",:borders => [:bottom,:right]
      pdf.bounding_box [170,(652-cell_height)], :width=>380 do
        unless salary_slip.leave_detail.blank?
          pdf.table salary_slip.leave_detail.map{|details|details.values.map{|v|v}},
            :headers => salary_slip.leave_detail.first.keys.map{|k|k.to_s.titleize},
            :border_width => 1,
            :vertical_padding => 7.7,
            :font_size => 10,
            :width => 380,
            :border_color =>"a09d9d"
        end
      end
      cell_height =cell_height+ 100
    end
    if @company.has_calculator?(IncomeTaxCalculator)
      IncomeTaxCalculator.first.get_income_tax_pdf_content(pdf, @presenter, salary_slip, cell_height)
    elsif @company.has_calculator?(SimpleIncomeTaxCalculator)
      SimpleIncomeTaxCalculator.first.get_income_tax_pdf_content(pdf, @presenter, salary_slip, cell_height)
    else
      AnnuallyEquatedTaxCalculator.first.get_income_tax_pdf_content(pdf, @presenter, salary_slip, cell_height)
    end

  end

  def company_information(pdf)
    pdf.text @company.name, :align=>:center,:style => :bold
    pdf.text @company.complete_address, :align=>:center, :size=>10
  end

  def footer(pdf)
    pdf.image "#{RAILS_ROOT}/public/images/salaree_dot_com_logo_eps.png",:position => :right,:scale => 0.225
    pdf.text "http://salaree.com/",:style => :italic,:align => :right,:size => 7
    pdf.move_up(41)
    pdf.image "#{RAILS_ROOT}/public/images/RisingSun_with_tagline.png",:position => :left, :scale => 0.225
    pdf.move_down(5)
    pdf.text "http://risingsuntech.net/",:style => :italic,:align => :left,:size => 7
  end

end

class PfChallan
  # Helper class to process monthly PF Challan

  def initialize(company,sheet)
    @company = company
    @presenter = SalarySheetPfPresenter.new(@company,sheet)
  end
  
  def combine_employer_contribution
    @presenter.total_employer_contribution + @presenter.pension_edli
  end
  
  def combine_employee_contribution
    @presenter.total_employee_contribution
  end

  def combine_admin_charge
    @presenter.pension_admin + @presenter.pension_inspection
  end

  def total_amount_in_ac1
    @presenter.total_employer_epf_contribution + @presenter.total_employee_contribution
  end

  def total_amount_in_ac2
    @presenter.pension_admin
  end

  def total_amount_in_ac10
    @presenter.total_employer_pf_contribution
  end

  def total_amount_in_ac21
    @presenter.pension_edli
  end
  
  def total_amount_in_ac22
    @presenter.pension_inspection
  end

  def total_net
    combine_employer_contribution + combine_employee_contribution + combine_admin_charge
  end
  
  
  def generate_challan
    pdf = Prawn::Document.new(:page_layout => :landscape,
      :left_margin => 10, :right_margin => 10)
    pdf.font "Courier"
    pdf.font_size =10
    pdf.header [0,560] do
      stef = "#{RAILS_ROOT}/public/images/pf_logo.JPG"
      pdf.image stef,:at=>[50,550],:width => 70,:height=>70
      pdf.text "COMBINED CHALLAN - A/C No.1,2,10,21 & 22", :align=>:center, :size => 12
      pdf.text "STATE BANK OF INDIA", :align=>:center, :size => 12
      pdf.text "EMPLOYEE PROVIDENT FUND ORGANISATION", :align=>:center,:style => :bold, :size => 15
    end
    data = [['Establishment Code No.',CompanyPf.pf_number(@company),
      "Account Group No.",'',"Paid by Cheque/Cash",'']]
    pdf.bounding_box [0,500], :width => 780 do
      pdf.table data,
        :font_size => 9,
        :border_width => 0,
        :column_widths => {0 => 160, 1 => 130, 2 => 130,
        3 => 130, 4 => 130, 5 => 100}
    end
    pdf.table [['Employees Share',''],["Employer Share",'']],
      :font_size => 9,
      :border_width => 0,
      :headers => ['','DUES FOR THE MONTH OF']
    pdf.table [['Total No.of Subscribers',@presenter.total_employees,@presenter.total_employees,@presenter.total_employees],
      ['Total Wages Due',@presenter.total_base_charge,@presenter.total_base_charge,@presenter.total_base_charge]],
      :font_size => 9,
      :headers => ['','A/c 1','A/c 10','A/c 21'],
      :width => 550,
      :border_style => :grid,
      :header_color=>"dddddd",
      :border_color =>"a09d9d"
    pdf.text "Date of payment: #{}",:at => [570,410]
    pdf.move_down(10)
    ac_data = [["Employee's share of contribution" ,
             @presenter.total_employer_epf_contribution,'',
             @presenter.total_employer_pf_contribution,
             @presenter.pension_edli,'',combine_employer_contribution],
            ["Employees'",@presenter.total_employee_contribution,'', '','','',combine_employee_contribution],
            ['Admin charges','', @presenter.pension_admin,'','',@presenter.pension_inspection,combine_admin_charge],
            ['Inspection charges','','','','','',''],
            ['Penal damages','','','','','',''],
            ['Misc payment','','','','','',''],
            ['Total',total_amount_in_ac1,total_amount_in_ac2,total_amount_in_ac10,
              total_amount_in_ac21,total_amount_in_ac22,total_net]]
    pdf.table ac_data,
      :font_size => 9,
      :headers => ['Particulars','A/C No. 1','A/C No. 2',
      'A/C No. 10','A/C No. 21','A/C NO. 22','Total'],
      :width => 770,
      :border_style => :grid,
      :header_color=>"dddddd",
      :border_color =>"a09d9d"
    pdf.move_down(10)
    pdf.text "(Amount in words):#{total_net.to_english}"
    pdf.move_down(5)
    pdf.text "(For banks use only)",:align => :right
    data = [['Name of establishment:',@company.name,'Amount received Rs.:']]
    data << ['Address:',@company.complete_address,'For cheques only:']
    data << ['Name of depositor:','','Date of presentation']
    data << ['Signature of the depositor','','Date of realisation:']
    data << ['','','Branch name:']
    data << ['','','Branch code no.:']
    pdf.table data,
      :font_size => 9,
      :border_width => 0,
      :column_widths => {0 => 170, 1 => 310, 2 => 150}
    pdf.text  "(TO BE FILLED IN EMPLOYER)",:font_style => :bold,:align => :center
    pdf.table [['Name of the bank','','Cheque No.','','Date','']],
      :font_size => 9,
      :border_width => 0,
      :column_widths => {0 => 160, 1 => 130, 2 => 130,
      3 => 130, 4 => 130, 5 => 100}
    pdf
  end
  
end

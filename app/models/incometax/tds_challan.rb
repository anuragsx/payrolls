class TdsChallan
  PAYMENTCODE = '92B'

  def initialize(company,salary_sheet)
    @company = company
    @salary_sheet = salary_sheet
    @persenter = SalarySheetIncomeTaxPresenter.new(company,salary_sheet)
  end
  
  def assessment_year
    @salary_sheet.run_date.strftime('%Y-%m')
  end
  
  def generate_tds_challan
    pdf = Prawn::Document.new(:page_size => "A4")
    pdf.font "Courier"
    pdf.font_size =9
    pdf.cell [0,780],:width => 520,:height => 780
    pdf.header [0,770] do
      pdf.text "T.D.S./TCS TAX CHALLAN", :align=>:center,:font_size => 15,:style => :bold
    end
    pdf.cell [0,750],:width => 520,:height => 60
    pdf.bounding_box [0,750],:width => 120,:height => 60 do
      pdf.move_down 10
      pdf.text 'CHALLAN NO./',:style => :bold,:align=>:center
      pdf.text 'ITNS',:style => :bold, :align=>:center
      pdf.text 281,:style => :bold,:align=>:center
      pdf.stroke do
        pdf.line pdf.bounds.top_right, pdf.bounds.bottom_right
      end
    end
    pdf.bounding_box [120,750],:width => 300,:height => 60 do
      pdf.move_down 5
      pdf.text 'Tax Applicable (Tick One)*',:style => :bold,:align=>:center,:font_size => 15
      pdf.move_down(9)
      pdf.text 'TAX DEDUCTED/COLLECTED AT SOURCE FROM',:style => :bold, :align=>:center
      pdf.table [['(0020) Company Deductees',''],['(0021) Non - Company Deductees ','']],
        :width => 300,:font_size => 9,:vertical_padding => 2,:border_style => :grid
      pdf.stroke do
        pdf.line pdf.bounds.top_right, pdf.bounds.bottom_right
      end
    end
    pdf.bounding_box [420,740],:width => 100 do
      pdf.text 'Assessment Year',:align=>:center
      pdf.move_down(15)
      pdf.text assessment_year,:align=>:center
    end
    pdf.cell [0,690],:width => 520,:height => 90
    pdf.bounding_box [0,685],:width =>  520,:height => 90 do
      pdf.table [
        ['Tax Deduction Account No. (T.A.N.):',"<b>#{@company.try(:tan)}</b>"],
        ['Full Name:',"<b>#{@company.name}</b>"],
        ['Complete Address with City & State:',{:text => "#{@company.complete_address}", :font_style => :bold}],
        ['Telephone Number:',"<b>#{@company.address.try(:phone_number)}</b>"],
      ],
        :column_widths => {0 => 200, 1 => 320},
        :font_size => 9,
        :border_width => 0 ,
        :align => {0=>:left,1=>:right}
    end
    pdf.bounding_box [0,600],:width =>  320,:height => 600 do
      data = [sprintf("%0s %25s","Type of Payment","Code*")]
      PAYMENTCODE.to_s.each_char{|c| data << c }
      pdf.table [data],
        :width => 320,
        :column_widths => {0 => 260,1=>20,2=>20,3=>20},
        :font_size => 9
      pdf.move_down(5)
      pdf.text sprintf("%0s %48s","(Tick One)"," ")
      pdf.move_down(15)
      pdf.text "TDS/TCS Payable by Taxpayer   (200) ",:align => :right
      pdf.move_down(5)
      pdf.text "TDS/TCS Regular Assessment (Raised by I.T. Deptt.)   (400) ",:align => :right
      pdf.move_down(10)
      data = [['Income Tax',@persenter.total_tax],['Surcharge',''],['Education Cess',@persenter.total_edu_cess],['Interest',''],
        ['Penalty',''],['Total',@persenter.total_tds],['Total(in words)',@persenter.total_tds.to_english]]
      pdf.table data,
        :headers => ['Detail of Payments','Amount(in Rs.Only)'],
        :width => 320,
        :border_style => :grid,
        :font_size => 9
      pay_data = [['','','','','',''],
        [{:text => "Paid in Cash/Debit to A/c /Cheque No.",:colspan => 3},'','Dated',''],
        [{:text => "Drawn on",:colspan => 3},{:text => " ",:colspan => 3}],
        [{:text => sprintf("%0s %70s","","(Name of the Bank and Branch)"),:colspan => 6,:font_size => 7}],
        ['Date',{:text => " ",:colspan => 2},{:text => " ",:colspan => 3}],
        [{:text => sprintf("%0s %70s","","Signature of person making payment"),:colspan => 6,:font_size => 7}]
      ]
      pdf.table pay_data,
        :headers => ['CRORES','LACS','THOUSANDS','HUNDREDS','TENS','UNITS'],
        :width => 320,
        :border_style => :grid,
        :font_size => 9,
        :column_widths => {0 => 50, 1 => 50, 2 => 60,3 => 60, 4 => 50,5 => 50}
      pdf.stroke do
        pdf.line pdf.bounds.top_right, pdf.bounds.bottom_right
      end
    end
    pdf.bounding_box [0,200],:width =>  320,:height => 236 do
      pdf.text "Taxpayers Counterfoil(To be filled up by taxpayer)",:align => :center
      pdf.move_down(10)
      pdf.text sprintf('%20s: %8s',"TAN",'')
      pdf.text sprintf('%20s: %8s',"Received from",'')
      pdf.table [['Cash/ Debit to A/c /Cheque No.','','For Rs.','']],
        :column_widths => {0 => 120, 1 => 100, 2 => 40,3 => 60},
        :font_size => 9
      pdf.table [['Rs. (in words)',''],['drawn on','']],
        :column_widths => {0 => 80, 1 => 240},
        :font_size => 9,
        :border_style => :grid
      pdf.cell [0,120],:text => "(Name of the Bank and Branch)",:width =>  320,:height => 15,:align => :center
      pdf.cell [0,105],:text => "Company/Non-Company Deductees",:width =>  320,:height => 15,:align => :center
      pdf.cell [0,90],:text => "on account of Tax Deducted at Source (TDS)/Tax Collected at Source (TCS) from____(Fill up Code)",:width =>  320,:height => 30,:align => :center
      pdf.cell [0,60],:text => "(Strike out whichever is not applicable)",:width =>  320,:height => 13,:align => :center
      pdf.move_down 2
      pdf.text "for the Assessment Year:#{assessment_year}",:width =>  320,:height => 15,:align => :center
    end
    pdf.bounding_box [322,600],:width =>  200,:height => 400 do
      pdf.move_down(10)
      pdf.text "FOR USE IN RECEIVING BANK", :align => :center,:style => :bold
      pdf.move_down(40)
      pdf.text "Debit to A/c / Cheque credited on",:align => :center
      pdf.move_down(20)
      pdf.text '- - / - - / - - - -',:align => :center
      pdf.text 'D D   M M   Y Y Y Y',:align => :center
      pdf.move_down(20)
      pdf.text 'SPACE FOR BANK SEAL',:align => :center,:style => :bold
      pdf.move_down(215)
      pdf.text 'Rs.'
    end
    pdf.cell [320,236],:width =>  200,:height => 236,
      :text => "SPACE FOR BANK SEAL",:align => :center,
      :font_style => :bold,:vertical_padding => 10
    pdf.bounding_box [322,10],:width =>  200 do
      pdf.text "Rs."
    end   
    pdf
  end

end

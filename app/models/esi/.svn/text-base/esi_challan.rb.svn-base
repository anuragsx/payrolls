class EsiChallan
  # Helper class to process monthly ESI Challan

  def initialize(company,sheet)
    @company = company
    @presenter = SalarySheetEsiPresenter.new(@company,sheet)
  end

  
  def generate_challan
    pdf = Prawn::Document.new
    pdf.font "Courier"
    pdf.font_size =9
    titles = ["Original for bank",'Duplicate for ESIC through bank ']
    count = 2
    titles.each do |title|
      count -=1
      pdf.header [0,720] do
        pdf.table [[title]],:font_size =>8,:width => 100,:border_color =>"a09d9d"
        pdf.text "EMPLOYEES  STATE INSURANCE FUND ACCOUNT NO-1", :align=>:center, :style => :bold, :size => 10
        pdf.text "PAY IN SLIP FOR CONTRIBUTION", :align=>:center,:style => :bold, :size => 10
      end
      pdf.move_down 60
      pdf.text "Station:#{@company.address.try(:city)}",:align => :left
      pdf.move_up 10
      pdf.text "Date: -- / -- / ----",:align => :right
      pdf.move_down 10
      pdf.table [['',@presenter.total_contribution],['Total',@presenter.total_contribution]],
        :headers => ['Particulars of Cash/Cheque No.','Amount'],
        :font_size => 9,
        :border_style => :grid,
        :header_color=>"dddddd",
        :border_color =>"a09d9d",
        :width => 550
      pdf.move_down 10
      pdf.text "Paid  into the account of  employee's State Insurance Fund Account No. 1 Rs.#{@presenter.total_contribution}"
      pdf.text "<b>Rupees:</b>  <u>#{@presenter.total_contribution.to_english}</u> only"
      pdf.text "in Cash/by Cheque (on realisation ) for payment of contribution as perdetails given  below  under the Employees State Insurance Act 1948 for the month of #{@presenter.month_date}"
      pdf.move_down 10
      data = [['Deposited by:',{:text => "#{@company.bank.try(:name)}",:font_style => :bold,:colspan => 2}],
        ['Establishment Code Number:',{:text => "#{CompanyPf.pf_number(@company)}",:font_style => :bold,:colspan => 2}],
        ["Name of Factory / Establishment:",{:text =>"#{@company.name}",:font_style => :bold,:colspan => 2}],
        ["Address:",{:text => "#{@company.complete_address}",:font_style => :bold,:colspan => 2}],
        ["Number of Emoployees",{:text => "#{@presenter.total_employees}",:font_style => :bold},''],
        ["Total Wages",{:text => "#{@presenter.total_base_charge}",:font_style => :bold},''],
        ['',"Employee's  Contribution Rs.:",{:text => "#{@presenter.total_employee_contribution}",:font_style => :bold}],
        ['',"Employer's  Contribution Rs.:",{:text => "#{@presenter.total_employer_contribution}",:font_style => :bold}],
        ['',"Total Contribution Rs.:",{:text => "#{@presenter.total_contribution}",:font_style => :bold}] ]
      pdf.table data,
        :font_size => 9,
        :border_width => 0,
        :column_widths => {0 => 200, 1 => 200, 2=> 150},
        :align => {0 => :left, 1 => :left, 2=> :right}
      pdf.move_down 50
      pdf.text "Authorised  Signatory",:align => :right
      pdf.text "-"*100
      pdf.text "(For use in Bank)",:align => :left
      pdf.text "ACKNOWLEDGEMENT",:align => :center
      pdf.text "( To be filled by depositor )",:align => :center,:size => 8
      pdf.move_down 10
      pdf.text "Received payment by Cash/Cheque/Draft no"
      pdf.move_down 10
      pdf.text"Dated"
      pdf.move_down 10
      pdf.text "Received Rs.#{@presenter.total_contribution}"
      pdf.move_down 10
      pdf.text "(Rupees #{@presenter.total_contribution.to_english} only)"
      pdf.move_down 10
      pdf.text "Drawn on( Bank )"
      pdf.move_down 10
      pdf.text "In favour of Employee State Insurance Fund Account No.1"
      pdf.move_down 10
      pdf.text "S.I. No. in Bank's Scroll"
      pdf.move_down 50
      pdf.text "Authorised  Signatory",:align => :right
      pdf.start_new_page unless(count == 0)
    end
    pdf
  end
  
end

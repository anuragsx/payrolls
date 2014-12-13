module SalarySheetsHelper
  require "erb"
  include ERB::Util

  def get_action_for(salary_sheet)
    salary_sheet.is_finalized? ? "Unfinalize Salary Sheet" : "Finalize Salary Sheet"
  end
  
  def employee_package_heads(slip={})
    ([slip.employee_name] +
        slip.allowances.map do |al|
        sprintf('%12s: %8.2f',html_escape(al.salary_head.short_name),al.base_charge)
      end + [sprintf('%12s: %s','Pay Scale', html_escape(slip.employee.try(:current_package).try(:company_grade).try(:name))),
        slip.employee.try(:current_package).try(:company_grade).try(:pay_scale)]).join('<br/>')
  end
    
  def allowances(slip={})
    (slip.allowances.map do |al|
        sprintf('%12s: %10.2f',html_escape(al.salary_head.short_name),al.amount)
      end + ["-"*24,sprintf('<b><i>%12s: %10.2f</i></b>','Gross',slip.gross)]).join("<br/>")
  end
  
  def deductions(slip={})
    (slip.deductions.map do |deduct|
        sprintf("%9s: %10.2f",html_escape(deduct.salary_head.short_name),(deduct.amount*-1))
      end + ["-"*22,sprintf('<b><i>%9s: %10.2f</i></b>',"Total",slip.total_deduction)]).join("<br/>")
  end
    
  def gross_amount(presenter)
    ["","Grand Total",
      presenter.grand_leaves,
      presenter.grand_gross,
      presenter.grand_deduction,
      presenter.grand_net]
  end
  
  def total_amount(name,department={})
    ["",name,department[:total_leaves],
      department[:total_gross],
      department[:total_deduction],
      department[:total_net]]
  end

  def days_leaves(leave_detail)
    unless leave_detail.blank?
      (leave_detail.map do |key,value|
          sprintf('%14s: %6.2f',html_escape(key.to_s.titlecase),value)
        end).join('<br/>')
    end
  end

  def salaries_links
    @links  ||= []
    if @salary_sheet
      @links = [
        {:path => esi_path(@salary_sheet), :name => t('common.esi'), :controller => "esis"},
        {:path => pf_path(@salary_sheet), :name => t('common.pf'), :controller => "pfs"},
        {:path => salary_sheet_advances_path(@salary_sheet), :name => t('common.advances'), :controller => "advances"},
        {:path => income_tax_path(@salary_sheet), :name => t('common.tds'), :controller => "income_taxes", :group => 'simple_income_taxes'},
        {:path => income_tax_path(@salary_sheet), :name => t('common.tds'), :controller => "income_taxes", :group => "annually_equated_tax"},
        {:path => salary_sheet_expense_claims_path(@salary_sheet), :name => t('common.expenses'), :controller => "expense_claims"},
        {:path => salary_sheet_incentives_path(@salary_sheet), :name => t('common.incentives'), :controller => "incentives"},
        {:path => salary_sheet_arrears_path(@salary_sheet), :name => t('common.arrears'), :controller => "arrears"},
        {:path => salary_sheet_insurances_path(@salary_sheet), :name => t('common.insurances'), :controller => "insurances"},
        {:path => salary_sheet_loans_path(@salary_sheet), :name => t('common.loans'), :controller => "loans"},
        {:path => labour_welfare_path(@salary_sheet), :name => t('labour_welfare.self'), :controller => "labour_welfares"},
        {:path => gratuity_path(@salary_sheet), :name => t('gratuity.self'), :controller => "gratuities"},
        {:path => salary_sheet_professional_taxes_path(@salary_sheet), :name => t('professional_tax.self'), :controller => "professional_taxes"}
      ].select{|v| @company.calculator_exists?(v[:group] || v[:controller])}
    end
    @links
  end

  def salaries_sub_header
    salaries_links
    defaults  = [{:name => t('common.sheets'), :path => salary_sheet_path(@salary_sheet), :controller => 'salary_sheets'},
      {:name => t('common.leaves'), :path => salary_sheet_leaves_path(@salary_sheet), :controller => 'leaves'}]
    content_tag(:ul,  :class => 'tabs') do
      (defaults + salaries_links).map do |entries|
        content_tag(:li,link_to(entries[:name],entries[:path]),
          :class => link_active?(entries[:controller].include?(params[:controller])))
      end.join(" ")
    end
      
  end

  def salary_sheet_actions(salary_sheet)
    defaults = [:name => t('common.leaves'), :path => bulk_new_salary_sheet_leafe_path(salary_sheet.run_date.to_s(:for_param))]
    actions =  [{:path => bulk_new_salary_sheet_advance_path(salary_sheet.run_date.to_s(:for_param)), :name => t('common.advances'), :controller => "advances"},
      {:path => bulk_new_salary_sheet_expense_claim_path(@salary_sheet), :name => t('common.expenses'), :controller => "expense_claims"}
    ].select{|v| @company.calculator_exists?(v[:group] || v[:controller])}
    content_tag(:ul,  :class => 'salary_sheet_options') do
      content_tag(:li,  :class => '') do
        link_to("Options", "#") +
        content_tag(:ul,  :class => '') do
          (defaults + actions).map do |entries|
            content_tag(:li,  :class => '') do
              link_to(entries[:name],entries[:path])
            end
          end.join(" ")
        end
      end
    end
  end

  def sheet_status(s)
    if s.doc.path
      link_to("Download Slip",salary_slip_path(s,:format =>:pdf))
    else
      @has_running = true
      content_tag(:span,"Generating...",:class=>'running')
    end
  end

  def sheet_index_status(salary_sheet)
    if salary_sheet.initial?
      @has_running = true
      content_tag(:span,"running...", :class => 'running')
    end
  end

  def salary_sheet_index(salary_sheet)
    if salary_sheet.doc.path
      link_to("#{t('common.salary_sheets')} #{t('button.print')}", salary_sheet_path(:format =>:pdf))
    else
      @has_running = true
      content_tag(:span,"Generating...",:class=>'running')
    end
  end

end
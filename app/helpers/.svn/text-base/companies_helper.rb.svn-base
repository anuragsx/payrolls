module CompaniesHelper

  def company_settings_links
    @links ||= [
      {:path => company_esi_path, :name => t('common.esi'), :controller => "company_esis", :group => "esis"},
      {:path => company_pf_path, :name => t('common.pf'), :controller => "company_pfs", :group => "pfs"},
      {:path => slabs_income_taxes_path, :name => t('common.tds'), :controller => "simple_income_taxes"},
      {:path => slabs_income_taxes_path, :name => t('common.tds'), :controller => "income_taxes"},
      {:path => slabs_income_taxes_path, :name => t('common.tds'), :controller => "annually_equated_tax"},
      {:path => tds_returns_path, :name => t('common.tds_return'), :controller => "tds_returns",:group => "simple_income_taxes"},
      {:path => tds_returns_path, :name => t('common.tds_return'), :controller => "tds_returns",:group => "income_taxes"},
      {:path => tds_returns_path, :name => t('common.tds_return'), :controller => "tds_returns",:group => "annually_equated_tax"},
      {:path => company_leave_path, :name => t('common.leaves'), :controller => "company_leaves", :group => "leave_accounting"},
      {:path => settings_bonus_path, :name => t('common.bonus'), :controller => "bonus",  :group => "bonus"},
      {:path => company_loadings_path, :name => t('common.dearness_relief'), :controller => "company_loadings", :group => "dearness_relief"},
      {:path => labour_welfare_categories_path, :name => t('labour_welfare.self'), :controller => "labour_welfare_categories",  :group => "labour_welfare"},
      {:path => company_flexi_packages_path, :name => t('common.flexi_package'), :controller => "company_flexi_packages", :group => 'flexible_allowances'},
      {:path => company_professional_tax_path, :name => t('professional_tax.self'), :controller => "company_professional_taxes", :group => "professional_taxes"}     
    ].select{|v| @company.calculator_exists?(v[:group] || v[:controller])}
  end

  def companies_sub_header
    company_settings_links
    defaults = [{:name => t('company.profile'), :path => company_path(current_account), :controller => 'companies'},
      {:name => t('common.departments'), :path => departments_path, :controller => 'departments'},
      {:name => t('common.salary_heads'), :path => company_allowance_heads_path, :controller => 'company_allowance_heads'},
      {:name => t('common.calculators'), :path => company_calculators_path, :controller => 'company_calculators'},
      {:name => t('common.banks'), :path => bank_path, :controller => 'banks'},
      {:name => t('common.pay_grades'), :path => company_grades_path, :controller => 'company_grades'},
      {:name => "OAuth Applications", :path => oauth_clients_path, :controller => 'oauth_clients'}

    ]
	content_tag(:ul,  :class => 'tabs') do
      (defaults + company_settings_links).map do |entries|
        content_tag(:li,link_to(entries[:name],entries[:path]),
          :class => link_active?(entries[:controller].include?(params[:controller])))
      end.join(" ")
    end

  end
  
end

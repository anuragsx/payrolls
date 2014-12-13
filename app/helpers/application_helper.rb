module ApplicationHelper


  def setup_company(company)
    company.tap do |comp|
      comp.build_owner unless comp.owner
      comp.owner.build_address unless comp.owner.address
    end
  end

  def if_current?(url)
    "active" if current_page?(url)
  end

  def link_active?(bool_condition = false)
    (bool_condition && "active") || ""
  end

  def employee_active?(e)
    "selected_employee" if (e == @employee)
  end

  def company_header(company)
    return (SITE_NAME) if !company or company.new_record?
    (truncate(company.name,:length=>30)) unless company.nil?
  end

  def company_icon(company, size = :thumb, img_opts = {})
    return "" if company.nil? || company.logo_file_name.nil?
    img_opts = {:title => company.name, :alt => company.name, :class => size}.merge(img_opts)
    image_tag(company.logo.url(size), img_opts)
  end

  def display_error_messages(error_for)
    errors_for(error_for, :class => 'errors png_bg', :header_message => nil)
  end

  def activerecord_error_list(errors)
    error_list = '<div id="errors" class="errors png_bg">'
    error_list << errors.flatten.collect do |e, m|
      "#{e.humanize unless e == "base"} #{m}"
    end.to_s << '</div>'
    error_list
  end

  def annual_navigator(prevpath,nextpath,prev_year=@prev_year,next_year=@next_year)
    content_tag(:div,content_tag(:span,next_link(next_year.formatted_fy,nextpath),:class => 'right')+
        previous_link(prev_year.formatted_fy,prevpath))
  end

  def month_navigator(controller,new_link = nil)
    #existing = @company.salary_sheets.in_fy(@salary_sheet.run_date.financial_year).all(:select => 'id,run_date').index_by{|x|x.run_date.month}
    content_tag(:ul, :class => 'month-nav') do
      @salary_sheet.run_date.financial_year.financial_months do |d|
        monthname = Date::MONTHNAMES[d.month]
        if @salary_sheet.run_date.month == (d + 1.month).month
          content_tag(:li,
                      content_tag(:span,previous_link(monthname,send(controller,d.to_s(:for_param)))),
                      :class => link_active?(false)
          )
        elsif @salary_sheet.run_date.month == (d - 1.month).month
          content_tag(:li,
                      content_tag(:span,next_link(monthname,send(controller,d.to_s(:for_param)))),
                      :class => link_active?(false)
          )
        else
          content_tag(:li,
                      content_tag(:span,link_to(monthname,send(controller,d.to_s(:for_param)))),
                      :class => link_active?(@salary_sheet.run_date.month == d.month)
          )
        end
      end.join(" ")
    end
  end

  def day_navigator(path='bulk_attendance_path')
    content_tag(:ul, :class => 'date-nav') do
      @date.month_dates.map do |d|
        active = (d == @date) ? "active" : ""
        content_tag(:li,content_tag(:span,link_to(d.day.ordinalize,send(path,d.to_s(:date_month_and_year)))),:class => active)
      end.join(" ")
    end
  end

  def default_common_links
    {
        'O'=> [home_path,'Overview'] ,
        'E'=> [employees_path,'Employees'] ,
        'S'=> [salary_sheets_path,'SalarySheets'] ,
        'L'=> [leaves_path,'Leaves'] ,
        'R'=> [graph_salary_sheets_path,'Reports'] ,
        'F'=> [new_feedback_path,'Feedback'] ,
        'U'=> [users_path,'Users'] ,
        'Shift+S'=> [company_path(@company),'Settings'] ,
        'A'=> [edit_user_path(current_user),'Accounts'] ,
        'N'=> [new_employee_path,'New Employee'] ,
        'Shift+E'=> [esis_path,'ESI'] ,
        'Shift+P'=> [pfs_path,'PF'] ,
        'Shift+A'=> [advances_path,'Advances'] ,
        'Shift+T'=> [income_taxes_path,'TDS'] ,
        'Shift+L'=> [loans_path,'Loans'] ,
        'Shift+B'=> [bonus_path,'Bonus'],
    }
  end

  def shortcut_links
    @shortlinks ||= {}
    default_common_links.merge(@shortlinks)
  end

  def company_links
    @links ||= [
        {:path => esis_path, :name => t('common.esi'), :controller => "esis"},
        {:path => pfs_path, :name => t('common.pf'), :controller => "pfs"},
        {:path => advances_path, :name => t('common.advances'), :controller => "advances"},
        {:path => income_taxes_path, :name => t('common.tds'), :controller => "income_taxes"},
        {:path => income_taxes_path, :name => t('common.tds'), :controller => "income_taxes", :group => 'simple_income_taxes'},
        {:path => expense_claims_path, :name => t('common.expense_claims'), :controller => "expense_claims"},
        {:path => incentives_path, :name => t('common.incentives'), :controller => "incentives"},
        {:path => arrears_path, :name => t('common.arrears'), :controller => "arrears"},
        {:path => insurances_path, :name => t('common.insurances'), :controller => "insurances"},
        {:path => loans_path, :name => t('common.loans'), :controller => "loans"},
        {:path => bonus_path, :name => t('common.bonus'), :controller => "bonus"},
        {:path => labour_welfares_path, :name => t('labour_welfare.self'), :controller => "labour_welfares"},
        {:path => gratuities_path, :name => t('gratuity.self'), :controller => "gratuities"},
        {:path => professional_taxes_path, :name => t('professional_tax.self'), :controller => "professional_taxes"}
    ].select{|v| @company.calculator_exists?(v[:group] || v[:controller])}
  end

  def company_drop_down_links
    content_tag(:ul, :class => 'png_bg') do
      company_links.map do |value|
        content_tag(:li, link_to(value[:name], value[:path]),
                    :class=>"salary #{link_active?(value[:controller].include?(params[:controller]))}")
      end.join(" ")
    end
  end

  def sub_headers
    defaults  = [
        {:name => t('common.sheets'), :path => salary_sheets_path, :controller => 'salary_sheets'},
        {:name => t('common.leaves'), :path => leaves_path, :controller => 'leaves'}]
    content_tag(:ul,  :class => 'tabs') do
      (defaults + company_links).map do |entries|
        content_tag(:li,link_to(entries[:name],entries[:path]),
                    :class => link_active?(entries[:controller].include?(params[:controller])))
      end.join(" ")
    end
  end

  def not_current_locale
    LANGUAGES.reject{|k,s| s== I18n.locale }
  end

  def pdf_footer(pdf)
    pdf.image "#{RAILS_ROOT}/public/images/salaree_dot_com_logo_eps.png",:position => :right,:scale => 0.225
    pdf.text "http://salaree.com/",:style => :italic,:align => :right, :size => 10
    pdf.move_up(41)
    pdf.image "#{RAILS_ROOT}/public/images/RisingSun_with_tagline.png",:position => :left, :scale => 0.225
    pdf.move_down(5)
    pdf.text "http://risingsuntech.net/",:style => :italic,:align => :left, :size => 10
  end

  def next_link(name,link,options = {})
    options.merge!(:id => 'next_link')
    help_link = options.delete(:rel) || name
    @shortlinks ||= {}
    @shortlinks['Shift+right'] = [link,help_link]
    link_to(name,link,options)
  end

  def previous_link(name,link,options = {})
    options.merge!(:id => 'previous_link')
    help_link = options.delete(:rel) || name
    @shortlinks ||= {}
    @shortlinks['Shift+left'] = [link,help_link]
    link_to(name,link,options)
  end



end

module CompanyFlexiPackagesHelper

  def lookup_categories(lookup,company)
    if lookup == "Company"
      return 0
    elsif lookup == "Department"
      return company.departments
    elsif lookup == "Employee"
      return company.employees
    end
  end

  def add_link(form_builder)
    link_to_function 'add link' do |page|
      form_builder.fields_for :flexible_allowances, FlexibleAllowance.new(), :child_index => 'NEW_RECORD' do |f|
        html = render(:partial => 'flexible_allowance', :locals => { :form => f ,:package => form_builder.object})
        page << "$('#{form_builder.object.id}_flexi_allowances').insert({ bottom: '#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime()) });"
      end
    end
  end

  def remove_link(form_builder)
    form_builder.hidden_field(:_delete) +
      link_to_function(image_tag("delete.png"), "$(this).up('.flexible_allowance').hide(); $(this).previous().value = '1'")
  end
  
end

module ProfessionalTaxesHelper

  def get_status(professional_tax)
    professional_tax ? I18n.t('professional_tax.deregister') : I18n.t('professional_tax.register')
  end
  
end

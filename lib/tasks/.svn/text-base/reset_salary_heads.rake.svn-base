namespace :salaree do
  
  desc "Rename Salary Head Code"
  task :rename_heads => :environment do
    rename = {"PENSION_INSPECTION_CONTRIB_HEAD"=>"employer_pf_inspection", 
              "VOLUNTARY_PF_CONTRIB_CODE"=>"employee_vpf",
              "LWF_EMPLOYEE"=>"employee_lwf", 
              "CLEANING_EXP"=>"cleaning_expense", 
              "PROFESSIONAL_TAX_HEAD"=>"professional_tax", 
              "HRA"=>"rent", 
              "MED"=>"medical", 
              "GRATUITY_EARNED"=>"gratuity_earned", 
              "EXPENSE"=>"reimbursement", 
              "LWF_EMPLOYER"=>"employer_lwf", 
              "TRIBAL"=>"tribal", 
              "DR"=>"dearness_relief", 
              "TDS"=>"tds", 
              "BASIC"=>"basic", 
              "SPA"=>"special_allowance", 
              "ESI_EMPLOYEE_CONTRIB_CODE"=>"employee_esi", 
              "PF_EMPLOYEE_CONTRIB_CODE"=>"employee_pf", 
              "TELA"=>"communication", 
              "OTHERA"=>"other_allowance", 
              "LIC"=>"insurance", 
              "PENSION_EDLI_CONTRIB_HEAD"=>"employer_pf_edli", 
              "PENSION_FUND_CONTRIB_CODE"=>"employer_pf", 
              "GRATUITY_WITHHELD"=>"gratuity_withheld", 
              "EXTRA_CTC"=>"extra_ctc", 
              "DEDUCT"=>"deduct", 
              "NET"=>"net", 
              "PENSION_ADMIN_CONTRIB_HEAD"=>"employer_pf_admin", 
              "ADHOC"=>"adhoc", 
              "LAUNDRY"=>"laundry", 
              "DA"=>"da", 
              "GROSS"=>"gross", 
              "ADV"=>"advance", 
              "EPF_EMPLOYER_CONTRIB_CODE"=>"employer_epf", 
              "ESI_EMPLOYER_CONTRIB_CODE"=>"employer_esi", 
              "LOAN"=>"loan", 
              "BONUS"=>"bonus", 
              "UNDERGROUND"=>"underground", 
              "OUTSA"=>"out_station", 
              "TVL"=>"conveyance"}

    rename.each do |code,new_code|
      head = SalaryHead.find_by_code(code)
      head.update_attribute(:code,new_code) if head
    end
    SalaryHead.find_by_code('reimbursement').update_attribute(:name,'Reimbursement')
  end
  
end
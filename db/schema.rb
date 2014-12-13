# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140928032259) do

  create_table "addresses", :force => true do |t|
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "address_line3"
    t.string   "city"
    t.string   "pincode"
    t.string   "phone_number"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.string   "state"
    t.string   "mobile_number"
  end

  add_index "addresses", ["addressable_id"], :name => "index_addresses_on_addressable_id"

  create_table "approval_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "arrears", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.integer  "salary_slip_id"
    t.float    "amount"
    t.string   "description"
    t.date     "arrear_at"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "attendance_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
  end

  create_table "attendances", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.integer  "attendance_type_id"
    t.datetime "attendance_date"
    t.datetime "timein"
    t.datetime "timeout"
    t.string   "entered_by"
    t.string   "approved_by"
    t.integer  "approval_status_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "attendances", ["approval_status_id"], :name => "index_attendances_on_approval_status_id"
  add_index "attendances", ["attendance_type_id"], :name => "index_attendances_on_attendance_type_id"
  add_index "attendances", ["company_id"], :name => "index_attendances_on_company_id"
  add_index "attendances", ["employee_id"], :name => "index_attendances_on_employee_id"

  create_table "banks", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.string   "company_account_number"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "banks", ["company_id"], :name => "index_banks_on_company_id"

  create_table "calculators", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.string   "calculator_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "description"
  end

  create_table "client_applications", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "support_url"
    t.string   "callback_url"
    t.string   "key",          :limit => 20
    t.string   "secret",       :limit => 40
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "company_id"
  end

  add_index "client_applications", ["key"], :name => "index_client_applications_on_key", :unique => true

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.integer  "package_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.string   "pan"
    t.string   "tan"
    t.integer  "round_by",                      :default => 1
    t.boolean  "want_protected_pdf"
    t.string   "pdf_password"
    t.string   "default_employee_pdf_password"
  end

  add_index "companies", ["package_id"], :name => "index_companies_on_package_id"

  create_table "company_allowance_heads", :force => true do |t|
    t.integer  "company_id"
    t.integer  "salary_head_id"
    t.integer  "position"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "company_allowance_heads", ["company_id"], :name => "index_company_allowance_heads_on_company_id"
  add_index "company_allowance_heads", ["salary_head_id"], :name => "index_company_allowance_heads_on_salary_head_id"

  create_table "company_bonus", :force => true do |t|
    t.integer  "company_id"
    t.float    "bonus_percent"
    t.date     "release_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "company_bonus", ["company_id"], :name => "index_company_bonus_on_company_id"

  create_table "company_calculators", :force => true do |t|
    t.integer  "company_id"
    t.integer  "calculator_id"
    t.integer  "position"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "company_calculators", ["calculator_id"], :name => "index_company_calculators_on_calculator_id"
  add_index "company_calculators", ["company_id"], :name => "index_company_calculators_on_company_id"

  create_table "company_esis", :force => true do |t|
    t.integer  "company_id"
    t.string   "esi_number"
    t.integer  "esi_type_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "company_esis", ["company_id"], :name => "index_company_esis_on_company_id"
  add_index "company_esis", ["esi_type_id"], :name => "index_company_esis_on_esi_type_id"

  create_table "company_flexi_packages", :force => true do |t|
    t.integer  "company_id"
    t.integer  "salary_head_id"
    t.string   "lookup_expression"
    t.integer  "position"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "company_flexi_packages", ["company_id"], :name => "index_company_flexi_packages_on_company_id"
  add_index "company_flexi_packages", ["salary_head_id"], :name => "index_company_flexi_packages_on_salary_head_id"

  create_table "company_grades", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.string   "pay_scale"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "company_holidays", :force => true do |t|
    t.integer  "company_id"
    t.integer  "holiday_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "company_holidays", ["company_id"], :name => "index_company_holidays_on_company_id"
  add_index "company_holidays", ["holiday_id"], :name => "index_company_holidays_on_holiday_id"

  create_table "company_leaves", :force => true do |t|
    t.integer  "company_id"
    t.integer  "rate_of_leave"
    t.integer  "month_day_calculation"
    t.float    "month_length"
    t.integer  "leave_accrual"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.float    "casual_leaves"
    t.float    "sick_leaves"
  end

  add_index "company_leaves", ["company_id"], :name => "index_company_leaves_on_company_id"

  create_table "company_loadings", :force => true do |t|
    t.integer  "company_id"
    t.float    "loading_percent"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "company_loadings", ["company_id"], :name => "index_company_loadings_on_company_id"

  create_table "company_pfs", :force => true do |t|
    t.integer  "company_id"
    t.integer  "pf_type_id"
    t.string   "pf_number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "company_pfs", ["company_id"], :name => "index_company_pfs_on_company_id"
  add_index "company_pfs", ["pf_type_id"], :name => "index_company_pfs_on_pf_type_id"

  create_table "company_professional_taxes", :force => true do |t|
    t.integer  "company_id"
    t.string   "zone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "department_holidays", :force => true do |t|
    t.integer  "department_id"
    t.integer  "holiday_id"
    t.integer  "company_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "department_holidays", ["company_id"], :name => "index_department_holidays_on_company_id"
  add_index "department_holidays", ["department_id"], :name => "index_department_holidays_on_department_id"
  add_index "department_holidays", ["holiday_id"], :name => "index_department_holidays_on_holiday_id"

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "departments", ["company_id"], :name => "index_departments_on_company_id"

  create_table "effective_loan_emis", :force => true do |t|
    t.integer  "employee_loan_id"
    t.integer  "employee_id"
    t.float    "amount"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "effective_loan_emis", ["employee_id"], :name => "index_effective_loan_emis_on_employee_id"
  add_index "effective_loan_emis", ["employee_loan_id"], :name => "index_effective_loan_emis_on_employee_loan_id"

  create_table "employee_advances", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.float    "amount"
    t.string   "description"
    t.integer  "salary_slip_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "employee_advances", ["company_id"], :name => "index_employee_advances_on_company_id"
  add_index "employee_advances", ["employee_id"], :name => "index_employee_advances_on_employee_id"
  add_index "employee_advances", ["salary_slip_id"], :name => "index_employee_advances_on_salary_slip_id"

  create_table "employee_details", :force => true do |t|
    t.integer  "employee_id"
    t.string   "care_of"
    t.date     "date_of_birth"
    t.boolean  "sex"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "employee_details", ["employee_id"], :name => "index_employee_details_on_employee_id"

  create_table "employee_esis", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.string   "esi_number"
    t.boolean  "applicable"
    t.date     "effective_date"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "employee_esis", ["company_id"], :name => "index_employee_esis_on_company_id"
  add_index "employee_esis", ["employee_id"], :name => "index_employee_esis_on_employee_id"

  create_table "employee_insurance_policies", :force => true do |t|
    t.integer  "company_id"
    t.integer  "employee_id"
    t.float    "monthly_premium"
    t.date     "expiry_date"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "employee_insurance_policies", ["company_id"], :name => "index_employee_insurance_policies_on_company_id"
  add_index "employee_insurance_policies", ["employee_id"], :name => "index_employee_insurance_policies_on_employee_id"

  create_table "employee_investment80cs", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.integer  "employee_investment_scheme_id"
    t.float    "amount"
    t.integer  "financial_year"
    t.integer  "employee_tax_detail_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "employee_investment80cs", ["company_id"], :name => "index_employee_investment80cs_on_company_id"
  add_index "employee_investment80cs", ["employee_id"], :name => "index_employee_investment80cs_on_employee_id"
  add_index "employee_investment80cs", ["employee_investment_scheme_id"], :name => "index_employee_investment80cs_on_employee_investment_scheme_id"
  add_index "employee_investment80cs", ["employee_tax_detail_id"], :name => "index_employee_investment80cs_on_employee_tax_detail_id"

  create_table "employee_investment_schemes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "employee_leave_balances", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.string   "financial_year"
    t.float    "current_balance"
    t.float    "earned_leaves"
    t.float    "spent_leaves"
    t.float    "opening_balance"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "leave_type"
  end

  add_index "employee_leave_balances", ["company_id"], :name => "index_employee_leave_balances_on_company_id"
  add_index "employee_leave_balances", ["employee_id"], :name => "index_employee_leave_balances_on_employee_id"

  create_table "employee_leave_types", :force => true do |t|
    t.integer  "employee_leave_id"
    t.integer  "company_id"
    t.integer  "employee_id"
    t.float    "leaves"
    t.float    "paid"
    t.float    "unpaid"
    t.float    "earned"
    t.float    "spent"
    t.string   "leave_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "employee_leaves", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.float    "present"
    t.float    "absent"
    t.integer  "salary_sheet_id"
    t.integer  "salary_slip_id"
    t.float    "paid"
    t.float    "unpaid"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.float    "late_hours"
    t.float    "overtime_hours"
    t.float    "earned"
    t.float    "spent"
    t.float    "extra_work_days"
  end

  add_index "employee_leaves", ["company_id"], :name => "index_employee_leaves_on_company_id"
  add_index "employee_leaves", ["employee_id"], :name => "index_employee_leaves_on_employee_id"
  add_index "employee_leaves", ["salary_sheet_id"], :name => "index_employee_leaves_on_salary_sheet_id"
  add_index "employee_leaves", ["salary_slip_id"], :name => "index_employee_leaves_on_salary_slip_id"

  create_table "employee_loans", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.float    "loan_amount"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "employee_loans", ["company_id"], :name => "index_employee_loans_on_company_id"
  add_index "employee_loans", ["employee_id"], :name => "index_employee_loans_on_employee_id"

  create_table "employee_other_incomes", :force => true do |t|
    t.integer  "company_id"
    t.integer  "employee_id"
    t.float    "amount"
    t.integer  "financial_year"
    t.integer  "salary_slip_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.float    "already_tax_paid_on_other_income"
  end

  create_table "employee_package_heads", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "employee_package_id"
    t.integer  "salary_head_id"
    t.integer  "company_id"
    t.float    "amount"
    t.boolean  "leave_dependent"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "employee_package_heads", ["company_id"], :name => "index_employee_package_heads_on_company_id"
  add_index "employee_package_heads", ["employee_id"], :name => "index_employee_package_heads_on_employee_id"
  add_index "employee_package_heads", ["employee_package_id"], :name => "index_employee_package_heads_on_employee_package_id"
  add_index "employee_package_heads", ["salary_head_id"], :name => "index_employee_package_heads_on_salary_head_id"

  create_table "employee_packages", :force => true do |t|
    t.string   "designation"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "basic"
    t.integer  "version"
    t.integer  "employee_id"
    t.integer  "company_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "company_grade_id"
  end

  add_index "employee_packages", ["company_id"], :name => "index_employee_packages_on_company_id"
  add_index "employee_packages", ["employee_id"], :name => "index_employee_packages_on_employee_id"

  create_table "employee_pensions", :force => true do |t|
    t.integer  "company_id"
    t.integer  "employee_id"
    t.string   "epf_number"
    t.integer  "company_pf_id"
    t.float    "total_pf_contribution"
    t.float    "vpf_amount"
    t.float    "vpf_percent"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.datetime "deleted_at"
    t.string   "exit_reason"
    t.boolean  "match_company_vpf",     :default => false
  end

  add_index "employee_pensions", ["company_id"], :name => "index_employee_pensions_on_company_id"
  add_index "employee_pensions", ["company_pf_id"], :name => "index_employee_pensions_on_company_pf_id"
  add_index "employee_pensions", ["employee_id"], :name => "index_employee_pensions_on_employee_id"

  create_table "employee_professional_taxes", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "employee_professional_taxes", ["company_id"], :name => "index_employee_professional_taxes_on_company_id"
  add_index "employee_professional_taxes", ["employee_id"], :name => "index_employee_professional_taxes_on_employee_id"

  create_table "employee_statuses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "employee_tax_details", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.integer  "tax_category_id"
    t.string   "pan"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.float    "monthly_rent_paid"
  end

  add_index "employee_tax_details", ["company_id"], :name => "index_employee_tax_details_on_company_id"
  add_index "employee_tax_details", ["employee_id"], :name => "index_employee_tax_details_on_employee_id"
  add_index "employee_tax_details", ["tax_category_id"], :name => "index_employee_tax_details_on_tax_category_id"

  create_table "employee_taxes", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.float    "amount",      :default => 0.0
    t.string   "description"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "employee_taxes", ["company_id"], :name => "index_employee_taxes_on_company_id"
  add_index "employee_taxes", ["employee_id"], :name => "index_employee_taxes_on_employee_id"

  create_table "employee_tds_returns", :force => true do |t|
    t.integer  "company_id"
    t.integer  "employee_id"
    t.integer  "tds_return_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.date     "commencement_date"
    t.integer  "company_id"
    t.integer  "department_id"
    t.string   "account_number"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "email"
    t.string   "status"
    t.integer  "bank_id"
    t.string   "identification_number"
    t.string   "pdf_password"
  end

  add_index "employees", ["bank_id"], :name => "index_employees_on_bank_id"
  add_index "employees", ["company_id"], :name => "index_employees_on_company_id"
  add_index "employees", ["department_id"], :name => "index_employees_on_department_id"

  create_table "esi_types", :force => true do |t|
    t.string   "name"
    t.integer  "employee_size"
    t.float    "employer_contrib_percent"
    t.float    "employee_contrib_percent"
    t.float    "basic_percent"
    t.float    "basic_threshold"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "expense_claims", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.string   "description"
    t.float    "amount"
    t.integer  "salary_slip_id"
    t.date     "expensed_at"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "expense_claims", ["company_id"], :name => "index_expense_claims_on_company_id"
  add_index "expense_claims", ["employee_id"], :name => "index_expense_claims_on_employee_id"
  add_index "expense_claims", ["salary_slip_id"], :name => "index_expense_claims_on_salary_slip_id"

  create_table "feedbacks", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "feedback"
    t.integer  "user_id"
  end

  create_table "flexible_allowances", :force => true do |t|
    t.string   "category_type"
    t.integer  "category_id"
    t.integer  "company_id"
    t.integer  "salary_head_id"
    t.float    "value"
    t.string   "head_type"
    t.boolean  "leave_dependent"
    t.integer  "company_flexi_package_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "flexible_allowances", ["category_id"], :name => "index_flexible_allowances_on_category_id"
  add_index "flexible_allowances", ["company_flexi_package_id"], :name => "index_flexible_allowances_on_company_flexi_package_id"
  add_index "flexible_allowances", ["company_id"], :name => "index_flexible_allowances_on_company_id"
  add_index "flexible_allowances", ["salary_head_id"], :name => "index_flexible_allowances_on_salary_head_id"

  create_table "holidays", :force => true do |t|
    t.string   "name"
    t.integer  "day"
    t.integer  "month"
    t.integer  "year"
    t.string   "region"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "incentives", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.integer  "salary_slip_id"
    t.float    "amount"
    t.string   "description"
    t.date     "incentive_at"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "labour_welfare_slabs", :force => true do |t|
    t.integer  "labour_welfare_id"
    t.float    "salary_min"
    t.float    "salary_max"
    t.float    "employee_contribution"
    t.float    "employer_contribution"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "labour_welfare_slabs", ["labour_welfare_id"], :name => "index_labour_welfare_slabs_on_labour_welfare_id"

  create_table "labour_welfares", :force => true do |t|
    t.string   "zone"
    t.integer  "submissions_count"
    t.string   "paid_to"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "leave_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lta_claims", :force => true do |t|
    t.integer  "company_id"
    t.integer  "employee_id"
    t.string   "claim_year"
    t.string   "block"
    t.float    "amount"
    t.string   "description"
    t.integer  "salary_slip_id"
    t.integer  "lta_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "ltas", :force => true do |t|
    t.integer  "company_id"
    t.integer  "employee_id"
    t.float    "amount"
    t.string   "description"
    t.integer  "salary_slip_id"
    t.string   "block"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "oauth_nonces", :force => true do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], :name => "index_oauth_nonces_on_nonce_and_timestamp", :unique => true

  create_table "oauth_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",                  :limit => 20
    t.integer  "client_application_id"
    t.string   "token",                 :limit => 20
    t.string   "secret",                :limit => 40
    t.string   "callback_url"
    t.string   "verifier",              :limit => 20
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "oauth_tokens", ["token"], :name => "index_oauth_tokens_on_token", :unique => true

  create_table "packages", :force => true do |t|
    t.string   "name"
    t.string   "max_employees"
    t.text     "description"
    t.float    "fee"
    t.string   "code"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "pf_types", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.float    "pension_percent"
    t.float    "epf_percent"
    t.float    "pf_basic_threshold"
    t.float    "admin_percent"
    t.float    "edli_percent"
    t.float    "inspection_percent"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "professional_tax_slabs", :force => true do |t|
    t.string   "zone"
    t.float    "salary_min"
    t.float    "salary_max"
    t.float    "tax_amount"
    t.integer  "applicable_month"
    t.date     "applicable_date"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "salary_heads", :force => true do |t|
    t.string   "name"
    t.string   "salary_head_type"
    t.string   "code"
    t.text     "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "tax_formula"
  end

  create_table "salary_sheets", :force => true do |t|
    t.date     "run_date"
    t.float    "grand_total"
    t.float    "working_days"
    t.float    "holidays"
    t.integer  "company_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.string   "status"
    t.integer  "financial_year"
    t.integer  "month_length"
  end

  add_index "salary_sheets", ["company_id"], :name => "index_salary_sheets_on_company_id"

  create_table "salary_slip_charges", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.integer  "salary_sheet_id"
    t.integer  "salary_slip_id"
    t.integer  "salary_head_id"
    t.float    "amount"
    t.string   "reference_type"
    t.integer  "reference_id"
    t.string   "description"
    t.float    "base_charge"
    t.date     "charge_date"
    t.string   "financial_year"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.float    "taxable_amount"
  end

  add_index "salary_slip_charges", ["company_id"], :name => "index_salary_slip_charges_on_company_id"
  add_index "salary_slip_charges", ["employee_id"], :name => "index_salary_slip_charges_on_employee_id"
  add_index "salary_slip_charges", ["reference_id"], :name => "index_salary_slip_charges_on_reference_id"
  add_index "salary_slip_charges", ["salary_head_id"], :name => "index_salary_slip_charges_on_salary_head_id"
  add_index "salary_slip_charges", ["salary_sheet_id"], :name => "index_salary_slip_charges_on_salary_sheet_id"
  add_index "salary_slip_charges", ["salary_slip_id"], :name => "index_salary_slip_charges_on_salary_slip_id"

  create_table "salary_slips", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "company_id"
    t.integer  "salary_sheet_id"
    t.float    "unearned_leaves"
    t.float    "worked_days"
    t.float    "leaves"
    t.float    "leave_ratio"
    t.float    "net"
    t.float    "gross"
    t.float    "deduction"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.float    "taxable_gross"
    t.float    "taxable_deduction"
    t.integer  "financial_year"
  end

  add_index "salary_slips", ["company_id"], :name => "index_salary_slips_on_company_id"
  add_index "salary_slips", ["employee_id"], :name => "index_salary_slips_on_employee_id"
  add_index "salary_slips", ["salary_sheet_id"], :name => "index_salary_slips_on_salary_sheet_id"

  create_table "tax_categories", :force => true do |t|
    t.string   "category"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tax_slabs", :force => true do |t|
    t.float    "min_threshold"
    t.float    "max_threshold"
    t.float    "tax_rate"
    t.integer  "tax_category_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "financial_year"
  end

  add_index "tax_slabs", ["tax_category_id"], :name => "index_tax_slabs_on_tax_category_id"

  create_table "tds_returns", :force => true do |t|
    t.integer  "company_id"
    t.date     "start_date"
    t.string   "receipt_number"
    t.float    "intrest_amount"
    t.string   "bsr_code"
    t.string   "cheque_ya_dd_no"
    t.date     "tax_deposited_date"
    t.date     "tax_deduction_date"
    t.string   "payment_made"
    t.string   "challan_serial_no"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_sessions", ["session_id"], :name => "index_user_sessions_on_session_id"
  add_index "user_sessions", ["updated_at"], :name => "index_user_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count",         :default => 0
    t.integer  "failed_login_count",  :default => 0
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "perishable_token",    :default => "", :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "activate"
    t.integer  "company_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "single_access_token",                 :null => false
  end

  add_index "users", ["company_id"], :name => "index_users_on_company_id"

end

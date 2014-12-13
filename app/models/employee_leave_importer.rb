class EmployeeLeaveImporter < SalareeExcelImporter

  def import
    leave_sheet = spreadsheet.worksheets.first
    leave_month = Date.parse(leave_sheet.name).to_datetime
    @leaves = []
    leave_sheet.each(1) do |row|
      employee = company.employees.find_by_name(row.at(0))
      attrs = {}
      attrs[:company] = company
      attrs[:employee] = employee
      attrs[:present] = row.at(1)
      attrs[:absent] = row.at(2)
      attrs[:late_hours] = row.at(3)
      attrs[:overtime_hours] = row.at(4)
      attrs[:created_at] = leave_month
      @leaves << EmployeeLeave.create(attrs)
    end
    return @leaves
  end

end

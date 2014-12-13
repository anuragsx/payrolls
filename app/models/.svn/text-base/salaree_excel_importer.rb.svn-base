class SalareeExcelImporter

  attr_reader :company, :spreadsheet

  def initialize(company,file_param)
    @company = company
    Spreadsheet.client_encoding = 'UTF-8'
    raise "No Input File" if file_param.blank?
    @spreadsheet = Spreadsheet.open(file_param.local_path)
  end

end

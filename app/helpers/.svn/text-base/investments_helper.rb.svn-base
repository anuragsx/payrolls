module InvestmentsHelper
  def financial_year_select
    fin_year = []
    years = (5.years.ago.year..5.years.from_now.year)
    years.each do |year|
      fin_year << ["#{year}-#{year.next}",year]
    end
    fin_year
  end
end

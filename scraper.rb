# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

def row_value(row)
  row.at(:td).text
end

# remove whitespace
def cleanup_string(string)
  string.delete("\r\n\t").gsub(/\s$/, "")
end

require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new
page = agent.get('https://tenders.nsw.gov.au/rms/?event=public.cn.view&CNUUID=0B37D3B9-C218-BEC9-F42508EA7D143595')
table = page.at('#main-content table')
rows = table.css('> tr')


# Split the contract duration into a start and end date
contract_duration = cleanup_string(row_value(rows[5])).gsub(" to", "").split
contract_duration_start = Date.parse(contract_duration[0], '%d-%b-%Y').to_s
contract_duration_end = Date.parse(contract_duration[1], '%d-%b-%Y').to_s

contract_award_notice = {
  contract_award_notice_ID: row_value(rows[0]),
  agency: row_value(rows[1]),
  category: row_value(rows[2]),
  publish_date: Date.parse(row_value(rows[3]), ' %d-%b-%Y ').to_s,
  particulars_of_the_goods_or_services_to_be_provided_under_this_contract: row_value(rows[4]),
  contract_start_date: contract_duration_start,
  contract_end_date: contract_duration_end,
  contractor_name: row_value(rows[7]), # Contractor section
  acn: cleanup_string(row_value(rows[8])), # expect a 9 digit number for acn
  abn: cleanup_string(row_value(rows[9])),
  street_address: cleanup_string(row_value(rows[10])),
  town_or_city: row_value(rows[11]),
  state_or_territory: row_value(rows[12]),
  postcode: row_value(rows[13]), # Expect a valid post code
  country: row_value(rows[14]), # End contractor section
  other_private_sector_entities_involved_in_with_an_interest_in_or_benefiting_from_this_contract: "",
  contract_value: "",
  any_provisions_for_payment_to_the_contractor_for_operational_or_maintenance_services: "",
  method_of_tendering: "",
  description_of_any_provision_under_which_the_amount_payable_to_the_contractor_may_be_varied: "",
  description_of_any_provisions_under_which_the_contract_may_be_renegotiated: "",
  summary_of_the_criteria_against_which_the_various_tenders_were_assessed: "",
  contract_contains_agency_piggyback_clause: "",
  industrial_relations_details_for_this_contract: "",
  name_of_sub_contractors: "",
  applicable_industrial_instruments: "",
  location_of_work: "",
  agency_contact: "",
  agency_state: "",
  agency_country: "",
  agency_email_address: ""
}

# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".

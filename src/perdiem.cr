require "http/client"
require "json"
require "option_parser"
require "./perdiem/result"

# TODO: Write documentation for `Perdiem`
#
module Perdiem
  VERSION = "0.1.0"

  # TODO: Put your code here

  class Lookup
    BASE_URL = "https://api.gsa.gov/travel/perdiem/v2/rates"

    def initialize
      @city = ""
      @state = ""
    end

    def parse_arguments
      OptionParser.parse do |parser|
        parser.banner = "Usage: perdiem_lookup [arguments]"

        parser.on("-c CITY", "--city=CITY", "City name") do |city|
          @city = city
        end

        parser.on("-j", "--json", "Output results in JSON format") do
          @output_json = true
        end

        parser.on("-s STATE", "--state=STATE", "State abbreviation") do |state|
          @state = state
        end

        parser.on("-h", "--help", "Show this help") do
          puts parser
          exit
        end
      end

      validate_inputs
    end

    def validate_inputs
      if @city.empty?
        print "Enter city: "
        @city = gets.not_nil!.chomp
      end

      if @state.empty?
        print "Enter state abbreviation (e.g., CA, NY): "
        @state = gets.not_nil!.chomp
      end
    end

    def fetch_per_diem_rates
      # Note: You would need to replace this with an actual API key from GSA
      api_key = ENV["GSA_API_KEY"]?
      raise "Need to set ENV variable GSA_API_KEY" unless api_key

      url = "#{BASE_URL}/city/#{URI.encode_www_form(@city)}/state/#{URI.encode_www_form(@state)}/year/2025"

      response = HTTP::Client.get(
        url,
        # headers: HTTP::Headers{"Accept" => "application/json", "x-api-key" => api_key}
        headers: HTTP::Headers{"x-api-key" => api_key}
      )

      if response.success?
        parse_response(response.body)
      else
        puts "Error fetching per diem rates: #{response.status_code}"
        puts response.body
      end
    rescue ex
      puts "An error occurred: #{ex.message}"
    end

    def parse_response(body)
      result = Perdiem::Result.from_json(body)
    end

    def format_result(result)
      # Create a structured hash that can be easily converted to JSON or used for display
      formatted_data = {
        city:    @city,
        results: result.rates.map do |rate_result|
          {
            state: rate_result.state,
            year:  rate_result.year,
            rates: rate_result.rates.map do |rate|
              {
                city:       rate.city,
                meals_rate: rate.meals,
                lodging:    rate.months["month"].map do |month|
                  {
                    month_name:   month.long_name,
                    month_number: month.number,
                    amount:       month.amount,
                  }
                end,
              }
            end,
          }
        end,
      }
      formatted_data
    end

    def output_result(result)
      formatted_data = format_result(result)

      if @output_json
        # Output as JSON
        puts formatted_data.to_json
      else
        # Human-readable output
        formatted_data[:results].each do |rate_result|
          puts "State: #{rate_result[:state]}"
          puts "Year: #{rate_result[:year]}"

          rate_result[:rates].each do |rate|
            puts "City: #{rate[:city]}"
            puts "Meals Rate: $#{rate[:meals_rate]}"
            puts "Lodging Rates:"

            rate[:lodging].each do |month|
              puts "  #{month[:month_name]}: $#{month[:amount]}"
            end
            puts ""
          end
        end
      end
    end

    def puts_result(result)
      # Accessing data
      result.rates.each do |rate_result|
        puts "City: #{@city}"
        puts "State: #{rate_result.state}"
        puts "Year: #{rate_result.year}"

        rate_result.rates.each do |rate|
          puts "City: #{rate.city}"
          puts "Meals Rate: #{rate.meals}"

          puts "Lodging:"
          rate.months["month"].each do |month|
            puts "Month: #{month.long_name}, Amount: #{month.amount}"
          end
        end
      end
    end

    def run
      parse_arguments
      result = fetch_per_diem_rates
      if result
        output_result(result)
      end
    end
  end
end

# Run the application
begin
  Perdiem::Lookup.new.run
rescue ex
  puts "Unexpected error: #{ex.message}"
end

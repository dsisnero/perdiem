require "./spec_helper"

describe Perdiem::Lookup do
  # describe "#validate_inputs" do
  #   it "sets city and state if not provided" do
  #     lookup = Perdiem::Lookup.new
  #
  #     # Simulate user input
  #     def lookup.gets
  #       ["San Francisco", "CA"].each
  #     end
  #
  #     lookup.validate_inputs
  #
  #     # Since we can't directly access private instance variables,
  #     # we'll use reflection or add getter methods for testing
  #     lookup.instance_variable_get("@city").should eq "San Francisco"
  #     lookup.instance_variable_get("@state").should eq "CA"
  #   end
  # end
  #
  describe "#format_result" do
    it "creates a structured hash from API result" do
      lookup = Perdiem::Lookup.new

      # Create a mock result for testing
      mock_result = Perdiem::Result.from_json(%(
        {
          "rates": [
            {
              "state": "CA",
              "year": 2025,
              "isOconus": "false",
              "rate": [
                {
                  "city": "San Francisco",
                  "meals": 59,
                  "standardRate": "standard",
                  "months": {
                    "month": [
                      {
                        "value": 270,
                        "number": 1,
                        "short": "Jan",
                        "long": "January"
                      }
                    ]
                  }
                }
              ]
            }
          ]
        }
      ))

      # Set city for context
      # lookup.instance_variable_set("@city", "San Francisco")

      formatted_data = lookup.format_result(mock_result)

      # Validate the structure of the formatted data
      formatted_data[:city].should eq "San Francisco"
      formatted_data[:results].size.should eq 1

      result = formatted_data[:results].first
      result[:state].should eq "CA"
      result[:year].should eq 2025

      rates = result[:rates].first
      rates[:city].should eq "San Francisco"
      rates[:meals_rate].should eq 59

      lodging = rates[:lodging].first
      lodging[:month_name].should eq "January"
      lodging[:month_number].should eq 1
      lodging[:amount].should eq 270
    end
  end
end

  #   describe "CLI argument parsing" do
  #     it "sets output_json flag when -j is used" do
  #       lookup = Perdiem::Lookup.new
  #
  #       # Mock OptionParser to simulate CLI argument parsing
  #       parser = OptionParser.parse(["-c", "Denver", "-s", "CO", "-j"]) do |parser|
  #         parser.on("-c CITY", "--city=CITY", "City name") do |city|
  #           lookup.instance_variable_set("@city", city)
  #         end
  #
  #         parser.on("-s STATE", "--state=STATE", "State abbreviation") do |state|
  #           lookup.instance_variable_set("@state", state)
  #         end
  #
  #         parser.on("-j", "--json", "Output results in JSON format") do
  #           lookup.instance_variable_set("@output_json", true)
  #         end
  #       end
  #
  #       lookup.instance_variable_get("@city").should eq "Denver"
  #       lookup.instance_variable_get("@state").should eq "CO"
  #       lookup.instance_variable_get("@output_json").should be_true
  #     end
  #   end
  # end

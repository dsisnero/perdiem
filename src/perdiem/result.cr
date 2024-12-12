require "json"

module Perdiem
  class Month
    include JSON::Serializable

    @[JSON::Field(key: "value")]
    property amount : Int32

    @[JSON::Field(key: "number")]
    property number : Int32

    @[JSON::Field(key: "short")]
    property short_name : String

    @[JSON::Field(key: "long")]
    property long_name : String

    def to_s(io : IO)
      io << "#{short_name}\t#{amount}"
    end
  end

  class Rate
    include JSON::Serializable

    @[JSON::Field(key: "months")]
    property months : Hash(String, Array(Month))

    @[JSON::Field(key: "meals")]
    property meals : Int32

    @[JSON::Field(key: "city")]
    property city : String?

    @[JSON::Field(key: "standardRate")]
    property standard_rate : String
  end

  class RateResult
    include JSON::Serializable

    @[JSON::Field(key: "state")]
    property state : String

    @[JSON::Field(key: "year")]
    property year : Int32

    @[JSON::Field(key: "isOconus")]
    property is_oconus : String

    @[JSON::Field(key: "rate")]
    property rates : Array(Rate)
  end

  class Result
    include JSON::Serializable

    @[JSON::Field(key: "rates")]
    property rates : Array(RateResult)

    def to_s(io : IO)
      rate = rates.first
      io << "Perdiem for #{rate.state} year #{rate.year}"
      rate.rates.each do |r|
        io << "meals: #{meals}\n"
        io << "Month\tAmount\n"
        r.months.each do |_|
          io << "#{short_name}\t#{amount}\n"
        end
      end
    end
  end
end

# Perdiem CLI

A command-line tool to fetch and display Per Diem rates for US cities using the GSA (General Services Administration) Per Diem API.

## Overview

The Perdiem CLI allows you to quickly retrieve per diem rates for specific cities and states. Per diem rates are daily allowance rates for meals and lodging used for travel reimbursement by government employees and contractors.

## Features

- Fetch per diem rates for a specific city and state
- Output rates in human-readable format
- Optional JSON output for scripting and integration
- Interactive input for city and state if not provided

## Prerequisites

- Crystal programming language
- GSA API Key (free to obtain from the GSA website)

## Installation

1. Ensure you have Crystal installed
2. Clone the repository:
   ```
   git clone https://github.com/dsisnero/perdiem.git
   cd perdiem
   ```
3. Build the project:
   ```
   crystal build src/perdiem.cr -o perdiem
   ```

## Usage

### Set GSA API Key

Before using the tool, set your GSA API key:
```bash
export GSA_API_KEY=your_api_key_here
```

### Basic Usage

Retrieve per diem rates by specifying a city and state:
```bash
# Interactive mode
./perdiem

# Specify city and state
./perdiem -c "San Francisco" -s CA
```

### JSON Output

For scripting or integration, use the JSON flag:
```bash
./perdiem -c "New York" -s NY -j
```

### Help

View available options:
```bash
./perdiem -h
```

## Example Output

Human-readable output:
```
State: CA
Year: 2025
City: San Francisco
Meals Rate: $59
Lodging Rates:
  January: $270
  February: $270
  ...
```

JSON output:
```json
{
  "city": "San Francisco",
  "results": [
    {
      "state": "CA",
      "year": 2025,
      "rates": [
        {
          "city": "San Francisco",
          "meals_rate": 59,
          "lodging": [
            {
              "month_name": "January",
              "month_number": 1,
              "amount": 270
            }
          ]
        }
      ]
    }
  ]
}
```

## Development

1. Install dependencies:
   ```
   shards install
   ```

2. Run tests:
   ```
   crystal spec
   ```

3. Build the project:
   ```
   crystal build src/perdiem.cr
   ```

## Contributing

1. Fork it (<https://github.com/dsisnero/perdiem/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

TODO: Add license information

## Contributors

- [Dominic Sisneros](https://github.com/dsisnero) - creator and maintainer

#!/bin/bash

# Replace 'YOUR_API_KEY' with your actual OpenWeather API key
api_key=$(cat keys.txt)
zip_code="$1"

if [ -z "$zip_code" ]; then
    echo "Usage: $0 <zip_code>"
    exit 1
fi

# API endpoint URL for current weather by zip code
api_url="https://api.openweathermap.org/data/2.5/weather?zip=$zip_code&appid=$api_key"

# Make a GET request to the API
response=$(curl -s "$api_url")

if [ $? -eq 0 ]; then
    # Parse JSON response using jq
    temperature=$(echo "$response" | jq -r '.main.temp')
    description=$(echo "$response" | jq -r '.weather[0].description')
    city=$(echo "$response" | jq -r '.name')

    temperature_fahrenheit=$(echo "scale=2; ($temperature - 273.15) * 9/5 + 32" | bc)

    echo "Weather in $zip_code:"
    echo "Temperature: $temperature_fahrenheit °F"
    echo "Description: $description"
    echo "City: $city"
    echo "Date: $(date +%c)"
else
    echo "Error: Failed to retrieve weather data"
fi

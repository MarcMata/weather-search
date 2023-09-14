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
    temperature=$(echo "$response" | jq '.main.temp')
    description=$(echo "$response" | jq -r '.weather[0].description')

    echo "Weather in $zip_code:"
    echo "Temperature: $temperature °K"
    echo "Description: $description"
else
    echo "Error: Failed to retrieve weather data"
fi

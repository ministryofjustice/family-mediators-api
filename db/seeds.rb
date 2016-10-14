module API
  module Models
    Mediator.create! data: '{
      "name": "Ned Kelly",
      "practices": [
        {
          "address": "11 Bobbins Street, Cribbinshire",
          "postcode": "E7 0LN",
          "geo": {
            "lat": 51.623,
            "lon": 0.0899
          }
        }
      ]
    }'

    Mediator.create! data: '{
      "name": "Professor Edmund Swipebrow",
      "practices": [
        {
          "address": "123 Kelkirk Ave, Shireshire",
          "postcode": "E7 0LN",
          "geo": {
            "lat": 51.345,
            "lon": 0.0234
          }
        }
      ]
    }'

    Mediator.create! data: '{
      "name": "John Smith",
      "practices": [
        {
          "address": "10 Hobbit Street, The Shire",
          "postcode": "E7 0LN",
          "geo": {
            "lat": 51.553712,
            "lon": 0.03102
          }
        },
        {
          "address": "Calle de Noaqui, San Suspicio",
          "postcode": "89675",
          "geo": {
            "lat": 51.55,
            "lon": 100.03102
          }
        }
      ]
    }'
  end
end

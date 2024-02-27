# TEST_TASK_dotidot

## As a Dotidot user, I have the option to use the Scraper to expand my data with new fields. The goal of the task is to create a standalone Rails application with a simple interface for the scraper. It should receive a URL address and a list of fields to extract from webpage on given URL address in the request.

### Task #1

Basic behavior of the scraper, i.e., using simple CSS selectors.

Request:

GET /data

JSON params:

{"url": "https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm", "fields":{"price":".price-box__price","rating_count":".ratingCount","rating_value":".ratingValue"}}

Response:

{
"price": "18290,-",
"rating_value": "4,9",
"rating_count": "7 hodnocení"
}

    curl -d '{"url":"https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm","fields":{"price":".price-box__price","rating_count":".ratingCount","rating_value":".ratingValue"}}' -H "Content-Type: application/json" -X GET http://localhost:3000/data
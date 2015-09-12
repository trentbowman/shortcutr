# shortcutr

Service to shorten URLs.

## Design

Full-length URLs are paired with a random 6-digit string (called the target) made up of digits that aren't easily confused (only 0, no O and o). This pairing is called a shortcut and is the main data model of the application.

The 6 digits each have 32 possible values (essentially 5 bits), so the entire string represents 2^30 possibilities. The number of
digits, or the values per digit, could be adjusted to provide more entropy.

To decrease the possibility that simple transcription errors would yield a valid shortcut, there is an additional validation
that no target has a Hamming distance of less than 2 for any other target, meaning a new shortcut can't have a target that differs
in only one digit from all other shortcuts.

## Getting up and running

Requires Ruby 2.2.

    bundle install
    rake db:migrate
    rake
    rails server

A web portal will then be available at http://localhost:3000/shortcuts

## Using the API
### Creating a shortcut

    > curl -X POST -H 'Content-Type: application/json' http://localhost:3000/shortcuts.json -d '{"url":"http://stackoverflow.com/questions/32520595/heap-overflow-in-haskell"}'
    {"id":12,"url":"http://stackoverflow.com/questions/32520595/heap-overflow-in-haskell","short_url":"http://localhost:3000/dr48gu","target":"dr48gu","created_at":"2015-09-12T19:52:11.171Z","updated_at":"2015-09-12T19:52:11.171Z"}

The short URL is returned as the "short_url" property of the JSON response.

### Retrieving a shortcut

    > curl http://localhost:3000/shortcuts/dr48gu.json
    {"id":12,"url":"http://stackoverflow.com/questions/32520595/heap-overflow-in-haskell","short_url":"http://localhost:3000/dr48gu","target":"dr48gu","created_at":"2015-09-12T19:52:11.171Z","updated_at":"2015-09-12T19:52:11.171Z"}

### Deleting a shortcut

    > curl -X DELETE http://localhost:3000/shortcuts/dr48gu.json

### Resolving a shortcut

	> curl http://localhost:3000/dr48gu

This results in a redirect to http://stackoverflow.com/questions/32520595/heap-overflow-in-haskell.
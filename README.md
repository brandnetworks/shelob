# Shelob

Shelob is a giant spider that starts on a given page, finds all links on the page, ensure they resolve, and recurses if the link is underneath the starting url. Intended primarily for double checking that your site has no horrible error pages to be exposed to the user by clicking on a link. 

## Usage

    shelob [-r|v] root_url

    -r: really verbose, will print each url it checks
    -v: verbose, will just print a progress indicator for each url so you don't think it just stopped

You can also use the link resolver, extractor, or the spider itself programmatically. Check the tests for usage until I can write up some good documentation...

## Installation

Shelob requires Ruby 1.9.3 or newer. Hopefully this isn't a problem, but if so, check out RVM!

Add this line to your application's Gemfile:

    gem 'shelob'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shelob

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Make sure you have tests, and they pass! (`rake`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

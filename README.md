# Unbundler

Remove gems installed by bundler

## Installation

Add this line to your application's Gemfile:

    gem 'unbundler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unbundler

## Usage

`unbundle` - uninstall all gems installed by current bundle except gems in global keep list
`unbundle --keep gem1` - uninstall all gems except gem1 and gems in global keep list
`unbundle show` or `unbundle list` - show list of gems to be unbundled
`unbundle edit_keep_list` - open global keep list in default editor

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

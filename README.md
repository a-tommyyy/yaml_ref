[![Build Status](https://travis-ci.org/atomiyama/yaml_ref.svg?branch=master)](https://travis-ci.org/atomiyama/yaml_ref)

# YamlRef

YamlRef allows you to define $ref that refers file with relative path.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yaml_ref'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install yaml_ref

## Usage

```ruby
require 'yaml_ref'

YamlRef.load_file("/path/to/yaml")
```

It has the following effects:

```yaml
gem:
  name: YamlRef
  information:
    $ref: '../information.yml'
  license:
    $ref: '#/schema/MIT'
  releases:
    - $ref: '../releases/0_0_1.yml'
```

```yaml
gem:
  name: YamlRef
  information:
    # contents of information.yaml
    summary: "YAML file ref resolver"
    description: "Expand the $ref that refers to the file in the yaml file."
  license:
    $ref: '#/schema/MIT'
  releases:
    # contents of realeases/0_0_1.yaml
    - version: "0.0.1"
      features:
        vision: 'Allow file $ref with relative path.'
      authors:
        - 'atomiyama'

```

### Relative path home.
If ref path(e.g. `$ref: 'path/to/file/from/specific/location'`) is defined as a relative path from a specific location.
Pass `ref_home` keyword argument or define ref_home on root level in YAML file it works fine.

```ruby
# ref_home argument
YamlRef.load_file("/path/to/yaml", ref_home: "/path/to/ref_home")
```

```yaml
# ~/home.yml
ref_home: "~"
yaml_ref:
  # This $ref will expand ~/reference.yml
  $ref: 'reference.yml'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yaml_ref_resolver. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/yaml_ref_resolver/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YamlRefResolver project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/yaml_ref_resolver/blob/master/CODE_OF_CONDUCT.md).

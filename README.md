# attr_encrypted_pgcrypto

[![Dependency Status](https://gemnasium.com/gabetax/attr_encrypted_pgcrypto.png)](https://gemnasium.com/gabetax/attr_encrypted_pgcrypto)

A [pgcrypto](http://www.postgresql.org/docs/9.1/static/pgcrypto.html)-based [Encryptor](https://github.com/shuber/encryptor) implementation for [attr_encrypted](https://github.com/shuber/attr_encrypted). It delegates to `pgp_sym_encrypt()` and `pgp_sym_decrypt()` to provide symmetric-key encryption. It's useful if you need to:

- Access the plain text values directly from SQL without bringing the data into Ruby
- Integrate databases managed by other applications

Is this library a bad idea? _Potentially!_ Please open an issue to discuss and help document any caveats.

## Installation

Add this line to your application's Gemfile:

    gem 'attr_encrypted_pgcrypto'

And then execute:

    $ bundle

Your platform may not ship with the pgcrypto extensions by default. On Ubuntu, run:

`apt-get install postgresql-contrib-9.1`

Generate a migration to load the pgcrypto extension into your database. Your user will need [superuser privileges](http://www.postgresql.org/docs/9.1/static/sql-createextension.html) to run this query, so you may need to manually run this via `psql` as the `postgres` user if your Rails database user does not have access.

```ruby
execute("CREATE EXTENSION IF NOT EXISTS pgcrypto")
```

Extensions are database specific. To ensure that the extension is also enabled for your test database, rails needs to use the [sql schema format](http://api.rubyonrails.org/classes/ActiveRecord/Base.html#method-c-schema_format). Edit `config/application.rb` to set:

```ruby
config.active_record.schema_format = :sql
```

## Usage

See [attr_encrypted's Custom encryptor documentation](https://github.com/shuber/attr_encrypted#custom-encryptor).

```ruby
class User
  attr_encrypted :ssn, :key => 'a secret key', :encryptor => AttrEncryptedPgcrypto::Encryptor, :encode => false
end
```

If you do not disable `:encode`, attr_encrypted will base64 encode the output, defeating the purpose of being able to query the data directly from SQL.

This is an example - please don't actually embed your keys directly in your model as literal strings, or even commit them in your repository. I recommend storing your key in a .gitignored config/pgcrypto_key.txt file, having capistrano (or your preferred deployment utility) copy this from a local 'shared/' folder, and reading the value into `Rails.application.config.pgcrypto` via an initializer.

## Caveats

- Your key is embedded into any SQL queries. The key itself will be automatically filtered from your Rails logs. However, make sure you are using a secured or private connection between your Rails server and your database.
- Unlike the OpenSSL algorithms used in the default Encryptor, `pgp_sym_encrypt()` uses an IV and will generate different cipher text every call. While this is more secure, you will not be able to use attr_encrypted's [find_by_ methods](https://github.com/shuber/attr_encrypted#dynamic-find_by_-and-scoped_by_-methods).

## Benchmarks

pgcrypto comes out slightly faster than the OpenSSL implementation used in the default encryptor.

```
Benchmarking 10000 calls
               user     system      total        real
pgcrypto   1.640000   1.590000   3.230000 ( 11.775697)
openssl   15.740000   0.000000  15.740000 ( 15.704010)
```

Since pgcrypto is executed in a separate process, pay attention to the 'real' column for the relevant metric.

Setup spec/database.yml and run `rake benchmark` to test the results on your own system. You may pass an optional 'count' parameter via `rake "benchmark[100000]"`.

## Compatability

Tested against:

- MRI Ruby 1.9.3
- Rails 3.2.11
- attr_encrypted 1.2.1
- PostgreSQL 9.1

## Credits

The bulk of this code is a humble verbatim copy and paste job from [jmazzi's crypt_keeper gem](https://github.com/jmazzi/crypt_keeper). Thanks, Justin!

Why not just use crypt_keeper? crypt_keeper uses ActiveRecord callbacks to encrypt and decrypt, while attr\_encrypted defines accessor methods. This means:

- Model instances are always dirty after a fetch.
- Data is eagerly encrypted and decrypted, causing unnecessary extra queries.
- Other callback based dependencies (e.g. papertrail) may receive either the encrypted or plaintext version of the columns.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

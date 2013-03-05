require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')

# If you want to make this the default task
task default: :spec

desc 'Encryption Benchmark'
task  :benchmark, :count do |t, args|
  require './lib/attr_encrypted_pgcrypto'
  require 'benchmark'

  count  = (args[:count] || 10000).to_i
  key    = 'x9IuxbAft2Q4sQIgNvG5xvYLWLe3qIoXBvr7wjmyPm4i0F84lgdv66wBcOECIDwq'
  string = '123-45-6789'
  config = YAML.load_file 'spec/database.yml'
  ::ActiveRecord::Base.establish_connection(config['postgres'])

  puts "Benchmarking #{count} calls"
  Benchmark.bmbm do |b|
    b.report('pgcrypto') do
      count.times do |i|
        AttrEncryptedPgcrypto::Encryptor.encrypt "string#{i}", key: key
      end
    end

    b.report('openssl') do
      count.times do |i|
        Encryptor.encrypt "string#{i}", key: key
      end
    end
  end
end

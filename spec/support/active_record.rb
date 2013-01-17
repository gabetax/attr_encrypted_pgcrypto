require 'active_record'
require 'logger'

::ActiveRecord::Base.logger = Logger.new SPEC_ROOT.join('debug.log').to_s
::ActiveRecord::Migration.verbose = false

module AttrEncryptedPgcrypto
  class SensitiveData < ActiveRecord::Base; end

  module ConnectionHelpers
    def use_postgres
      before :all do
        ::ActiveRecord::Base.clear_active_connections!
        config = YAML.load_file SPEC_ROOT.join('database.yml')
        ::ActiveRecord::Base.establish_connection(config['postgres'])
      end
    end

  end
end


RSpec.configure do |config|
  config.extend AttrEncryptedPgcrypto::ConnectionHelpers
end

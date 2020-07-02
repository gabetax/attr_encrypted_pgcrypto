require 'active_record'
require 'active_record/log_subscriber'
require 'active_support/concern'
require 'active_support/lazy_load_hooks'

module AttrEncryptedPgcrypto
  module LogSubscriber
    module PostgresPgp
      extend ActiveSupport::Concern

      included do
        alias_method :sql_without_postgres_pgp, :sql
        alias_method :sql, :sql_with_postgres_pgp
      end

      # Public: Prevents sensitive data from being logged
      def sql_with_postgres_pgp(event)
        filter = /(pgp_sym_(encrypt|decrypt))\(((.|\n)*?)\)/i

        event.payload[:sql] = event.payload[:sql].gsub(filter) do |_|
          "#{$1}([FILTERED])"
        end

        sql_without_postgres_pgp(event)
      end
    end
  end
end

ActiveSupport.on_load :attr_encrypted_pgcrypto_posgres_pgp_log do
  ActiveRecord::LogSubscriber.send :include, AttrEncryptedPgcrypto::LogSubscriber::PostgresPgp
end

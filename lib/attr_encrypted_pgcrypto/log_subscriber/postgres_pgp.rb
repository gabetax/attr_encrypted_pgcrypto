require 'active_record'
require 'active_record/log_subscriber'

module AttrEncryptedPgcrypto
  module LogSubscriber
    module PostgresPgp
      def sql(event)
        filter = /(pgp_sym_(encrypt|decrypt))\(((.|\n)*?)\)/i

        event.payload[:sql] = event.payload[:sql].gsub(filter) do |_|
          "#{$1}([FILTERED])"
        end

        super
      end
    end
  end
end

ActiveRecord::LogSubscriber.send(:prepend, AttrEncryptedPgcrypto::LogSubscriber::PostgresPgp)

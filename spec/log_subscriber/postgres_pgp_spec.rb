require 'spec_helper'

module AttrEncryptedPgcrypto::LogSubscriber
  describe PostgresPgp do
    use_postgres

    subject { ::ActiveRecord::LogSubscriber.new }

    let(:input_query) do
      "SELECT pgp_sym_encrypt('encrypt_value', 'encrypt_key'), pgp_sym_decrypt('decrypt_value', 'decrypt_key') FROM DUAL;"
    end

    let(:output_query) do
      "SELECT pgp_sym_encrypt([FILTERED]), pgp_sym_decrypt([FILTERED]) FROM DUAL;"
    end

    it "filters pgp functions" do
      expect(subject).to receive(:sql) do |event|
        expect(event.payload[:sql]).to eq(output_query)
      end

      subject.sql(ActiveSupport::Notifications::Event.new(:sql, 1, 1, 1, { sql: output_query }))
    end
  end
end

module AttrEncryptedPgcrypto
  module Encryptor

    extend self
    ActiveSupport.run_load_hooks(:attr_encrypted_pgcrypto_posgres_pgp_log, self)

    # Encrypts a <tt>:value</tt> with a specified <tt>:key</tt>
    #
    # Example
    #
    #   encrypted_value = AttrEncryptedPgcrypto::Encryptor.encrypt(:value => 'some string to encrypt', :key => 'some secret key')
    #   # or
    #   encrypted_value = AttrEncryptedPgcrypto::Encryptor.encrypt('some string to encrypt', :key => 'some secret key')
    def encrypt(*args, &block)
      escape_and_execute_sql(["SELECT pgp_sym_encrypt(?, ?)", value(args), key(args)])['pgp_sym_encrypt']
    end

    # Decrypts a <tt>:value</tt> with a specified <tt>:key</tt>
    #
    # Example
    #
    #   decrypted_value = AttrEncryptedPgcrypto::Encryptor.decrypt(:value => 'some encrypted string', :key => 'some secret key')
    #   # or
    #   decrypted_value = AttrEncryptedPgcrypto::Encryptor.decrypt('some encrypted string', :key => 'some secret key')
    def decrypt(*args, &block)
      escape_and_execute_sql(["SELECT pgp_sym_decrypt(?, ?)", value(args), key(args)])['pgp_sym_decrypt']
    end

    protected

    def value(args)
      if args.first.is_a?(String)
        args.first
      else
        args.last[:value]
      end
    end

    def key(args)
      args.last.is_a?(Hash) && args.last[:key] || (raise ArgumentError.new('must specify a :key'))
    end

    def escape_and_execute_sql(query)
      query = ::ActiveRecord::Base.send :sanitize_sql_array, query
      ::ActiveRecord::Base.connection.execute(query).first
    end
  end
end

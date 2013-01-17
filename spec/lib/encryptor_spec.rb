require 'spec_helper'

describe AttrEncryptedPgcrypto::Encryptor do
  use_postgres

  subject { AttrEncryptedPgcrypto::Encryptor }
  let(:plaintext) { "Hello, World!" }
  let(:cipher) { "\\xc30d040703027a5b637f1c6654686cd23e01bb477e90e6483b9f270ce2a5a2a1694e1d0df4ebf95aaca80e0825a42c8ec3c70dff19a421f54ae785a2d35b6c48d0f9e5108a34fbf6b681f92f739e0f" }
  let(:key) { "What do you want? I'm a test key!" }
  describe "#encrypt" do
    context "without key" do
      it do
        expect { subject.encrypt "plaintext" }.to raise_exception(ArgumentError)
      end
    end

    context "valid" do
      it "returns cipher text" do
        AttrEncryptedPgcrypto::Encryptor.encrypt(plaintext, key: key).should be_a(String)
      end
    end
  end

  describe "#decrypt" do
    context "valid" do
      it "returns plaintext" do
        AttrEncryptedPgcrypto::Encryptor.decrypt(cipher, key: key).should == plaintext
      end
    end

    context "invalid" do
      let(:key) { "This is not the key you're looking for." }
      specify do
        expect { AttrEncryptedPgcrypto::Encryptor.decrypt(cipher, key: key) }.to raise_exception(ActiveRecord::StatementInvalid)
      end
    end
  end
end

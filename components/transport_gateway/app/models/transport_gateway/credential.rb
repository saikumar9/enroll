module TransportGateway
  class Credential
    include Mongoid::Document

    field :account_name, type: String
    field :private_rsa_key, type: String
    field :pass_phrase, type: String


    def export_key
    end

    def update_key(file_path)
      File.read(file_path)
    end


  end
end

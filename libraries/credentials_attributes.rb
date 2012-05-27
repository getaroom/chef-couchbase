module Couchbase
  module CredentialsAttributes
    def username(value=nil)
      set_or_return :username, value, :kind_of => String, :default => "Administrator"
    end

    def password(value=nil)
      set_or_return :password, value, :kind_of => String
    end
  end
end

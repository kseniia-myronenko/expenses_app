module Helpers
  module UserAuthHelper
    PASSWORD = 'securepassword'.freeze

    def authenticate(user)
      post login_path(username: user.username, password: PASSWORD)
    end
  end
end

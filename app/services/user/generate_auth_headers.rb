class User::GenerateAuthHeaders
  attr_reader :oauth2, :access_token

  def initialize(access_token)
    @oauth2 = Google::Apis::Oauth2V2::Oauth2Service.new
    @access_token = access_token
  end

  def perform
    tokeninfo = @oauth2.tokeninfo(access_token: @access_token)
    user = User.find_or_create_by(email: tokeninfo.email)
    token = DeviseTokenAuth::TokenFactory.create

    # store client + token in user's token hash
    user.tokens[token.client] = {
      token:  token.token_hash,
      expiry: token.expiry
    }

    # generate auth headers for response
    new_auth_header = user.build_auth_header(token.token, token.client)
    user.save

    new_auth_header
  end
end

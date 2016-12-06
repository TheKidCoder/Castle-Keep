require 'castle/keep/version'
require 'net/https'
require 'json'

module Castle
  def self.api_key
    @@api_key
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  class Keep
    def initialize(cookie_id, ip, headers)
      @http = Net::HTTP.new "api.castle.io", 443
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      @headers = {
        "Content-Type" => "application/json",
        "X-Castle-Cookie-Id" => cookie_id,
        "X-Castle-Ip" => ip,
        "X-Castle-Headers" => headers.to_json,
      }
    end

    # Available events:
    # $login.succeeded: Record when a user attempts to log in.
    # $login.failed: Record when a user login failed.
    # $logout.succeeded: Record when a user logs out.
    # $registration.succeeded: Capture account creation, both when a user signs up as well as when created manually by an administrator.
    # $registration.failed: Record when an account failed to be created.
    # $email_change.requested: An attempt was made to change a user’s email.
    # $email_change.succeeded: The user completed all of the steps in the email address change process and the email was successfully changed.
    # $email_change.failed: Use to record when a user failed to change their email address.
    # $password_reset.requested: An attempt was made to reset a user’s password.
    # $password_reset.succeeded: The user completed all of the steps in the password reset process and the password was successfully reset. Password resets do not required knowledge of the current password.
    # $password_reset.failed: Use to record when a user failed to reset their password.
    # $password_change.succeeded: Use to record when a user changed their password. This event is only logged when users change their own password.
    # $password_change.failed: Use to record when a user failed to change their password.
    def track(event_name, user_id = nil, details: nil)
      if user_id.nil? and details.nil?
        fail ArgumentError, "Missing both user_id and details"
      end

      req = Net::HTTP::Post.new("/v1/events", @headers)
      req.basic_auth("", Castle.api_key)
      req.body = { name: event_name, user_id: user_id, details: details }.to_json
      response = @http.request(req)
      unless response.code.to_i == 204
        fail Error, "Response code: #{response.code}\nResponse body: #{response.body}"
      end
    end

    def events(user_id, page: 1, page_size: 200)
      req = Net::HTTP::Get.new("/v1/events?query=user_id:#{user_id}&page=#{page}&page_size=#{page_size}", @headers)
      req.basic_auth("", Castle.api_key)
      response = @http.request(req)
      unless response.code.to_i == 200
        fail Error, "Response code: #{response.code}\nResponse body: #{response.body}"
      end
    end

    def create_auth(user_id)
      req = Net::HTTP::Post.new("/v1/authentications", @headers)
      req.basic_auth("", Castle.api_key)
      req.body = { user_id: user_id }.to_json
      response = @http.request(req)
      unless response.code.to_i == 201
        fail Error, "Response code: #{response.code}\nResponse body: #{response.body}"
      end
      JSON.parse response.body
    end

    def approve_auth(auth_id)
      req = Net::HTTP::Post.new("/v1/authentications/#{auth_id}/approve", @headers)
      req.basic_auth("", Castle.api_key)
      response = @http.request(req)
      unless response.code.to_i == 204
        fail Error, "Response code: #{response.code}\nResponse body: #{response.body}"
      end
    end

    def deny_auth(auth_id)
      req = Net::HTTP::Post.new("/v1/authentications/#{auth_id}/deny", @headers)
      req.basic_auth("", Castle.api_key)
      response = @http.request(req)
      unless response.code.to_i == 204
        fail Error, "Response code: #{response.code}\nResponse body: #{response.body}"
      end
    end

    class Error < StandardError; end
  end
end

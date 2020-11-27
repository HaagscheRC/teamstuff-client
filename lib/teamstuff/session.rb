module Teamstuff

  class NotLoggedIn < StandardError
  end

  def self.login *args
    @session ||= Client.new *args
  end

  def self.session
    @session ? @session : raise(NotLoggedIn, "please login first using Teamstuff.login")
  end

  module Session

    def self.included(base)
      base.extend Session
    end

    def session
      Teamstuff.session
    end

    def http_client
      session.http_client
    end

  end

end

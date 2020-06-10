require 'http'
require 'pry'
require 'active_support/time'

module Teamstuff
  class Client

    class RequestFailed < StandardError
    end

    class LoginFailed < RequestFailed
    end

    attr_reader :userinfo, :context

    def initialize username, password
      @cookies = []

      login username, password
      get_context
    end

    def http_client
      HTTP.cookies(@cookies)
          .headers(:accept => "application/vnd.teamstuff.com.v13+json, application/json")
    end

    private def json_response err_class = RequestFailed
      response = yield

      if response.status.success?
        JSON.parse response.to_s
      else
        raise err_class, response.to_s
      end
    end

    def login username, password
      login_url = 'https://coachstuff.com/data/sessions'
      login_params =
          {
              email: username,
              password: password,
              remember_me: true,
          }

      response = http_client.post(login_url, json: login_params)

      if response.status.success?
        @userinfo = JSON.parse response.to_s
        @cookies = response.cookies
      else
        raise LoginFailed, response.to_s
      end
    end

    def get_context
      context_url = 'https://coachstuff.com/data/context'
      @context = json_response { http_client.get(context_url) }
    end

    def get_events from = Time.now.at_beginning_of_week, to = Time.now.at_end_of_week
      events_url = 'https://teamstuff.com/data/events'
      params =
          {
              start_date: from.iso8601,
              end_date: to.iso8601
          }

      json_response { http_client.get(events_url, params: params) }
    end

  end
end

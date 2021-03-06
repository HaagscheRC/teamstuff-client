require 'http'
require 'pry'
require 'hashie'
require 'active_support/time'

require_relative 'session'
require_relative 'invite'
require_relative 'member'
require_relative 'membership'
require_relative 'team'

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

    def json_response err_class = RequestFailed
      response = yield http_client

      if response.status.success?
        Hashie::Mash.new(JSON.parse response.to_s)
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

    def user_id
      userinfo['id']
    end

    def get_member id = user_id
      json_response { http_client.get "https://teamstuff.com/data/members/#{id}" }
    end

    def get_member_profiles id = user_id
      json_response { http_client.get "https://teamstuff.com/data/members/#{id}/profiles/" }
    end

    def get_context
      @context = json_response do |client|
        client.get 'https://coachstuff.com/data/context'
      end
    end

    def get_events from = Time.now.at_beginning_of_week, to = Time.now.at_end_of_week
      json_response do |client|
        client.get 'https://teamstuff.com/data/events',
                   params:
                       {
                           start_date: from.iso8601,
                           end_date: to.iso8601
                       }

      end
    end

    def get_payments
      json_response do |client|
        client.get 'https://teamstuff.com/data/payment-items',
                   params: {my_payments: true}
      end
    end

    def get_current_duties
      get_duties current: true
    end

    def get_duties params = {history: true}
      json_response do |client|
        client.get 'https://teamstuff.com/data/duties',
                   params: params
      end
    end

    def get_teams
      json_response { |cl| cl.get 'https://teamstuff.com/data/teams' }
          .fetch('teams', [])
          .map { |team| Team.new team }
    end

    def get_team id
      resp = json_response { |cl| cl.get "https://teamstuff.com/data/teams/#{id}" }
      Team.new resp
    end

    def get_activities max_entries: 50, page: 0
      json_response do |client|
        client.get('https://teamstuff.com/data/activities',
                   params: {page_size: max_entries, page_num: page}
        )
      end
    end

    def get_alerts
      json_response do |client|
        client.get('https://teamstuff.com/data/alerts')
      end
    end

  end
end

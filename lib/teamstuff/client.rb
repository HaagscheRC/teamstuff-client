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
      response = yield http_client

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
    end

    def create_team team_name:, sport:, league:, invites: [], open_invite: true, kids_team: true

      team_params =
          {
              name: team_name,
              kids_team: kids_team,
              open_invitation_enabled: open_invite,
              sport_attributes: {name: sport},
              league_attributes: {name: league},
              team_invitations_attributes: invites
          }

      json_response do |client|
        client.post 'https://teamstuff.com/data/teams', json: {team: team_params}
      end
    end

    def delete_team id:
      http_client
          .delete("https://teamstuff.com/data/teams/#{id}")
          .status.success?
    end

  end
end

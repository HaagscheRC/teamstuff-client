module Teamstuff
  class Team < Hashie::Mash

    include Teamstuff::Session
    include Hashie::Extensions::Coercion

    coerce_key :team_memberships, Set[MemberShip]

    #   "https://teamstuff.com/data/teams/#{id}"
    # end
    #

    def memberships
      team_memberships
    end

    def invitations
      team_invitations
    end

    def get_games
      %w(Game1 Game2)
    end

    def self.create! name, sport:, league: '', invites: [], open_invite: false, kids_team: true

      default_manager = Teamstuff::Invitation.new member_type: 'manager',
                                                  email: session.userinfo['email'],
                                                  name: session.userinfo['nickname']
      invites << default_manager

      team_params =
          {
              name: name,
              kids_team: kids_team,
              open_invitation_enabled: open_invite,
              sport_attributes: {name: sport},
              league_attributes: {name: league},
              team_invitations_attributes: invites.map { |e| Invitation.new(e.symbolize_keys) }
          }

      resp = session.json_response do |client|
        client.post 'https://teamstuff.com/data/teams', json: {team: team_params}
      end

      Team.new resp
    end

    def save!
      save_keys = %w( name more_info email_alias club_name address location_data country url phone_number club_email_alias
                      club_id current_season_id attendance_changes_alerts_enabled attendance_changes_alert_enabled attendance_changes_alert_period_in_seconds
                      attendance_changes_push_enabled attendance_changes_push_period_in_seconds attendance_changes_email_enabled attendance_changes_email_period_in_seconds
                      attendance_changes_sms_enabled attendance_changes_sms_period_in_seconds bcc_emails duty_reminder_enabled kids_team open_invitation_enabled
                      results_string_format show_games_attended_stats show_percent_games_attended_stats show_trainings_attended_stats show_percent_trainings_attended_stats
                      show_games_attended_stats_in_team_player_summary show_percent_games_attended_stats_in_team_player_summary show_trainings_attended_stats_in_team_player_summary
                      show_percent_trainings_attended_stats_in_team_player_summary players_can_claim_duties limit_player_per_game limit_attendance_enabled
                      whole_team_messaging_enabled sport_attributes league_attributes team_invitations_attributes default_game_roster_entry_status default_training_roster_entry_status)

      save_data = select { |k, _v| save_keys.include? k }

      resp = session.json_response do |client|
        client.put "https://teamstuff.com/data/teams/#{id}", json: {team: save_data}
      end

      Team.new resp
    end

    def delete!
      http_client
          .delete("https://teamstuff.com/data/teams/#{id}")
          .status.success?
    end

  end
end

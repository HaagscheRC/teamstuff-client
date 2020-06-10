module Teamstuff
  RSpec.describe Client do

    def ts_credentials
      [
          ENV['TS_USERNAME'],
          ENV['TS_PASSWORD']
      ]
    end

    context "With invalid credentials" do
      it "login will fail with LoginFailed" do
        expect { Client.new 'invalid_username', 'invalid_password' }
            .to raise_error Client::LoginFailed
      end
    end

    context "With valid credentials" do

      before(:context) do
        @client = Teamstuff::Client.new *ts_credentials
      end

      let(:client) { @client }

      it "has a valid user_profile" do
        expect(client.userinfo).to be_a Hash
        expect(client.userinfo).to be_a_ts_user_profile
      end

      it "has a context for the user/profile" do
        expect(client.context).to be_a Hash
      end

      it "can get the events schedule" do
        expect(client.get_events).to be_a Hash
      end

      it "can get a member profile" do
        expect(client.get_member).to be_a_ts_user_profile
      end

      it "can get all member profiles" do
        profiles = client.get_member_profiles
        expect(profiles).to include("members", "member_types", "teams", "club_memberships", "clubs")

        members = profiles['members'].values
        expect(members).to include(be_a_ts_user_profile)
      end

    end

  end
end

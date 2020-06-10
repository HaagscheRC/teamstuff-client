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
        expect(client.userinfo).to include("id", "email", "registered", "verified", "nickname", "name", "created_at")
      end

      it "has a context for the user/profile" do
        expect(client.context).to be_a Hash
      end

      it "can get the evets schedule" do
        expect(client.get_events).to be_a Hash
      end

    end

  end
end

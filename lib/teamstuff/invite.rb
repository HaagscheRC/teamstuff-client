module Teamstuff
  class Invitation < Hashie::Dash

    include Hashie::Extensions::IgnoreUndeclared
    include Hashie::Extensions::Dash::PredefinedValues

    property :member_type, required: true, values: %w(player parent coach manager coach_and_manager)
    property :email, required: true
    property :name
    property :child_name

  end
end

module Teamstuff
  class MemberShip < Hashie::Mash

    include Hashie::Extensions::Coercion
    coerce_key :member, Member

  end
end

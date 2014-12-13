module Authlogic
  # We need random number only numeric
  module Random
    extend self

    FRIENDLY_CHARS = ("0".."9").to_a

    def friendly_token
      newpass = ""
      1.upto(5) { |i| newpass << FRIENDLY_CHARS[rand(FRIENDLY_CHARS.size-1)] }
      newpass
    end
  end
end
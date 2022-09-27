module FixtureReplacement
  module RandomDataGenerators
    def random_string(length=10)
      chars = ("a".."z").to_a
      string = ""
      1.upto(length) { |i| string << chars[rand(chars.size-1)]}
      string
    end
  end
end

module FixtureReplacement
  module RandomDataGenerators
    def random_string(length=10)
      chars = ("a".."z").to_a
      string = ""
      1.upto(length) { |i| string << chars[rand(chars.size-1)]}
      string
    end

    def random_email(*args)
      require 'faker'
      Faker::Internet.email(*args)
    end

    def random_first_name
      require 'faker'
      Faker::Name.first_name
    end

    def random_last_name
      require 'faker'
      Faker::Name.last_name
    end

    def random_name
      require 'faker'
      Faker::Name.name
    end
  end
end

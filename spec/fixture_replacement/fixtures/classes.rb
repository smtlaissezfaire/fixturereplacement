unless defined?(User)
  class User < ActiveRecord::Base
    belongs_to :gender
  end

  class Member < ActiveRecord::Base; end

  class Post < ActiveRecord::Base
    has_many :comments
  end

  class Comment < ActiveRecord::Base
    belongs_to :post
  end

  class Player < ActiveRecord::Base
  end

  class Alien < ActiveRecord::Base
    belongs_to :gender
  end

  class Admin < ActiveRecord::Base
    attr_protected :admin_status
  end

  class Gender < ActiveRecord::Base; end
  class Actress < ActiveRecord::Base; end

  class Item < ActiveRecord::Base
    belongs_to :category
  end

  class Writing < Item; end

  class Category < ActiveRecord::Base
    has_many :items
  end

  class Subscriber < ActiveRecord::Base
    has_and_belongs_to_many :subscriptions
  end

  class Subscription < ActiveRecord::Base
    has_and_belongs_to_many :subscribers
  end

  class Event < ActiveRecord::Base
    has_one :schedule
  end

  class Schedule < ActiveRecord::Base
    belongs_to :event
  end

  class Foo; end
  class Bar; end

  class NoValidation < ActiveRecord::Base
  end

  class ValidateName < ActiveRecord::Base
    validates_presence_of :name
  end

  class ValidateNameTwo < ActiveRecord::Base
    validates_presence_of :name
  end

  class AddressWithValidCity < ActiveRecord::Base
    validates_presence_of :city
  end

  class AddressWithValidCityAndState < ActiveRecord::Base
    validates_presence_of :city
    validates_presence_of :state
  end
end

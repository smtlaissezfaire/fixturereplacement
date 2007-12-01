class User < ActiveRecord::Base
  belongs_to :gender  
  validates_presence_of :key
end

class Alien < ActiveRecord::Base
  belongs_to :gender
end

class Admin < ActiveRecord::Base
  attr_protected :admin_status
end

class Gender < ActiveRecord::Base; end
class Actress < ActiveRecord::Base; end

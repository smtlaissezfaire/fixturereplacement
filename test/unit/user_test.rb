require File.dirname(__FILE__) + '/../test_helper'

module ::FixtureReplacement
  
  attributes_for :gender do |g|
    g.sex = "male"
  end

  attributes_for :user do |u|
    u.username = scott
    u.key = "something"
    u.gender = default_gender
  end
  
private
  def scott
    "Scott Taylor"
  end
end


class UserTest < Test::Unit::TestCase
  
  def setup
    extend FixtureReplacement
  end
  
  def test_true_should_be_true
    assert_equal true, true
  end
  
  def test_be_able_to_create_with_create_user
    assert_equal create_user.class, User
  end
  
  def test_user_has_default_gender_with_create_user
    assert create_user.gender.kind_of?(Gender)
    assert_equal create_user.gender.sex, "male"
  end
  
  def test_user_has_default_gender_with_new_user
    assert new_user.gender.kind_of?(Gender)
    assert_equal new_user.gender.sex, "male"
  end  
  
  def test_create_user_should_have_user_key_something
    assert_equal create_user.key, "something"
  end
  
  def test_new_user_should_have_user_key_something
    assert_equal new_user.key, "something"
  end
  
  def test_testcase_should_not_raise_an_error_when_sending_new_user
    assert self.send(:new_user)
  end
end

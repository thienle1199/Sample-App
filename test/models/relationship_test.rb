require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @user = users(:thienle)
    @another_user = users(:iron)
    @relationship = @user.active_relationships.build(followed_id: @another_user.id)
  end

  test 'should be valid' do
    assert @relationship.valid?
  end

  test 'follower_id should be presence' do
    @relationship.follower_id = nil  
    assert_not @relationship.valid?
  end

  test 'followed_id should be presence' do
    @relationship.followed_id = nil  
    assert_not @relationship.valid?
  end
end

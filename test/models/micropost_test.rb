require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:thienle)
    @micropost = @user.microposts.build(content: 'Lorem ipsum')
  end

  test 'Should be valid' do
    assert @micropost.valid?
  end

  test 'user id should be presence' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content should be presence' do
    @micropost.content = ''
    assert_not @micropost.valid?
  end

  test 'content should not be longer than 250 characters' do
    @micropost.content = 'a' * 251
    assert_not @micropost.valid?
  end

  test 'order must be most recent first' do
    assert_equal microposts(:most_recent), Micropost.first
  end
end

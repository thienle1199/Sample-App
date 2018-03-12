require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:thienle)
  end

  test 'microposts interface' do
    log_in_as(@user)
    get root_path
    assert_select 'ul.pagination'
    assert_select 'input[type=file]'
    # Invalid submition
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    assert_select 'div#error_explanation'
    # Valid submition
    content = 'Valid submition'
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, 
                                                   picture: picture } }
    end
    assert assigns[:micropost].picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit another user show page
    get user_path(users(:iron))  
    assert_select 'a', text: 'delete', count: 0
  end

  test 'microposts sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with 0 micropost
    log_in_as(users(:lana))  
    get root_path
    assert_match "0 microposts", response.body
    users(:lana).microposts.create!(content: "Haleiluja")
    get root_path
    assert_match "1 micropost", response.body
  end 
end

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:thienle)
  	@other_user = users(:iron)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not log in" do 
  	get edit_user_path(@user)
  	assert_not flash.empty?
  	assert_redirected_to '/login'
  end

  test "should redirect update when not log in" do 
  	patch user_path(@user), params: {user: {name: @user.name,
  																	 email: @user.email}}
  	assert_not flash.empty?
  	assert_redirected_to '/login'
  end

  test "should redirect when edit another user page" do 
  	log_in_as(@user)
  	get edit_user_path (@other_user) 
  	assert flash.empty?
  	assert_redirected_to root_url
  end

  test "should redirect when update another user page" do 
  	log_in_as(@user)
  	patch user_path (@other_user), params: {user: {name: @user.name,
  																								 email: @user.email}} 
  	assert flash.empty?
  	assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do 
  	get users_url
  	assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
  	log_in_as(@other_user)
  	assert_not @other_user.admin 
  	patch user_path(@other_user), params: {user: {password: "password",
  																								password_confirmation: "password",
  																								admin: true}}
    assert_not @other_user.reload.admin?  
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "admin user should be able to delete other user" do 
  	log_in_as(@user)
  	assert_difference 'User.count', -1 do 
  		delete user_path(@other_user)
  	end
  	assert_redirected_to users_url
  end 

  test "index as non-admin" do 
  	log_in_as(@other_user) 
  	get users_path
  	assert_select 'a', text: 'delete', count: 0
  end
end
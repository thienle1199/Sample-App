require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(name: "Thienle", email: "thienle.luong@gmail.com",
											password: "123456", password_confirmation: "123456")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "name should be presence" do
		@user.name = " "
		assert_not @user.valid?
	end

	test "email should be presence" do
		@user.email = " "
		assert_not @user.valid?
	end

	test "name should not be too long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email should not be too long" do
		@user.email = "a" * 256
		assert_not @user.valid?
	end

	test "email validation should accept valid addresses" do
	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
											 first.last@foo.jp alice+bob@baz.vn]
	valid_addresses.each do |valid_address|
		@user.email = valid_address
		assert @user.valid?, "#{valid_address.inspect} should be valid"
		end
	end

	test "email validation should reject invalid addresses" do
		invalid_addresses = %w[user@eample,com user_at_foo.org 
				user.name@example.foo@baz_bar.com foo@bar+bar.com]
		invalid_addresses.each do |invalid_address|
			@user.email = invalid_address
			assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"		
		end 
	end

	test "email addresses should be unique" do
		duplicate_user = @user.dup
		@user.save
		assert_not duplicate_user.valid?
	end

	test "email addresses should be saved as lower-case" do
		mixed_case_email = "Foo@ExamPle.COm"
		@user.email = mixed_case_email
		@user.save
		assert_equal mixed_case_email.downcase, @user.reload.email
	end

	test "password should be present (nonblank)" do 
		@user.password = @user.password_confirmation = " " * 6
		assert_not @user.valid?
	end

	test "password should have a minimum length" do 
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end
end

require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:admin)
    @non_admin = users(:tartempion)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    nonadmin_user = User.find_by(admin: false)
    assert_select 'a[href=?]', user_path(nonadmin_user), text: nonadmin_user.name
    assert_select 'a[href=?]', user_path(nonadmin_user), text: 'Delete'
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "index only shows validated users" do
    log_in_as(@non_admin)
    inactiveuser = User.find_by(activated: false)
    get users_path
    assert_select 'a[href=?]', user_path(inactiveuser),
                   text: inactiveuser.name, count: 0
  end

  test "inactive user view redirects to root" do
    log_in_as(@admin)
    inactiveuser = User.find_by(activated: false)
    get user_path(inactiveuser)
    assert_redirected_to root_url
  end
end

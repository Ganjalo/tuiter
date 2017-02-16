require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:tartuffe)
    @admin = users(:admin)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Invalid submission
    post microposts_path, micropost: { content: "" }
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room together."
    picture = fixture_file_upload('test/fixtures/files/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    assert assigns(:micropost).picture?
    follow_redirect!
    assert_match content, response.body
    assert_select ".content > img"
    # Delete a post.
    assert_select 'a', 'Delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit a different user.
    get user_path(users(:archer))
    assert_select 'a', { text: 'Delete', count: 0 }
  end

  test "admins can see and delete all microposts" do
    log_in_as(@admin)
    get root_url
    assert_select ".content"
    assert_select "a[data-method=?]", "delete"
    first_micropost = @user.feed.first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
  end
end

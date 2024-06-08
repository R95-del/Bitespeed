require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  test "should get identify" do
    get contacts_identify_url
    assert_response :success
  end
end

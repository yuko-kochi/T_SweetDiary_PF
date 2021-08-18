require 'test_helper'

class CategorysControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get categorys_show_url
    assert_response :success
  end

end

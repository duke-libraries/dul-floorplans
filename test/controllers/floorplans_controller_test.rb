require 'test_helper'

class FloorplansControllerTest < ActionController::TestCase
  test "should get view" do
    get :view
    assert_response :success
  end

end

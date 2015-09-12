require 'test_helper'

class ApiControllerTest < ActionController::TestCase

  setup do
    @shortcut = shortcuts(:one)
  end

  test "show should redirect to uriginal url" do
  	get :show, target: @shortcut
  	assert_redirected_to @shortcut.url
  end

end
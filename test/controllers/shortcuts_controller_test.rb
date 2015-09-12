require 'test_helper'

class ShortcutsControllerTest < ActionController::TestCase
  setup do
    @shortcut = shortcuts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shortcuts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shortcut" do
    assert_difference('Shortcut.count') do
      post :create, shortcut: { target: '123abc', url: 'http://onetwothree.org' }
    end

    assert_redirected_to shortcut_path(assigns(:shortcut))
  end

  test "should assign target on create" do
    post :create, shortcut: { url: 'http://onetwothree.org' }
    assert_not_nil assigns(:shortcut).target
  end

  test "should show shortcut" do
    get :show, target: @shortcut
    assert_response :success
  end

  test "should 404 if target is not found" do
    assert_raise ActiveRecord::RecordNotFound do
      get :show, target: 'not_there'
    end
  end

  test "should show shortcut as json" do
    get :show, target: @shortcut.target, format: :json
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal @shortcut.url, json['url']
    assert_equal @shortcut.target, json['target']
  end

  test "should normalize target for show" do
    Shortcut.create(:url => 'http://test.com', :target => '4sq31c')
    get :show, target: '4sq3lc', format: :json
    assert_response :success
  end

  test "should get edit" do
    get :edit, target: @shortcut
    assert_response :success
  end

  test "should update shortcut" do
    patch :update, target: @shortcut, shortcut: { target: '123abc', url: 'http://onetwothree.org' }
    assert_redirected_to shortcut_path(assigns(:shortcut))
  end

  test "should destroy shortcut" do
    assert_difference('Shortcut.count', -1) do
      delete :destroy, target: @shortcut
    end

    assert_redirected_to shortcuts_path
  end
end

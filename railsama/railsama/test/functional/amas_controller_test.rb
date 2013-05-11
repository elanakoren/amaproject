require 'test_helper'

class AmasControllerTest < ActionController::TestCase
  setup do
    @ama = amas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:amas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ama" do
    assert_difference('Ama.count') do
      post :create, ama: { author: @ama.author, url: @ama.url }
    end

    assert_redirected_to ama_path(assigns(:ama))
  end

  test "should show ama" do
    get :show, id: @ama
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ama
    assert_response :success
  end

  test "should update ama" do
    put :update, id: @ama, ama: { author: @ama.author, url: @ama.url }
    assert_redirected_to ama_path(assigns(:ama))
  end

  test "should destroy ama" do
    assert_difference('Ama.count', -1) do
      delete :destroy, id: @ama
    end

    assert_redirected_to amas_path
  end
end

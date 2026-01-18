require "test_helper"

class FavorisControllerTest < ActionDispatch::IntegrationTest
  def setup
    @favori = favoris(:favori_one)
    @user = users(:regular_user)
    @offre = offres(:offre_one)
  end

  # Index action
  test "should redirect index to sign in when not authenticated" do
    get favoris_url
    assert_redirected_to new_user_session_url
  end

  test "should get index when authenticated" do
    sign_in @user
    get favoris_url
    assert_response :success
  end

  test "index should display user favoris" do
    sign_in @user
    get favoris_url
    assert_match @favori.offre.titre, response.body
  end

  # Create action
  test "should not create favori without authentication" do
    assert_no_difference('Favori.count') do
      post favoris_url, params: { offre_id: offres(:offre_past).id }
    end
    assert_redirected_to new_user_session_url
  end

  test "should create favori when authenticated" do
    sign_in users(:admin)  # admin doesn't have favoris yet
    assert_difference('Favori.count', 1) do
      post favoris_url, params: { offre_id: offres(:offre_past).id }
    end
  end

  test "should not create duplicate favori" do
    sign_in @user
    # User already has favori for offre_one
    assert_no_difference('Favori.count') do
      post favoris_url, params: { offre_id: @offre.id }
    end
  end

  # Destroy action
  test "should not destroy favori without authentication" do
    assert_no_difference('Favori.count') do
      delete favori_url(@favori)
    end
    assert_redirected_to new_user_session_url
  end

  test "should destroy favori when owner" do
    sign_in @user
    assert_difference('Favori.count', -1) do
      delete favori_url(@favori)
    end
  end

  test "should not destroy favori when not owner" do
    sign_in users(:other_user)
    assert_no_difference('Favori.count') do
      delete favori_url(@favori)
    end
  end

  # Toggle action (if you have one)
  test "should toggle favori - create when not exists" do
    sign_in users(:admin)
    offre = offres(:offre_past)
    assert_difference('Favori.count', 1) do
      post favoris_url, params: { offre_id: offre.id }
    end
  end

  test "should toggle favori - destroy when exists" do
    sign_in @user
    assert_difference('Favori.count', -1) do
      delete favori_url(@favori)
    end
  end
end

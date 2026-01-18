require "test_helper"

class OffresControllerTest < ActionDispatch::IntegrationTest
  def setup
    @offre = offres(:offre_one)
    @user = users(:regular_user)
    @intervenant = users(:intervenant_user)
    @admin = users(:admin)
  end

  # Index action
  test "should get index" do
    get offres_url
    assert_response :success
    assert_not_nil assigns(:offres)
  end

  test "index should display all offres" do
    get offres_url
    assert_select "h1", /Programme/i
  end

  # Show action
  test "should show offre" do
    get offre_url(@offre)
    assert_response :success
  end

  test "show should display offre details" do
    get offre_url(@offre)
    assert_select "h1", @offre.titre
  end

  test "show should display fournisseur information" do
    get offre_url(@offre)
    assert_match @offre.fournisseur.name, response.body
  end

  # New action (requires authentication)
  test "should redirect to sign in when not authenticated" do
    get new_offre_url
    assert_redirected_to new_user_session_url
  end

  test "should get new when authenticated as intervenant" do
    sign_in @intervenant
    get new_offre_url
    assert_response :success
  end

  # Create action
  test "should not create offre without authentication" do
    assert_no_difference('Offre.count') do
      post offres_url, params: { offre: {
        titre: "New Offre",
        descriptif: "Description",
        place: 10,
        date_prevue: 30.days.from_now
      }}
    end
    assert_redirected_to new_user_session_url
  end

  test "should create offre when authenticated as intervenant" do
    sign_in @intervenant
    assert_difference('Offre.count', 1) do
      post offres_url, params: { offre: {
        titre: "New Workshop",
        sous_titre: "Subtitle",
        descriptif: "Great workshop description",
        categories: "Test",
        duree: "1h",
        place: 15,
        date_prevue: 30.days.from_now,
        salle: "Salle A"
      }}
    end
    assert_redirected_to dashboard_url
  end

  test "should not create offre with invalid params" do
    sign_in @intervenant
    assert_no_difference('Offre.count') do
      post offres_url, params: { offre: {
        titre: "",  # Invalid - titre required
        descriptif: "Description"
      }}
    end
    assert_response :unprocessable_entity
  end

  # Edit action
  test "should redirect edit to sign in when not authenticated" do
    get edit_offre_url(@offre)
    assert_redirected_to new_user_session_url
  end

  test "should get edit when authenticated as owner" do
    sign_in @intervenant
    get edit_offre_url(@offre)
    assert_response :success
  end

  test "should redirect edit when not owner" do
    sign_in @user
    get edit_offre_url(@offre)
    assert_redirected_to dashboard_url
  end

  # Update action
  test "should not update offre without authentication" do
    patch offre_url(@offre), params: { offre: { titre: "Updated" }}
    assert_redirected_to new_user_session_url
  end

  test "should update offre when authenticated as owner" do
    sign_in @intervenant
    patch offre_url(@offre), params: { offre: {
      titre: "Updated Title"
    }}
    assert_redirected_to offre_url(@offre)
    @offre.reload
    assert_equal "Updated Title", @offre.titre
  end

  test "should not update offre when not owner" do
    sign_in @user
    patch offre_url(@offre), params: { offre: { titre: "Updated" }}
    assert_redirected_to dashboard_url
  end

  # Destroy action
  test "should not destroy offre without authentication" do
    assert_no_difference('Offre.count') do
      delete offre_url(@offre)
    end
    assert_redirected_to new_user_session_url
  end

  test "should destroy offre when authenticated as owner" do
    sign_in @intervenant
    assert_difference('Offre.count', -1) do
      delete offre_url(@offre)
    end
    assert_redirected_to dashboard_url
  end

  test "should not destroy offre when not owner" do
    sign_in @user
    assert_no_difference('Offre.count') do
      delete offre_url(@offre)
    end
    assert_redirected_to dashboard_url
  end

  # Admin can do everything
  test "admin should be able to edit any offre" do
    sign_in @admin
    get edit_offre_url(@offre)
    assert_response :success
  end

  test "admin should be able to update any offre" do
    sign_in @admin
    patch offre_url(@offre), params: { offre: { titre: "Admin Updated" }}
    assert_redirected_to offre_url(@offre)
  end

  test "admin should be able to destroy any offre" do
    sign_in @admin
    assert_difference('Offre.count', -1) do
      delete offre_url(@offre)
    end
  end
end

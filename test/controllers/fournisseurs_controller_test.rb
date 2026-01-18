require "test_helper"

class FournisseursControllerTest < ActionDispatch::IntegrationTest
  def setup
    @fournisseur = fournisseurs(:fournisseur_one)
    @user = users(:regular_user)
    @intervenant = users(:intervenant_user)
    @admin = users(:admin)
  end

  # Index action
  test "should get index" do
    get fournisseurs_url
    assert_response :success
  end

  test "index should display all animateurs" do
    get fournisseurs_url
    assert_select "h1", /Animateurs/i
  end

  test "index should include primary animateurs" do
    get fournisseurs_url
    assert_match @fournisseur.name, response.body
  end

  test "index should include secondary animateurs" do
    get fournisseurs_url
    # fournisseur_one is secondary on offre_two
    assert_includes assigns(:fournisseurs), @fournisseur
  end

  test "index should exclude fournisseurs without name" do
    fournisseur = Fournisseur.create!(bio: "Test")
    get fournisseurs_url
    assert_not_includes assigns(:fournisseurs), fournisseur
  end

  # Show action
  test "should show fournisseur" do
    get fournisseur_url(@fournisseur)
    assert_response :success
  end

  test "show should display fournisseur details" do
    get fournisseur_url(@fournisseur)
    assert_select "h1", @fournisseur.name
    assert_match @fournisseur.bio, response.body
  end

  test "show should display all offres where fournisseur is involved" do
    get fournisseur_url(@fournisseur)
    # Should include primary offres
    assert_match offres(:offre_one).titre, response.body
    # Should include secondary offres
    assert_match offres(:offre_two).titre, response.body
  end

  # New action
  test "should redirect new to sign in when not authenticated" do
    get new_fournisseur_url
    assert_redirected_to new_user_session_url
  end

  test "should get new when authenticated and not intervenant" do
    sign_in @user
    get new_fournisseur_url
    assert_response :success
  end

  test "should redirect if already intervenant" do
    sign_in @intervenant
    get new_fournisseur_url
    assert_redirected_to dashboard_url
    assert_equal "Vous êtes déjà intervenant.", flash[:alert]
  end

  # Create action
  test "should not create fournisseur without authentication" do
    assert_no_difference('Fournisseur.count') do
      post fournisseurs_url, params: { fournisseur: {
        name: "New Fournisseur",
        bio: "Bio"
      }}
    end
    assert_redirected_to new_user_session_url
  end

  test "should create fournisseur when authenticated" do
    sign_in @user
    assert_difference('Fournisseur.count', 1) do
      post fournisseurs_url, params: { fournisseur: {
        name: "New Fournisseur",
        bio: "Great bio",
        instagram: "https://instagram.com/test",
        linkedin: "https://linkedin.com/in/test"
      }}
    end
    assert_redirected_to dashboard_url
  end

  # Edit action
  test "should redirect edit to sign in when not authenticated" do
    get edit_fournisseur_url(@fournisseur)
    assert_redirected_to new_user_session_url
  end

  test "should get edit when owner" do
    sign_in @intervenant
    get edit_fournisseur_url(@fournisseur)
    assert_response :success
  end

  test "should redirect edit when not owner" do
    sign_in @user
    get edit_fournisseur_url(@fournisseur)
    assert_redirected_to dashboard_url
  end

  test "admin should be able to edit any fournisseur" do
    sign_in @admin
    get edit_fournisseur_url(@fournisseur)
    assert_response :success
  end

  # Update action
  test "should update fournisseur when owner" do
    sign_in @intervenant
    patch fournisseur_url(@fournisseur), params: { fournisseur: {
      bio: "Updated bio"
    }}
    assert_redirected_to edit_fournisseur_url(@fournisseur)
    @fournisseur.reload
    assert_equal "Updated bio", @fournisseur.bio
  end

  test "should not update fournisseur when not owner" do
    sign_in @user
    original_bio = @fournisseur.bio
    patch fournisseur_url(@fournisseur), params: { fournisseur: {
      bio: "Hacked bio"
    }}
    assert_redirected_to dashboard_url
    @fournisseur.reload
    assert_equal original_bio, @fournisseur.bio
  end
end

require "application_system_test_case"

class OffresTest < ApplicationSystemTestCase
  def setup
    @user = users(:regular_user)
    @intervenant = users(:intervenant_user)
    @offre = offres(:offre_one)
  end

  test "visiting the index" do
    visit offres_url
    assert_selector "h1", text: /Programme/i
  end

  test "viewing an offre" do
    visit offre_url(@offre)
    assert_selector "h1", text: @offre.titre
    assert_text @offre.descriptif
    assert_text @offre.fournisseur.name
  end

  test "viewing all animateurs on offre page" do
    offre = offres(:offre_two)
    visit offre_url(offre)
    
    # Should display primary fournisseur
    assert_text offre.fournisseur.name
    
    # Should display secondary fournisseur
    assert_text offre.secondary_fournisseur.name
  end

  test "user can like an offre" do
    sign_in @user
    visit offre_url(offres(:offre_past))
    
    click_on "J'aime"
    assert_text "Liked!"
  end

  test "user can unlike an offre" do
    sign_in @user
    visit offre_url(@offre)
    
    # User already liked this offre
    click_on "Dislike" # or whatever button text you have
    assert_text "Unliked!"
  end

  test "user can book an offre" do
    sign_in users(:admin) # admin has no bookings yet
    offre = offres(:offre_two)
    visit offre_url(offre)
    
    click_on "Réserver"
    assert_text "Réservation confirmée"
  end

  test "intervenant can create offre" do
    sign_in @intervenant
    visit new_offre_url
    
    fill_in "Titre", with: "New Workshop"
    fill_in "Descriptif", with: "Great workshop description"
    fill_in "Place", with: "20"
    fill_in "Durée", with: "1h30"
    fill_in "Salle", with: "Salle A"
    
    click_on "Créer"
    assert_text "Animation créée avec succès"
  end

  test "intervenant can edit their offre" do
    sign_in @intervenant
    visit edit_offre_url(@offre)
    
    fill_in "Titre", with: "Updated Title"
    click_on "Mettre à jour"
    
    assert_text "Animation mise à jour"
    assert_text "Updated Title"
  end

  test "regular user cannot create offre" do
    sign_in @user
    visit new_offre_url
    
    assert_text "Vous devez être intervenant"
  end

  test "guest cannot book offre" do
    visit offre_url(@offre)
    click_on "Réserver"
    
    assert_current_path new_user_session_path
  end
end

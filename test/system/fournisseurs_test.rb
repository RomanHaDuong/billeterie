require "application_system_test_case"

class FournisseursTest < ApplicationSystemTestCase
  def setup
    @fournisseur = fournisseurs(:fournisseur_one)
    @user = users(:regular_user)
    @intervenant = users(:intervenant_user)
  end

  test "visiting the index" do
    visit fournisseurs_url
    assert_selector "h1", text: /Animateurs/i
  end

  test "index displays all types of animateurs" do
    visit fournisseurs_url
    
    # Should display primary animateurs
    assert_text fournisseurs(:fournisseur_one).name
    
    # Should display secondary animateurs (co-animateurs)
    assert_text fournisseurs(:fournisseur_two).name
  end

  test "viewing a fournisseur profile" do
    visit fournisseur_url(@fournisseur)
    assert_selector "h1", text: @fournisseur.name
    assert_text @fournisseur.bio
  end

  test "fournisseur profile shows all their offres" do
    visit fournisseur_url(@fournisseur)
    
    # Should show primary offres
    assert_text offres(:offre_one).titre
    
    # Should show secondary offres (where they are co-animateur)
    assert_text offres(:offre_two).titre
  end

  test "user can become intervenant" do
    sign_in @user
    visit new_fournisseur_url
    
    fill_in "Nom", with: "New Intervenant"
    fill_in "Bio", with: "Experienced coach and facilitator"
    fill_in "Instagram", with: "https://instagram.com/new"
    fill_in "LinkedIn", with: "https://linkedin.com/in/new"
    
    click_on "Devenir intervenant"
    assert_text "Félicitations"
  end

  test "intervenant can edit their profile" do
    sign_in @intervenant
    visit edit_fournisseur_url(@fournisseur)
    
    fill_in "Bio", with: "Updated bio text"
    click_on "Mettre à jour"
    
    assert_text "Profil mis à jour"
    assert_text "Updated bio text"
  end

  test "user cannot edit another fournisseur profile" do
    sign_in @user
    visit edit_fournisseur_url(@fournisseur)
    
    assert_text "Vous n'avez pas la permission"
  end
end

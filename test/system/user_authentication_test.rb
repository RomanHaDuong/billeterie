require "application_system_test_case"

class UserAuthenticationTest < ApplicationSystemTestCase
  def setup
    @user = users(:regular_user)
  end

  test "user can sign up" do
    visit new_user_registration_url
    
    fill_in "Email", with: "newuser@example.com"
    fill_in "Mot de passe", with: "password123"
    fill_in "Confirmation", with: "password123"
    fill_in "Nom", with: "New User"
    
    click_on "S'inscrire"
    assert_text "Bienvenue"
  end

  test "user can sign in" do
    visit new_user_session_url
    
    fill_in "Email", with: @user.email
    fill_in "Mot de passe", with: "password123"
    
    click_on "Se connecter"
    assert_text "Connecté"
  end

  test "user can sign out" do
    sign_in @user
    visit root_url
    
    click_on "Déconnexion"
    assert_text "Déconnecté"
  end

  test "user cannot access protected pages" do
    visit dashboard_url
    assert_current_path new_user_session_path
  end

  test "user sees personalized content when signed in" do
    sign_in @user
    visit root_url
    
    assert_text @user.name
  end
end

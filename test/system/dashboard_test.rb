require "application_system_test_case"

class DashboardTest < ApplicationSystemTestCase
  def setup
    @user = users(:regular_user)
    @intervenant = users(:intervenant_user)
    @admin = users(:admin)
  end

  test "guest is redirected to sign in" do
    visit dashboard_url
    assert_current_path new_user_session_path
  end

  test "regular user sees their dashboard" do
    sign_in @user
    visit dashboard_url
    
    assert_selector "h1", text: /Dashboard/i
    assert_text @user.name
  end

  test "user dashboard shows bookings" do
    sign_in @user
    visit dashboard_url
    
    # User has bookings from fixtures
    assert_text "Mes réservations"
    assert_text bookings(:booking_one).offre.titre
  end

  test "user dashboard shows favoris" do
    sign_in @user
    visit dashboard_url
    
    assert_text "Mes likes"
    assert_text favoris(:favori_one).offre.titre
  end

  test "intervenant dashboard shows their offres" do
    sign_in @intervenant
    visit dashboard_url
    
    assert_text "Les ateliers que j'anime"
    assert_text offres(:offre_one).titre
  end

  test "intervenant can create new offre from dashboard" do
    sign_in @intervenant
    visit dashboard_url
    
    click_on "Créer un atelier"
    assert_current_path new_offre_path
  end

  test "admin dashboard shows admin controls" do
    sign_in @admin
    visit dashboard_url
    
    # Admin has special controls or links
    assert_text /Admin/i
  end
end

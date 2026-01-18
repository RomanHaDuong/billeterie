require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:regular_user)
    @admin = users(:admin)
    @intervenant = users(:intervenant_user)
  end

  # Validations
  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should require email" do
    @user.email = nil
    assert_not @user.valid?
  end

  test "should require unique email" do
    duplicate_user = User.new(
      email: @user.email,
      password: "password123"
    )
    assert_not duplicate_user.valid?
  end

  # Associations
  test "should have one fournisseur" do
    assert_respond_to @user, :fournisseur
  end

  test "should have many bookings" do
    assert_respond_to @user, :bookings
  end

  test "should have many favoris" do
    assert_respond_to @user, :favoris
  end

  # Admin methods
  test "admin? should return true for admin user" do
    assert @admin.admin?
  end

  test "admin? should return false for regular user" do
    assert_not @user.admin?
  end

  # Intervenant methods
  test "intervenant? should return true for user with fournisseur" do
    assert @intervenant.intervenant?
  end

  test "intervenant? should return false for user without fournisseur" do
    assert_not @user.intervenant?
  end

  # Bookings relationship
  test "should have bookings" do
    bookings = @user.bookings
    assert_includes bookings, bookings(:booking_one)
  end

  # Favoris relationship
  test "should have favoris" do
    favoris = @user.favoris
    assert_includes favoris, favoris(:favori_one)
  end
end

require "test_helper"

class FavoriTest < ActiveSupport::TestCase
  def setup
    @favori = favoris(:favori_one)
    @user = users(:regular_user)
    @offre = offres(:offre_one)
  end

  # Associations
  test "should belong to user" do
    assert_respond_to @favori, :user
    assert_instance_of User, @favori.user
  end

  test "should belong to offre" do
    assert_respond_to @favori, :offre
    assert_instance_of Offre, @favori.offre
  end

  # Validations
  test "should be valid with valid attributes" do
    assert @favori.valid?
  end

  # Creation
  test "should create favori" do
    assert_difference('Favori.count', 1) do
      Favori.create!(
        user: users(:admin),
        offre: offres(:offre_two)
      )
    end
  end

  # Deletion
  test "should delete favori" do
    assert_difference('Favori.count', -1) do
      @favori.destroy
    end
  end

  # Uniqueness
  test "user should be able to like multiple offres" do
    assert_equal 2, @user.favoris.count
  end

  test "offre should be liked by multiple users" do
    offre = offres(:offre_one)
    assert_operator offre.favoris.count, :>=, 1
  end
end

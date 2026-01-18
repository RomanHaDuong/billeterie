require "test_helper"

class FournisseurTest < ActiveSupport::TestCase
  def setup
    @fournisseur = fournisseurs(:fournisseur_one)
  end

  # Associations
  test "should belong to user optionally" do
    assert_respond_to @fournisseur, :user
  end

  test "should be valid without user" do
    fournisseur = Fournisseur.new(
      name: "Test Fournisseur",
      bio: "Test bio"
    )
    assert fournisseur.valid?
  end

  test "should have many offres" do
    assert_respond_to @fournisseur, :offres
  end

  test "should have many secondary_offres" do
    assert_respond_to @fournisseur, :secondary_offres
  end

  test "should have many additional_offres" do
    assert_respond_to @fournisseur, :additional_offres
  end

  # Attributes
  test "should have name" do
    assert_equal "Jean Dupont", @fournisseur.name
  end

  test "should have bio" do
    assert_not_nil @fournisseur.bio
  end

  test "should have social media links" do
    assert_not_nil @fournisseur.instagram
    assert_not_nil @fournisseur.linkedin
  end

  # Offres associations
  test "should return all offres where fournisseur is primary" do
    offres = @fournisseur.offres
    assert_includes offres, offres(:offre_one)
  end

  test "should return secondary_offres where fournisseur is co-animateur" do
    secondary_offres = fournisseurs(:fournisseur_one).secondary_offres
    assert_includes secondary_offres, offres(:offre_two)
  end
end

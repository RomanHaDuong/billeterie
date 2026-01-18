require "test_helper"

class OffreTest < ActiveSupport::TestCase
  def setup
    @offre = offres(:offre_one)
    @fournisseur = fournisseurs(:fournisseur_one)
  end

  # Validations
  test "should be valid with valid attributes" do
    assert @offre.valid?
  end

  test "should require titre" do
    @offre.titre = nil
    assert_not @offre.valid?
    assert_includes @offre.errors[:titre], "can't be blank"
  end

  test "should require descriptif" do
    @offre.descriptif = nil
    assert_not @offre.valid?
    assert_includes @offre.errors[:descriptif], "can't be blank"
  end

  test "should require place" do
    @offre.place = nil
    assert_not @offre.valid?
    assert_includes @offre.errors[:place], "can't be blank"
  end

  test "should require place to be greater than 0" do
    @offre.place = 0
    assert_not @offre.valid?
    assert_includes @offre.errors[:place], "must be greater than 0"

    @offre.place = -1
    assert_not @offre.valid?
  end

  test "should require date_prevue" do
    @offre.date_prevue = nil
    assert_not @offre.valid?
    assert_includes @offre.errors[:date_prevue], "can't be blank"
  end

  # Associations
  test "should belong to fournisseur" do
    assert_respond_to @offre, :fournisseur
    assert_instance_of Fournisseur, @offre.fournisseur
  end

  test "should have optional secondary_fournisseur" do
    offre = offres(:offre_two)
    assert_respond_to offre, :secondary_fournisseur
    assert_instance_of Fournisseur, offre.secondary_fournisseur
  end

  test "should have many additional_fournisseurs" do
    assert_respond_to @offre, :additional_fournisseurs
  end

  test "should have many favoris" do
    assert_respond_to @offre, :favoris
  end

  test "should have many bookings" do
    assert_respond_to @offre, :bookings
  end

  test "should destroy dependent bookings when destroyed" do
    offre = offres(:offre_one)
    assert_difference('Booking.count', -2) do
      offre.destroy
    end
  end

  # Available spots methods
  test "available_spots should return remaining spots" do
    offre = offres(:offre_one)
    # offre_one has 15 places and 2 bookings
    assert_equal 13, offre.available_spots
  end

  test "available_spots should return nil if place is nil" do
    @offre.place = nil
    assert_nil @offre.available_spots
  end

  test "spots_available? should return true when spots available" do
    assert @offre.spots_available?
  end

  test "spots_available? should return false when full" do
    offre = offres(:offre_full)
    assert_not offre.spots_available?
  end

  test "full? should return true when no spots available" do
    offre = offres(:offre_full)
    assert offre.full?
  end

  test "full? should return false when spots available" do
    assert_not @offre.full?
  end

  # User registration methods
  test "user_registered? should return true for registered user" do
    user = users(:regular_user)
    assert @offre.user_registered?(user)
  end

  test "user_registered? should return false for non-registered user" do
    user = users(:admin)
    assert_not @offre.user_registered?(user)
  end

  test "user_registered? should return false for nil user" do
    assert_not @offre.user_registered?(nil)
  end

  # All animateurs method
  test "all_animateurs should include primary fournisseur" do
    animateurs = @offre.all_animateurs
    assert_includes animateurs, @offre.fournisseur
  end

  test "all_animateurs should include secondary_fournisseur if present" do
    offre = offres(:offre_two)
    animateurs = offre.all_animateurs
    assert_includes animateurs, offre.secondary_fournisseur
  end

  test "all_animateurs should include additional_fournisseurs" do
    offre = Offre.new(
      titre: "Test",
      descriptif: "Test description",
      place: 10,
      date_prevue: 30.days.from_now,
      fournisseur: @fournisseur
    )
    offre.save!
    
    additional = fournisseurs(:fournisseur_two)
    offre.additional_fournisseurs << additional
    
    animateurs = offre.all_animateurs
    assert_includes animateurs, additional
  end

  # Additional fournisseur IDs setter
  test "additional_fournisseur_ids= should set additional fournisseurs" do
    offre = Offre.create!(
      titre: "Test Workshop",
      descriptif: "Test description",
      place: 10,
      date_prevue: 30.days.from_now,
      fournisseur: @fournisseur
    )
    
    fournisseur_ids = [fournisseurs(:fournisseur_two).id, fournisseurs(:fournisseur_three).id]
    offre.additional_fournisseur_ids = fournisseur_ids
    offre.save!
    
    assert_equal 2, offre.additional_fournisseurs.count
    assert_includes offre.additional_fournisseurs, fournisseurs(:fournisseur_two)
    assert_includes offre.additional_fournisseurs, fournisseurs(:fournisseur_three)
  end

  test "additional_fournisseur_ids= should reject blank values" do
    offre = Offre.create!(
      titre: "Test Workshop",
      descriptif: "Test description",
      place: 10,
      date_prevue: 30.days.from_now,
      fournisseur: @fournisseur
    )
    
    offre.additional_fournisseur_ids = ["", fournisseurs(:fournisseur_two).id, ""]
    offre.save!
    
    assert_equal 1, offre.additional_fournisseurs.count
  end

  # No maximum animateurs limit anymore
  test "should allow unlimited co-animateurs" do
    offre = Offre.new(
      titre: "Test",
      descriptif: "Test description",
      place: 10,
      date_prevue: 30.days.from_now,
      fournisseur: @fournisseur,
      secondary_fournisseur: fournisseurs(:fournisseur_two)
    )
    
    # Add 10 additional co-animateurs (way more than old limit of 5)
    10.times do |i|
      fournisseur = Fournisseur.create!(
        name: "Fournisseur #{i}",
        bio: "Bio #{i}"
      )
      offre.additional_fournisseurs << fournisseur
    end
    
    assert offre.valid?, "Should allow unlimited co-animateurs"
  end
end

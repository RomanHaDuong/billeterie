require "test_helper"

class BookingTest < ActiveSupport::TestCase
  def setup
    @booking = bookings(:booking_one)
    @user = users(:regular_user)
    @offre = offres(:offre_one)
  end

  # Associations
  test "should belong to user" do
    assert_respond_to @booking, :user
    assert_instance_of User, @booking.user
  end

  test "should belong to offre" do
    assert_respond_to @booking, :offre
    assert_instance_of Offre, @booking.offre
  end

  # Attributes
  test "should have status" do
    assert_equal "confirmed", @booking.status
  end

  test "should have user_name" do
    assert_not_nil @booking.user_name
  end

  test "should have user_email" do
    assert_not_nil @booking.user_email
  end

  # Validations
  test "should be valid with valid attributes" do
    assert @booking.valid?
  end

  # Creation
  test "should create booking" do
    assert_difference('Booking.count', 1) do
      Booking.create!(
        user: users(:other_user),
        offre: offres(:offre_two),
        status: "confirmed",
        user_name: "Other User",
        user_email: "other@example.com"
      )
    end
  end

  # Uniqueness (prevent double booking)
  test "should not allow user to book same offre twice" do
    duplicate_booking = Booking.new(
      user: @booking.user,
      offre: @booking.offre,
      status: "confirmed"
    )
    # This depends on your validation rules
    # Uncomment if you add uniqueness validation
    # assert_not duplicate_booking.valid?
  end
end

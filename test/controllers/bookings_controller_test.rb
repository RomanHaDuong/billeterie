require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @booking = bookings(:booking_one)
    @user = users(:regular_user)
    @offre = offres(:offre_one)
    @offre_full = offres(:offre_full)
  end

  # Index action
  test "should redirect index to sign in when not authenticated" do
    get bookings_url
    assert_redirected_to new_user_session_url
  end

  test "should get index when authenticated" do
    sign_in @user
    get bookings_url
    assert_response :success
  end

  test "index should display user bookings" do
    sign_in @user
    get bookings_url
    assert_match @booking.offre.titre, response.body
  end

  # Show action
  test "should redirect show to sign in when not authenticated" do
    get booking_url(@booking)
    assert_redirected_to new_user_session_url
  end

  test "should show booking when owner" do
    sign_in @user
    get booking_url(@booking)
    assert_response :success
  end

  test "should redirect show when not owner" do
    sign_in users(:other_user)
    get booking_url(@booking)
    assert_redirected_to bookings_url
  end

  # Create action
  test "should not create booking without authentication" do
    assert_no_difference('Booking.count') do
      post bookings_url, params: { offre_id: @offre.id }
    end
    assert_redirected_to new_user_session_url
  end

  test "should create booking when authenticated" do
    sign_in users(:admin)  # admin doesn't have bookings yet
    offre = offres(:offre_two)
    assert_difference('Booking.count', 1) do
      post bookings_url, params: { offre_id: offre.id }
    end
    assert_redirected_to booking_url(Booking.last)
  end

  test "should not create booking if already registered" do
    sign_in @user
    assert_no_difference('Booking.count') do
      post bookings_url, params: { offre_id: @offre.id }
    end
    # Already booked
  end

  test "should not create booking if offre is full" do
    sign_in users(:admin)
    assert_no_difference('Booking.count') do
      post bookings_url, params: { offre_id: @offre_full.id }
    end
  end

  # Destroy action
  test "should not destroy booking without authentication" do
    assert_no_difference('Booking.count') do
      delete booking_url(@booking)
    end
    assert_redirected_to new_user_session_url
  end

  test "should destroy booking when owner" do
    sign_in @user
    assert_difference('Booking.count', -1) do
      delete booking_url(@booking)
    end
    assert_redirected_to bookings_url
  end

  test "should not destroy booking when not owner" do
    sign_in users(:other_user)
    assert_no_difference('Booking.count') do
      delete booking_url(@booking)
    end
  end
end

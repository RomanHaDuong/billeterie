# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

10.times do
  user = User.create(
    email: Faker::Internet.email,
    password: "password"
  )

  fournisseur= Fournisseur.create(
    bio: Faker::Lorem.paragraph,
    user_id: user.id,
    name: Faker::Name.name
  )

  offre = Offre.create(
    price: Faker::Number.decimal(l_digits: 2),
    fournisseur_id: fournisseur.id
  )

  booking = Booking.create(
    user_id: 1,
    offre_id: offre.id,
    status: "pending"
  )
end

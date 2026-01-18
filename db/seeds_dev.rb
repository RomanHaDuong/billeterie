# Development seed file for local environment
puts "🌱 Starting development seed..."

# Clean existing data
puts "Cleaning existing data..."
Booking.destroy_all
Favori.destroy_all
Offre.destroy_all
Fournisseur.destroy_all
User.destroy_all

# Create admin user
puts "Creating admin user..."
admin = User.create!(
  email: "admin@example.com",
  password: "password123",
  password_confirmation: "password123",
  name: "Admin User",
  admin: true
)
puts "✓ Admin created: #{admin.email}"

# Create regular users
puts "Creating regular users..."
users = []
5.times do |i|
  user = User.create!(
    email: "user#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123",
    name: "User #{i+1}"
  )
  users << user
end
puts "✓ Created #{users.count} regular users"

# Create fournisseurs (animateurs)
puts "Creating fournisseurs..."
fournisseurs = []

# Create user-linked fournisseurs
3.times do |i|
  user = User.create!(
    email: "animateur#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123",
    name: "Animateur #{i+1}"
  )
  
  fournisseur = Fournisseur.create!(
    user: user,
    name: "Animateur #{i+1}",
    bio: "Passionné par le développement personnel et le partage de connaissances. #{i+1} ans d'expérience dans l'animation d'ateliers.",
    instagram: "https://instagram.com/animateur#{i+1}",
    linkedin: "https://linkedin.com/in/animateur#{i+1}",
    offinity: "https://offinity.com/animateur#{i+1}"
  )
  fournisseurs << fournisseur
end

# Create standalone fournisseurs (without user accounts)
2.times do |i|
  fournisseur = Fournisseur.create!(
    name: "Expert #{i+1}",
    bio: "Expert reconnu dans son domaine. Intervient régulièrement lors d'événements et conférences.",
    instagram: "https://instagram.com/expert#{i+1}",
    linkedin: "https://linkedin.com/in/expert#{i+1}"
  )
  fournisseurs << fournisseur
end

puts "✓ Created #{fournisseurs.count} fournisseurs"

# Create offres with various animateur configurations
puts "Creating offres..."

categories_list = [
  "Développement personnel",
  "Art & Créativité",
  "Sport & Bien-être",
  "Entrepreneuriat",
  "Technologie",
  "Cuisine",
  "Musique",
  "Danse"
]

salles_list = ["Salle A", "Salle B", "Salle C", "Grande Salle", "Salon"]

offres_data = [
  {
    titre: "Introduction au yoga",
    descriptif: "Découvrez les bases du yoga à travers une pratique douce et accessible à tous. Nous explorerons différentes postures (asanas) et techniques de respiration.",
    categories: "Sport & Bien-être",
    duree: "1h30",
    place: 15
  },
  {
    titre: "Atelier de cuisine végétarienne",
    descriptif: "Apprenez à préparer des plats végétariens savoureux et équilibrés. Recettes simples et délicieuses pour tous les jours.",
    categories: "Cuisine",
    duree: "2h",
    place: 12
  },
  {
    titre: "Méditation pleine conscience",
    descriptif: "Une introduction à la méditation de pleine conscience pour réduire le stress et améliorer votre bien-être au quotidien.",
    categories: "Développement personnel",
    duree: "1h",
    place: 20
  },
  {
    titre: "Initiation à la guitare",
    descriptif: "Premiers pas avec la guitare : accords de base, rythmes simples et premières chansons. Guitare fournie ou apportez la vôtre.",
    categories: "Musique",
    duree: "1h30",
    place: 10
  },
  {
    titre: "Atelier d'écriture créative",
    descriptif: "Libérez votre créativité à travers différents exercices d'écriture. Tous niveaux bienvenus.",
    categories: "Art & Créativité",
    duree: "2h",
    place: 15
  },
  {
    titre: "Pitch ton projet",
    descriptif: "Apprenez à pitcher votre projet de manière convaincante. Exercices pratiques et feedbacks personnalisés.",
    categories: "Entrepreneuriat",
    duree: "1h30",
    place: 20
  },
  {
    titre: "Danse contemporaine",
    descriptif: "Exploration du mouvement et de l'expression corporelle à travers la danse contemporaine. Aucune expérience requise.",
    categories: "Danse",
    duree: "1h30",
    place: 15
  },
  {
    titre: "Introduction à Python",
    descriptif: "Premiers pas en programmation avec Python. Concepts de base et exercices pratiques pour débutants.",
    categories: "Technologie",
    duree: "2h",
    place: 12
  },
  {
    titre: "Communication bienveillante",
    descriptif: "Découvrez les principes de la communication non-violente (CNV) pour améliorer vos relations.",
    categories: "Développement personnel",
    duree: "2h",
    place: 18
  },
  {
    titre: "Aquarelle pour débutants",
    descriptif: "Initiez-vous à l'aquarelle : techniques de base, couleurs et composition. Matériel fourni.",
    categories: "Art & Créativité",
    duree: "2h",
    place: 12
  }
]

base_date = DateTime.new(2026, 7, 15, 10, 0) # Festival starts July 15, 2026

offres = []
offres_data.each_with_index do |data, i|
  # Distribute offres across 5 days
  day_offset = i / 2
  hour_offset = (i % 2) * 3 # Morning or afternoon
  
  offre = Offre.create!(
    titre: data[:titre],
    sous_titre: "Atelier pratique",
    descriptif: data[:descriptif],
    categories: data[:categories],
    duree: data[:duree],
    place: data[:place],
    date_prevue: base_date + day_offset.days + hour_offset.hours,
    salle: salles_list.sample,
    fournisseur: fournisseurs[i % fournisseurs.length],
    intervenant: fournisseurs[i % fournisseurs.length].name
  )
  
  # Add secondary fournisseur to some offres
  if i % 3 == 0 && fournisseurs.length > 1
    offre.update(secondary_fournisseur: fournisseurs[(i + 1) % fournisseurs.length])
  end
  
  # Add additional co-animateurs to some offres
  if i % 4 == 0 && fournisseurs.length > 2
    additional_ids = [fournisseurs[(i + 2) % fournisseurs.length].id]
    if fournisseurs.length > 3
      additional_ids << fournisseurs[(i + 3) % fournisseurs.length].id
    end
    offre.additional_fournisseur_ids = additional_ids
  end
  
  offres << offre
end

puts "✓ Created #{offres.count} offres"

# Create bookings
puts "Creating sample bookings..."
bookings_count = 0
users.each do |user|
  # Each user books 2-4 random offres
  offres.sample(rand(2..4)).each do |offre|
    next if offre.user_registered?(user) # Skip if already registered
    
    Booking.create!(
      user: user,
      offre: offre,
      status: "confirmed",
      user_name: user.name,
      user_email: user.email
    )
    bookings_count += 1
  end
end
puts "✓ Created #{bookings_count} bookings"

# Create favoris
puts "Creating sample favoris..."
favoris_count = 0
users.each do |user|
  # Each user likes 3-6 random offres
  offres.sample(rand(3..6)).each do |offre|
    unless Favori.exists?(user: user, offre: offre)
      Favori.create!(user: user, offre: offre)
      favoris_count += 1
    end
  end
end
puts "✓ Created #{favoris_count} favoris"

puts "\n🎉 Development seed completed!"
puts "\n📊 Summary:"
puts "  - Users: #{User.count} (including 1 admin)"
puts "  - Fournisseurs: #{Fournisseur.count}"
puts "  - Offres: #{Offre.count}"
puts "  - Bookings: #{Booking.count}"
puts "  - Favoris: #{Favori.count}"
puts "\n🔑 Login credentials:"
puts "  Admin: admin@example.com / password123"
puts "  Users: user1@example.com through user5@example.com / password123"
puts "  Animateurs: animateur1@example.com through animateur3@example.com / password123"

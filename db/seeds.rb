require 'csv'

csv_file_path = Rails.root.join('db', 'csv', 'offres.csv')

Favori.destroy_all
Booking.destroy_all
Offre.destroy_all
Fournisseur.destroy_all
User.destroy_all

user = User.create!(
  email: "roman@me.com",
  password: "password"
)




fournisseur = Fournisseur.create!(
  bio: Faker::Lorem.paragraph,
  user_id: user.id,
  name: Faker::Name.name
)

CSV.foreach(csv_file_path, headers: true) do |row|
  Offre.create!(
    date_prevue: row['Date'],
    autre_info_date: row['Autres informations sur les dates et heures possibles'],
    statut: row['Statut'  ],
    titre: row['Titre'],
    intervenant: row['Intervenant / animateur /  source'],
    descriptif: row['Descriptif'],
    intention: row['intention'],
    causes: row['La.les causes défendues '],
    cible: row['Le public visé'],
    valeur_apportee: row['La valeur apportée '],
    duree: row['Durée'],
    besoin_espace: row["Besoin en termes despace (Taille salle, nombre participants envisagés, salle envisagée)"],
    besoin_logistique: row['Besoins logistiques (nb chaises, tables, paper-board, coussins, tapis rouge...)'],
    autre_commentaire: row["Autre"],
    fournisseur_id: fournisseur.id
  )
end

fournisseur = Fournisseur.create!(
  bio: Faker::Lorem.paragraph,
  user_id: user.id,
  name: "Raphael Szmir"
)

fournisseur = Fournisseur.create!(
  bio: Faker::Lorem.paragraph,
  user_id: user.id,
  name: "Alexandra Ha Duong"
)

fournisseur = Fournisseur.create!(
  bio: Faker::Lorem.paragraph,
  user_id: user.id,
  name: "Duc Ha Duong"
)

fournisseur = Fournisseur.create!(
  bio: Faker::Lorem.paragraph,
  user_id: user.id,
  name: "Ludovic Odier",
)

Offre.all.each do |offre|
  random_date = Date.new(2025, 1, 1) + rand(365)
  offre.update(date_prevue: random_date)
end


puts "Seed done"

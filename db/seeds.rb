require 'csv'
require 'open-uri'

csv_file_path = Rails.root.join('db', 'csv', 'source_offres.csv')

Favori.destroy_all
Booking.destroy_all
Offre.destroy_all
Fournisseur.destroy_all
User.destroy_all

CSV.foreach(csv_file_path, headers: true, encoding: 'bom|utf-8', row_sep: "\r\n") do |row|
  begin
    user = nil

    if row['intervenant'].present?
      user = User.create!(
        email: Faker::Internet.email,
        password: "password",
        name: row['intervenant']
      )

      fournisseur = Fournisseur.create!(
        bio: row['presentation_intervenant'],
        user_id: user.id,
        name: row['intervenant']
      )
    else
      fournisseur = Fournisseur.create!(
        bio: row['Cette offre n\'a pas d\'intervenant valide'],
        name: row['intervenant']
      )
    end

    date_time = DateTime.strptime("#{row['date']} #{row['heure']}", "%d/%m/%Y %H:%M")

    offre = Offre.create!(
      date_prevue: date_time,
      duree: row['duree'],
      salle: row['salle'],
      titre: row['titre'],
      intervenant: row['intervenant'],
      descriptif: row['descriptif'],
      categories: row['categories'],
      fournisseur_id: fournisseur.id
    )

    if row['visuel_atelier'].present?
      begin
        file = URI.open(row['visuel_atelier'])
        offre.image.attach(
          io: file,
          filename: File.basename(row['visuel_atelier']),
          content_type: 'image/jpeg'
        )
      rescue OpenURI::HTTPError => e
        puts "Could not download image for offre #{offre.id}: #{e.message}"
      end
    end

    if row['visuel_intervenant'].present? && fournisseur.present?
      begin
        file = URI.open(row['visuel_intervenant'])  # Fixed typo in 'visuel_intervevant'
        fournisseur.image.attach(
          io: file,
          filename: File.basename(row['visuel_intervenant']),
          content_type: 'image/jpeg'
        )
      rescue OpenURI::HTTPError => e
        puts "Could not download image for fournisseur #{fournisseur.id}: #{e.message}"
      end
    end

  rescue Date::Error => e
    puts "Error parsing date for row: #{row.inspect}"
    puts "Error message: #{e.message}"
    next
  end
end


puts "Seed done"

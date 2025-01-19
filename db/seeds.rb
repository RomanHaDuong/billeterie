require 'csv'
require 'open-uri'

csv_file_path = Rails.root.join('db', 'csv', 'source_offres.csv')

content = File.read(csv_file_path)
content.gsub!("\r\n", "\n")
CSV.parse(content, headers: true) do |row|
  begin
    # Skip header row and empty rows
    next if row['heure'] == 'Heure'
    next if row['descriptif'] == 'Obligatoire' || row['date'].nil? || row['heure'].nil?
    next if row['heure'] == 'Obligatoire'
    next unless row['statut'] == '3. Programmé'
    next unless row['intervenant'] == 'Matthieu Dardaillon' || row['titre'] == 'Trouver sa place'

    fournisseur = if row['intervenant'].present?
      Fournisseur.all.find { |f| f.name.present? && row['intervenant'].include?(f.name) }
    else
      nil
    end

    if fournisseur.nil?
      fournisseur = Fournisseur.create!(
        bio: row['presentation_intervenant'],
        name: row['intervenant'],
        instagram: row['insta_intervenant'],
        linkedin: row['linkedin_intervenant'],
        offinity: row['offinity_intervenant']

      )
    end

    # Only try to create date_time if btoh date and time are present
    date_time = if row['heure'].present?
      DateTime.strptime("#{row['date']} #{row['heure']}", "%d/%m/%Y %H:%M")
    else
      # If no time provided, default to noon
      DateTime.strptime("#{row['date']} 12:00", "%d/%m/%Y %H:%M")
    end

    offre = Offre.create!(
      date_prevue: date_time,
      duree: row['duree'],
      salle: row['salle'],
      titre: row['titre'],
      intervenant: row['intervenant'],
      descriptif: row['descriptif'],
      categories: row['categories'],
      place: row['places'],
      fournisseur_id: fournisseur&.id,
      sous_titre: row['sous_titre']
    )

    if row['visuel_atelier'].present? && row['visuel_atelier'] != "RAS"
      begin
        file = URI.open(row['visuel_atelier'])
        offre.image.attach(
          io: file,
          filename: File.basename(row['visuel_atelier']),
          content_type: 'image/jpeg'
        )
      rescue OpenURI::HTTPError, Errno::ENOENT => e
        puts "Could not download image for offre #{offre.id}: #{e.message}"
      end
    end

    if row['visuel_intervenant'].present? && row['visuel_intervenant'] != "RAS" && fournisseur.present?
      begin
        file = URI.open(row['visuel_intervenant'])
        fournisseur.image.attach(
          io: file,
          filename: File.basename(row['visuel_intervenant']),
          content_type: 'image/jpeg'
        )
      rescue OpenURI::HTTPError, Errno::ENOENT => e
        puts "Could not download image for fournisseur #{fournisseur.name}: #{e.message}"
      end
    end


    if offre.date_prevue&.year == 25
      new_date = offre.date_prevue.change(year: 2025)
      offre.update(date_prevue: new_date)
      puts "Updated offre '#{offre.titre}' date from #{offre.date_prevue} to #{new_date}"
    end

    if offre.duree.present?
      # cut out the useless zeros
      new_duree = offre.duree[3..-1]
      offre.update(duree: new_duree)
      # append 'h' to duree
      new_duree = offre.duree + 'h'
      offre.update(duree: new_duree)

      puts "Updated duree for '#{offre.titre}' from #{offre.duree} to #{new_duree}"
    end

    if offre.place.nil? || offre.place.zero?
      offre.update(place: 10)
      puts "Updated place for '#{offre.titre}'"
    end

  rescue Date::Error => e
    puts "Error parsing date for row: #{row.inspect}"
    puts "Error message: #{e.message}"
    next
  end
end



puts "Added mathieu's offres"

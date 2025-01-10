require 'csv'
require 'open-uri'

csv_file_path = Rails.root.join('db', 'csv', 'source_offres.csv')

Favori.destroy_all
Booking.destroy_all
Offre.destroy_all
Fournisseur.destroy_all
User.destroy_all

content = File.read(csv_file_path)
content.gsub!("\r\n", "\n")
CSV.parse(content, headers: true) do |row|
  begin
    # Skip header row and empty rows
    next if row['heure'] == 'Heure'
    next if row['descriptif'] == 'Obligatoire' || row['date'].nil? || row['heure'].nil?
    next if row['heure'] == 'Obligatoire'
    next unless row['statut'] == '3. Programmé'

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

    # Only try to create date_time if both date and time are present
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
      fournisseur_id: fournisseur&.id
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


    # bespoke offres

    if row['intervenant'] == 'Duc Ha Duong'
      fournisseur.image.attach(io: File.open('app/assets/images/duc.jpeg'), filename: 'duc.jpeg', content_type: 'image/jpeg')
      fournisseur.offres.first.image.attach(io: File.open('app/assets/images/duc_atelier.png'), filename: 'duc_atelier.png', content_type: 'image/png')
    elsif row['intervenant'] == 'Emmanuelle Roux'
      fournisseur.image.attach(io: File.open('app/assets/images/roux.jpeg'), filename: 'roux.jpeg', content_type: 'image/jpeg')
      fournisseur.image.attach(io: File.open('app/assets/images/roux_atelier.png'), filename: 'roux_atelier.png', content_type: 'image/png')
    elsif row['intervenant'] == 'Matthieu Dardaillon'
      fournisseur.image.attach(io: File.open('app/assets/images/matthieu.jpeg'), filename: 'matthieu.jpeg', content_type: 'image/jpeg')
      fournisseur.offres.first.image.attach(io: File.open('app/assets/images/dardaillon_atelier.png'), filename: 'dardaillon_atelier.png', content_type: 'image/png')
    elsif row['intervenant'] == 'Emmanuelle Hoss'
      fournisseur.image.attach(io: File.open('app/assets/images/hoss.png'), filename: 'hoss.png', content_type: 'image/png')
      fournisseur.offres.first.image.attach(io: File.open('app/assets/images/hoss_atelier.png'), filename: 'hoss_atelier.png', content_type: 'image/png')
    elsif row['titre'] == 'Cérémonie de cloture' || row['titre'] == 'Cérémonie de l\'argent'
      offre.image.attach(io: File.open('app/assets/images/logo.png'), filename: 'logo.png', content_type: 'image/png')
    elsif row['intervenant'] == 'Attaa Ben Elafdil'
      fournisseur.image.attach(io: File.open('app/assets/images/atta.jpeg'), filename: 'atta.jpeg', content_type: 'image/jpeg')
      fournisseur.offres.first.image.attach(io: File.open('app/assets/images/atta_atelier.png'), filename: 'atta_atelier.png', content_type: 'image/png')
    elsif row['intervenant'] == 'Béchir Jiwee et sa tribu'
      fournisseur.image.attach(io: File.open('app/assets/images/bechir.jpeg'), filename: 'bechir.jpeg', content_type: 'image/jpeg')
    elsif row['intervenant'] == 'Caroline Sally'
      fournisseur.image.attach(io: File.open('app/assets/images/caroline.jpeg'), filename: 'caroline.jpeg', content_type: 'image/jpeg')
      fournisseur.offres.first.image.attach(io: File.open('app/assets/images/caroline_atelier.jpeg'), filename: 'caroline_atelier.jpeg', content_type: 'image/jpeg')
    elsif row['intervenant'] == 'Taoufik Vallipuram'
      fournisseur.image.attach(io: File.open('app/assets/images/taoufik.jpeg'), filename: 'taoufik.jpeg', content_type: 'image/jpeg')
    elsif row['intervenant'] == 'Boris Aubligine (Aubel)'
      fournisseur.image.attach(io: File.open('app/assets/images/boris.jpeg'), filename: 'boris.jpeg', content_type: 'image/jpeg')
      fournisseur.offres.first.image.attach(io: File.open('app/assets/images/boris_atelier.jpeg'), filename: 'boris_atelier.jpeg', content_type: 'image/jpeg')
    elsif row['intervenant'] == 'Morgane ROLLANDO'
      fournisseur.image.attach(io: File.open('app/assets/images/morgane.jpeg'), filename: 'morgane.jpeg', content_type: 'image/jpeg')
      fournisseur.offres.first.image.attach(io: File.open('app/assets/images/morgane_atelier.jpeg'), filename: 'morgane_atelier.jpeg', content_type: 'image/jpeg')
    elsif row['intervenant'] == 'Valérie Vajou'
      fournisseur.image.attach(io: File.open('app/assets/images/valerie.jpeg'), filename: 'valerie.jpeg', content_type: 'image/jpeg')
    end

    if row['titre'] == 'Voyage en 2030 Glorieuses (version classique)'
      fournisseur.update!(
        bio: 'Olivier Ménicot est un entrepreneur systémique dont la cause est la transformation écologique des organisations. Il aime voyager dans le temps pour réflechir au Monde d\'Après.',
        name: 'Olivier Ménicot',
        linkedin: 'www.linkedin.com/in/oliviermenicot'
      )

      unless Fournisseur.exists?(name: 'Christophe Limon')
        secondary_fournisseur = Fournisseur.create!(
          bio: 'Christophe Limon accompagne les entreprises à intégrer les démarches à impact positif dans leur modèle d\'affaires. j\'aime les embarquer en 2030 Glorieuses pour se libérer du présent et mieux imaginer leur futur.',
          name: 'Christophe Limon',
          linkedin: 'https://www.linkedin.com/in/christophe-limon-%F0%9F%92%9A-a37a332a/'
        )

        offre.update!(secondary_fournisseur: secondary_fournisseur)
      end
    end

    if row['titre'] == 'Jeu "En-quête de soi"'
      fournisseur.update!(
        bio: 'Corinne Risse est accompagnante et créatrice - facilitatrice d\'ateliers, spécialisée sur les stratégies mentales et sur l\'intuition.',
        name: 'Corinne Risse',
        linkedin: 'https://www.linkedin.com/in/corinne-risse-12b731125/',
        instagram: 'https://www.instagram.com/humainenherbe/'
      )

      begin
        file = URI.open('https://lh3.googleusercontent.com/pw/AP1GczPKonFcxQz1GNo7aGK1lwTlePxxBom3Golz0uN7yZN6I1xtsWKuQOgidIn7HAjoTgrdIkFRnMvDfXJ-whY5yyDYO1XZZOL90mfZ1pD9sfETRhOsnLnXOltYuUBRw23Z6n3l1kJ7NgOfVQobEQ6fqhyt=w800-h800-s-no-gm?authuser=0')
        fournisseur.image.attach(
          io: file,
          filename: File.basename('https://lh3.googleusercontent.com/pw/AP1GczPKonFcxQz1GNo7aGK1lwTlePxxBom3Golz0uN7yZN6I1xtsWKuQOgidIn7HAjoTgrdIkFRnMvDfXJ-whY5yyDYO1XZZOL90mfZ1pD9sfETRhOsnLnXOltYuUBRw23Z6n3l1kJ7NgOfVQobEQ6fqhyt=w800-h800-s-no-gm?authuser=0'),
          content_type: 'image/jpeg'
        )
      rescue OpenURI::HTTPError, Errno::ENOENT => e
        puts "Could not download image for fournisseur #{fournisseur.name}: #{e.message}"
      end


      unless Fournisseur.exists?(name: 'Damien Syren')
        secondary_fournisseur = Fournisseur.create!(
          bio: 'Damien Syren est Head of Customer Success chez Medoucine et fondateur de @plus.de.serenite, service d\'accompagnement autour de la santé mentale et du burn-out..',
          name: 'Damien Syren',
          linkedin: 'https://www.linkedin.com/in/damien-syren/',
          instagram: 'https://www.instagram.com/plus.de.serenite/'
        )

        begin
          file = URI.open('https://lh3.googleusercontent.com/pw/AP1GczPHYz6UinEsc7PpWtZy6pZsh3i0nmeLZbgggFn8dTJqmgZ-DbYutjwWd4lF1pa7o6yxMWpTemnBtPgyyzla3DmqYzuIcuuQrM7qOXCl6eHasEtWuUyc0snQYf5vplhl6WQEaK0S3K30YburI3I2IyfQ=w799-h800-s-no-gm?authuser=0')
          secondary_fournisseur.image.attach(
            io: file,
            filename: File.basename('https://lh3.googleusercontent.com/pw/AP1GczPHYz6UinEsc7PpWtZy6pZsh3i0nmeLZbgggFn8dTJqmgZ-DbYutjwWd4lF1pa7o6yxMWpTemnBtPgyyzla3DmqYzuIcuuQrM7qOXCl6eHasEtWuUyc0snQYf5vplhl6WQEaK0S3K30YburI3I2IyfQ=w799-h800-s-no-gm?authuser=0'),
            content_type: 'image/jpeg'
          )
        rescue OpenURI::HTTPError, Errno::ENOENT => e
          puts "Could not download image for fournisseur #{fournisseur.name}: #{e.message}"
        end

        offre.update!(secondary_fournisseur: secondary_fournisseur)
      end
    end


    if row['titre'] == 'Chant et travail qui relie.'
      fournisseur.update!(
        bio: 'Stéphane Gabbay met la musique et l\'intelligence collective au service des transitions (www.facilitationmusicale.com)',
        name: 'Stéphane Gabbay',
        linkedin: 'https://www.linkedin.com/in/sgabbay/',
        instagram: 'https://www.instagram.com/stephane.gabbay/'
      )

      unless Fournisseur.exists?(name: 'Sandrine Laplace')
        secondary_fournisseur = Fournisseur.create!(
          bio: 'Sandrine Laplace est une scientifique qui explore d\'autres manières d\'envisager le monde. Elle propose des expériences qui mèlent les sciences, les émotions, la poésie et le corps pour élargir nos visions du monde. Elle a créé l\'association 7ème Génération qui oeuvre avec ces expériences pour que le monde soit encore habitable pour les futures générations (https://www.7eme-generation.org/)',
          name: 'Sandrine Laplace',
          linkedin: 'https://www.linkedin.com/in/sandrinelaplace2/'
        )

        secondary_fournisseur.image.attach(io: File.open('app/assets/images/sandrine.jpeg'), filename: 'sandrine.jpeg', content_type: 'image/jpeg')


        offre.update!(secondary_fournisseur: secondary_fournisseur)
      end
    end

    if row['titre'] == 'L’Hypnose & le chant fluidifient-ils la collaboration?'
      if Fournisseur.exists?(name: 'Stéphane Gabbay')
        fournisseur = Fournisseur.find_by(name: 'Stéphane Gabbay')
      else
        fournisseur.update!(
          bio: 'Stéphane Gabbay met la musique et l\'intelligence collective au service des transitions (www.facilitationmusicale.com)',
          name: 'Stéphane Gabbay',
          linkedin: 'https://www.linkedin.com/in/sgabbay/',
          instagram: 'https://www.instagram.com/stephane.gabbay/'
        )
      end

      unless Fournisseur.exists?(name: 'Lena Jaros')
        secondary_fournisseur = Fournisseur.create!(
          name: 'Lena Jaros'
        )

        offre.update!(secondary_fournisseur: secondary_fournisseur)
      end
    end


  rescue Date::Error => e
    puts "Error parsing date for row: #{row.inspect}"
    puts "Error message: #{e.message}"
    next
  end
end

# Cedric Ringenbach

fournisseur = Fournisseur.create!(
  name: "Cedric Ringenbach",
  bio: "Cédric Ringenbach est un ingénieur et conférencier spécialisé dans le changement climatique. Fondateur de la Fresque du Climat en 2015, premier directeur du Shift Project (2010-2016), il enseigne dans les grandes écoles et dirige Blue Choice, une société de conseil en stratégie climatique.",
  linkedin: "https://www.linkedin.com/in/cedringen/",
  )

fournisseur.image.attach(io: File.open('app/assets/images/cedric.jpeg'), filename: 'cedric.jpeg', content_type: 'image/jpeg')

Offre.all.each do |offre|
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
end

puts "Seed done"

class Admin::ExportsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    # Show available exports
  end

  def export_all
    # Create a zip file with all exports
    require 'zip'
    require 'csv'
    
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    zip_filename = "billeterie_export_#{timestamp}.zip"
    temp_dir = Rails.root.join('tmp', 'exports', timestamp)
    FileUtils.mkdir_p(temp_dir)

    begin
      # Generate all CSV files
      generate_users_csv(temp_dir)
      generate_offres_csv(temp_dir)
      generate_bookings_csv(temp_dir)
      generate_fournisseurs_csv(temp_dir)
      generate_favoris_csv(temp_dir)
      generate_pre_registrations_csv(temp_dir)
      
      # Create zip file
      zip_path = Rails.root.join('tmp', zip_filename)
      
      Zip::File.open(zip_path, create: true) do |zipfile|
        Dir[File.join(temp_dir, '*.csv')].each do |file|
          zipfile.add(File.basename(file), file)
        end
      end

      send_file zip_path, filename: zip_filename, type: 'application/zip'
    ensure
      # Clean up temp files
      FileUtils.rm_rf(temp_dir) if File.exist?(temp_dir)
      # Don't delete zip immediately - Rails needs it for sending
      # It will be cleaned up by tmp:clear task
    end
  end

  def users
    require 'csv'
    
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Email', 'Nom', 'Admin', 'Intervenant', 'Date de création']
      
      User.find_each do |user|
        csv << [
          user.id,
          user.email,
          user.name,
          user.admin? ? 'Oui' : 'Non',
          user.intervenant? ? 'Oui' : 'Non',
          user.created_at.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
    end

    send_data csv_data, filename: "users_#{Date.today}.csv", type: 'text/csv'
  end

  def offres
    require 'csv'
    
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Titre', 'Sous-titre', 'Date prévue', 'Intervenant principal', 'Durée', 'Places totales', 
              'Places réservées', 'Salle', 'Catégories', 'Descriptif', 'Date de création']
      
      Offre.includes(:fournisseur, :bookings).find_each do |offre|
        csv << [
          offre.id,
          offre.titre,
          offre.sous_titre,
          offre.date_prevue&.strftime('%Y-%m-%d %H:%M'),
          offre.fournisseur&.name || offre.fournisseur&.user&.email,
          offre.duree,
          offre.place,
          offre.bookings.count,
          offre.salle,
          offre.categories,
          offre.descriptif,
          offre.created_at.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
    end

    send_data csv_data, filename: "offres_#{Date.today}.csv", type: 'text/csv'
  end

  def bookings
    require 'csv'
    
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Utilisateur', 'Email utilisateur', 'Atelier', 'Date atelier', 'Date d\'inscription']
      
      Booking.includes(:user, :offre).find_each do |booking|
        csv << [
          booking.id,
          booking.user.name || booking.user.email,
          booking.user.email,
          booking.offre.titre,
          booking.offre.date_prevue&.strftime('%Y-%m-%d %H:%M'),
          booking.created_at.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
    end

    send_data csv_data, filename: "bookings_#{Date.today}.csv", type: 'text/csv'
  end

  def fournisseurs
    require 'csv'
    
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Nom', 'Email', 'Biographie', 'LinkedIn', 'Instagram', 'Offinity', 
              'Nombre d\'ateliers', 'Date de création']
      
      Fournisseur.includes(:offres, :user).find_each do |fournisseur|
        csv << [
          fournisseur.id,
          fournisseur.name,
          fournisseur.user&.email,
          fournisseur.bio,
          fournisseur.linkedin,
          fournisseur.instagram,
          fournisseur.offinity,
          fournisseur.offres.count,
          fournisseur.created_at.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
    end

    send_data csv_data, filename: "fournisseurs_#{Date.today}.csv", type: 'text/csv'
  end

  def favoris
    require 'csv'
    
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Utilisateur', 'Email utilisateur', 'Atelier', 'Date de création']
      
      Favori.includes(:user, :offre).find_each do |favori|
        csv << [
          favori.id,
          favori.user.name || favori.user.email,
          favori.user.email,
          favori.offre.titre,
          favori.created_at.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
    end

    send_data csv_data, filename: "favoris_#{Date.today}.csv", type: 'text/csv'
  end

  def pre_registrations
    require 'csv'
    
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Email', 'Rôle', 'Date de création']
      
      PreRegistration.find_each do |pre_reg|
        csv << [
          pre_reg.id,
          pre_reg.email,
          pre_reg.role,
          pre_reg.created_at.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
    end

    send_data csv_data, filename: "pre_registrations_#{Date.today}.csv", type: 'text/csv'
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Accès non autorisé"
    end
  end

  # Helper methods for generating CSVs in temp directory
  def generate_users_csv(dir)
    CSV.open(File.join(dir, 'users.csv'), 'w', headers: true) do |csv|
      csv << ['ID', 'Email', 'Nom', 'Admin', 'Intervenant', 'Date de création']
      User.find_each do |user|
        csv << [user.id, user.email, user.name, 
                user.admin? ? 'Oui' : 'Non', user.intervenant? ? 'Oui' : 'Non',
                user.created_at.strftime('%Y-%m-%d %H:%M:%S')]
      end
    end
  end

  def generate_offres_csv(dir)
    CSV.open(File.join(dir, 'offres.csv'), 'w', headers: true) do |csv|
      csv << ['ID', 'Titre', 'Sous-titre', 'Date prévue', 'Intervenant principal', 'Durée', 'Places totales', 
              'Places réservées', 'Salle', 'Catégories', 'Descriptif', 'Date de création']
      Offre.includes(:fournisseur, :bookings).find_each do |offre|
        csv << [offre.id, offre.titre, offre.sous_titre, offre.date_prevue&.strftime('%Y-%m-%d %H:%M'),
                offre.fournisseur&.name || offre.fournisseur&.user&.email, offre.duree, offre.place,
                offre.bookings.count, offre.salle, offre.categories, offre.descriptif,
                offre.created_at.strftime('%Y-%m-%d %H:%M:%S')]
      end
    end
  end

  def generate_bookings_csv(dir)
    CSV.open(File.join(dir, 'bookings.csv'), 'w', headers: true) do |csv|
      csv << ['ID', 'Utilisateur', 'Email utilisateur', 'Atelier', 'Date atelier', 'Date d\'inscription']
      Booking.includes(:user, :offre).find_each do |booking|
        csv << [booking.id, booking.user.name || booking.user.email, booking.user.email,
                booking.offre.titre, booking.offre.date_prevue&.strftime('%Y-%m-%d %H:%M'),
                booking.created_at.strftime('%Y-%m-%d %H:%M:%S')]
      end
    end
  end

  def generate_fournisseurs_csv(dir)
    CSV.open(File.join(dir, 'fournisseurs.csv'), 'w', headers: true) do |csv|
      csv << ['ID', 'Nom', 'Email', 'Biographie', 'LinkedIn', 'Instagram', 'Offinity', 
              'Nombre d\'ateliers', 'Date de création']
      Fournisseur.includes(:offres, :user).find_each do |fournisseur|
        csv << [fournisseur.id, fournisseur.name, fournisseur.user&.email, fournisseur.bio,
                fournisseur.linkedin, fournisseur.instagram, fournisseur.offinity,
                fournisseur.offres.count, fournisseur.created_at.strftime('%Y-%m-%d %H:%M:%S')]
      end
    end
  end

  def generate_favoris_csv(dir)
    CSV.open(File.join(dir, 'favoris.csv'), 'w', headers: true) do |csv|
      csv << ['ID', 'Utilisateur', 'Email utilisateur', 'Atelier', 'Date de création']
      Favori.includes(:user, :offre).find_each do |favori|
        csv << [favori.id, favori.user.name || favori.user.email, favori.user.email,
                favori.offre.titre, favori.created_at.strftime('%Y-%m-%d %H:%M:%S')]
      end
    end
  end

  def generate_pre_registrations_csv(dir)
    CSV.open(File.join(dir, 'pre_registrations.csv'), 'w', headers: true) do |csv|
      csv << ['ID', 'Email', 'Rôle', 'Date de création']
      PreRegistration.find_each do |pre_reg|
        csv << [pre_reg.id, pre_reg.email, pre_reg.role, pre_reg.created_at.strftime('%Y-%m-%d %H:%M:%S')]
      end
    end
  end
end

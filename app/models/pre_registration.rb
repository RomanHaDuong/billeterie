class PreRegistration < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[admin intervenant] }

  def self.find_and_apply(user)
    pre_reg = find_by(email: user.email.downcase)
    return unless pre_reg

    case pre_reg.role
    when 'admin'
      user.update(admin: true)
    when 'intervenant'
      Fournisseur.create!(
        user: user,
        name: user.name || user.email,
        bio: "Intervenant du Festival du 47"
      ) unless user.fournisseur.present?
    end

    pre_reg.destroy # Remove after applying
  end
end

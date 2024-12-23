class OffresController < ApplicationController
  def index
    @offres = Offre.all
  end
end

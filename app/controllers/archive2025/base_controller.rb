class Archive2025::BaseController < ApplicationController
  layout 'archive_2025'
  
  before_action :set_archive_mode
  
  private
  
  def set_archive_mode
    @archive_mode = true
  end
end

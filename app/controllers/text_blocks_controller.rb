class TextBlocksController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def update
    @text_block = TextBlock.find(params[:id])
    if @text_block.update(text_block_params)
      respond_to do |format|
        format.json { render json: { success: true, content: @text_block.content } }
        format.html { redirect_to request.referer || root_path, notice: 'Text updated.' }
      end
    else
      render json: { success: false, errors: @text_block.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def text_block_params
    params.require(:text_block).permit(:content)
  end

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end

module TextBlockHelper
  def editable_text(key, default = "")
    block = TextBlock.find_or_create_by(key: key) do |tb|
      tb.content = default
    end
    
    if current_user&.admin? && session[:edit_mode]
      content_tag :span, block.content.html_safe, 
        data: { editable_text_block: true, text_block_id: block.id }, 
        class: 'editable-text-block', 
        style: 'cursor:pointer; border-bottom: 2px dashed #ffc107; padding: 2px 4px; display: inline-block;'
    else
      block.content.html_safe
    end
  end
end

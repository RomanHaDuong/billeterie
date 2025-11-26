module TextBlockHelper
  def editable_text(key, default = "")
    block = TextBlock.find_or_create_by(key: key) do |tb|
      tb.content = default
    end
    
    if current_user&.admin?
      css_class = session[:edit_mode] ? 'editable-text-block cms-editable-active' : 'editable-text-block'
      content_tag :span, block.content.html_safe, 
        data: { editable_text_block: true, text_block_id: block.id }, 
        class: css_class
    else
      block.content.html_safe
    end
  end
end

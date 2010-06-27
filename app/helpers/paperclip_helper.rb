module PaperclipHelper
  
  def link_to_attachment(item, attachment, options = {}, html_options = {})
    my_attachment = item.send(attachment)
    return 'No file.' unless my_attachment.file?
    style = options.delete(:style) || :original
    link_style = options.delete(:link_style) || style
    display_style = options.delete(:display_style) || style
    use_image = options.delete(:use_image) || true
    html_options[:popup] ||= true
    html_options[:id] ||= "#{item.class}_#{attachment}_#{item.id}"
    text = IMAGE_TYPES.include?(my_attachment.content_type) && use_image ? image_tag(my_attachment.url(display_style)) : "Link to #{my_attachment.original_filename}"
    return link_to(text, my_attachment.url(link_style), html_options)
  end
  alias_method :link_to_paperclip, :link_to_attachment
  
  def link_to_delete_paperclip(item, attachment, options = {}, html_options = {})
    return unless item.send(attachment).file?
    my_id = html_options[:id] ||= "delete_#{item.class}_#{attachment}_#{item.id}"
    attachment_id = options[:attachment_id] || "#{item.class}_#{attachment}_#{item.id}"
    text = options[:text] || "Delete #{attachment.to_s.titleize}"
    # link_to_remote(
    #   text, 
    #   {
    #     :url => paperclip_path(item.class.to_s, item.id, attachment.to_s), 
    #     :method => :delete,
    #     :loading => "document.getElementById('#{my_id}').innerHTML = 'Deleting...'",
    #     :success => "document.getElementById('#{my_id}').innerHTML = 'Done.'; document.getElementById('#{attachment_id}').style.display = 'none'"
    #   },
    #   html_options
    # )
    html_options[:onclick] = <<-JAVASCRIPT
    $.ajax({
      url: '#{paperclip_path(item.class.to_s, item.id, attachment.to_s)}',
      data: {method:'_delete'},
      loading: function(){document.getElementById('#{my_id}').innerHTML = 'Deleting...'},
      success: function(){
        document.getElementById('#{my_id}').innerHTML = 'Done.'; 
        document.getElementById('#{attachment_id}').style.display = 'none';
      }
    });
    return false
    JAVASCRIPT
    link_to(text, nil, html_options)
  end
  alias_method :link_to_destroy_paperclip, :link_to_delete_paperclip
  
  
end
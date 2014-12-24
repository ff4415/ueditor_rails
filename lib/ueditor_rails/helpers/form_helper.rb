module UeditorRails
  module Helpers
    module FormHelper
      extend ActiveSupport::Concern

      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::JavaScriptHelper
      include ActionView::Helpers::Tags

      def ueditor_text(object_name, method = nil, options = {})
        if defined?(ActionView::Base::InstanceTag)
          instance_tag = ActionView::Base::InstanceTag.new(object_name, method, self, options.delete('object'))
        else
          instance_tag = ActionView::Helpers::Tags::TextArea.new(object_name, method, self, options)
        end
        # instance_tag = ActionView::Helpers::Tags::TextArea.new(object_name, method, self, options)
        instance_tag.send(:add_default_name_and_id, options) if options[:id].blank?

        element_id = options.delete('id')
        ue_tag_attributes = {:type => 'text/plain', :id => element_id, :name => options.delete('name')}
        options[:initialFrameWidth] = options.delete(:width) unless options[:width].blank?
        options[:initialFrameHeight] = options.delete(:height) unless options[:height].blank?

        output_buffer = ActiveSupport::SafeBuffer.new
        #output_buffer << instance_tag.to_content_tag(:script, ue_tag_attributes)
        if defined?(ActionView::Base::InstanceTag)
          output_buffer << instance_tag.to_text_area_tag(ue_tag_attributes)
        else
          output_buffer << instance_tag.render
        end
        # output_buffer << instance_tag.to_text_area_tag(ue_tag_attributes)
        output_buffer << javascript_tag {Util.js_replace(element_id, options.stringify_keys)}
        output_buffer
      end
    end
  end
end

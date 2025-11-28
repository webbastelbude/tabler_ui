# frozen_string_literal: true

module TablerUi
  class FormBuilder < ActionView::Helpers::FormBuilder
    delegate :tag, :safe_join, to: :@template

    def input(method, options = {})
      @form_options = options
      object_type = object_type_for_method(method)

      input_type = case object_type
      when :date then :string
      when :integer then :string
      else object_type
      end

      override_input_type = if options[:as]
        options[:as]
      elsif options[:collection] && ![:imagecheck, :color].include?(options[:as])
        :select
      end

      send("#{override_input_type || input_type}_input", method, options)
    end

    private

    def form_group(method, options = {}, &block)
      tag.div class: "mb-3 #{method}" do
        safe_join [
          block.call,
          hint_text(options[:hint]),
          error_text(method)
        ].compact
      end
    end

    def hint_text(text)
      return if text.nil?
      tag.small text, class: "form-hint"
    end

    def label_with_description(method, options = {})
      label_text = options[:label] || method.to_s.humanize
      description = options[:label_description]
      required = options[:required]

      if description
        label(method, class: "form-label") do
          safe_join [
            tag.span(label_text),
            (tag.span(" *", class: "text-danger") if required),
            tag.span(description, class: "form-label-description")
          ].compact
        end
      else
        label_class = required ? "form-label required" : "form-label"
        label(method, label_text, class: label_class)
      end
    end

    def error_text(method)
      return unless has_error?(method)

      tag.div(@object.errors[method].join("<br />").html_safe, class: "invalid-feedback")
    end

    def object_type_for_method(method)
      result = if @object.respond_to?(:type_for_attribute) && @object.has_attribute?(method)
        @object.type_for_attribute(method.to_s).try(:type)
      elsif @object.respond_to?(:column_for_attribute) && @object.has_attribute?(method)
        @object.column_for_attribute(method).try(:type)
      end

      result || :string
    end

    def has_error?(method)
      return false unless @object.respond_to?(:errors)
      @object.errors.key?(method)
    end

    # Inputs and helpers

    def string_input(method, options = {})
      form_group(method, options) do
        safe_join [
          (label_with_description(method, options) unless options[:label] == false),
          string_field(method, merge_input_options({class: "form-control #{"is-invalid" if has_error?(method)}"}, options[:input_html]))
        ]
      end
    end

    def text_input(method, options = {})
      form_group(method, options) do
        safe_join [
          (label_with_description(method, options) unless options[:label] == false),
          text_area(method, merge_input_options({class: "form-control #{"is-invalid" if has_error?(method)}"}, options[:input_html]))
        ]
      end
    end

    def boolean_input(method, options = {})
      form_group(method, options) do
        tag.label(class: "form-check") do
          safe_join [
            check_box(method, merge_input_options({class: "form-check-input"}, options[:input_html])),
            tag.span(options[:label] || method.to_s.humanize, class: "form-check-label")
          ]
        end
      end
    end

    def collection_input(method, options, &block)
      form_group(method, options) do
        safe_join [
          (label_with_description(method, options) unless options[:label] == false),
          block.call
        ]
      end
    end

    def select_input(method, options = {})
      value_method = options[:value_method] || :to_s
      text_method = options[:text_method] || :to_s
      input_options = options[:input_html] || {}

      multiple = input_options[:multiple]

      collection_input(method, options) do
        collection_select(method, options[:collection], value_method, text_method, options, merge_input_options({class: "form-select #{"is-invalid" if has_error?(method)}"}, options[:input_html]))
      end
    end

    def grouped_select_input(method, options = {})
      # We probably need to go back later and adjust this for more customization
      collection_input(method, options) do
        grouped_collection_select(method, options[:collection], :last, :first, :to_s, :to_s, options, merge_input_options({class: "form-select #{"is-invalid" if has_error?(method)}"}, options[:input_html]))
      end
    end

    def file_input(method, options = {})
      form_group(method, options) do
        safe_join [
          (label_with_description(method, options) unless options[:label] == false),
          file_field(method, merge_input_options({class: "form-control #{"is-invalid" if has_error?(method)}"}, options[:input_html]))
        ]
      end
    end

    def collection_of(input_type, method, options = {})
      form_builder_method, check_class, input_builder_method = case input_type
      when :radio_buttons then [:collection_radio_buttons, "form-check", :radio_button]
      when :check_boxes then [:collection_check_boxes, "form-check", :check_box]
      else raise "Invalid input_type for collection_of, valid input_types are \":radio_buttons\", \":check_boxes\""
      end

      # Use selectgroup styling if specified
      use_selectgroup = options[:selectgroup] || options[:selectgroup_pills] || options[:selectgroup_buttons]

      form_group(method, options) do
        safe_join [
          (label_with_description(method, options) unless options[:label] == false),
          if use_selectgroup
            selectgroup_collection(form_builder_method, method, options, input_builder_method)
          else
            tag.div(class: "form-selectgroup") do
              send(form_builder_method, method, options[:collection], options[:value_method], options[:text_method]) do |b|
                tag.label(class: check_class) do
                  safe_join [
                    b.send(input_builder_method, class: "form-check-input"),
                    tag.span(b.text, class: "form-check-label")
                  ]
                end
              end
            end
          end
        ]
      end
    end

    def selectgroup_collection(form_builder_method, method, options, input_builder_method)
      selectgroup_class = ["form-selectgroup"]
      selectgroup_class << "form-selectgroup-pills" if options[:selectgroup_pills]
      selectgroup_class << "form-selectgroup-boxes" if options[:selectgroup_buttons]

      tag.div(class: selectgroup_class.join(" ")) do
        send(form_builder_method, method, options[:collection], options[:value_method], options[:text_method]) do |b|
          tag.label(class: "form-selectgroup-item") do
            safe_join [
              b.send(input_builder_method, class: "form-selectgroup-input"),
              tag.span(b.text, class: "form-selectgroup-label")
            ]
          end
        end
      end
    end

    def radio_buttons_input(method, options = {})
      collection_of(:radio_buttons, method, options)
    end

    def check_boxes_input(method, options = {})
      collection_of(:check_boxes, method, options)
    end

    def string_field(method, options = {})
      case object_type_for_method(method)
      when :date
        text_field(method, merge_input_options(options, {data: {controller: "tabler-ui--datepicker"}, "autocomplete": "off" }))
      when :integer then number_field(method, options)
      when :string
        case method.to_s
        when /password/ then password_field(method, options)
        when /email/ then email_field(method, options)
        when /phone/ then telephone_field(method, options)
        when /url/ then url_field(method, options)
        else
          text_field(method, options)
        end
      end
    end

    # Toggle switch input (alternative to checkbox)
    def toggle_input(method, options = {})
      form_group(method, options) do
        tag.label(class: "form-check form-switch") do
          safe_join [
            check_box(method, merge_input_options({class: "form-check-input"}, options[:input_html])),
            tag.span(options[:label] || method.to_s.humanize, class: "form-check-label")
          ]
        end
      end
    end

    # Color input with Tabler styling
    def color_input(method, options = {})
      colors = options[:colors] || %w[#206bc4 #4299e1 #0ca678 #f59f00 #d63939 #ae3ec9]
      value_method = options[:value_method] || :to_s

      form_group(method, options) do
        safe_join [
          (label_with_description(method, options) unless options[:label] == false),
          tag.div(class: "form-colorinput") do
            colors.map do |color|
              color_value = color.respond_to?(value_method) ? color.send(value_method) : color
              tag.label(class: "form-colorinput-color", style: "background-color: #{color_value}") do
                radio_button(method, color_value, class: "form-colorinput-input")
              end
            end.join.html_safe
          end
        ]
      end
    end

    # Image check input for image-based selections
    def imagecheck_input(method, options = {})
      collection = options[:collection] || []
      value_method = options[:value_method] || :to_s
      image_method = options[:image_method] || :image_url
      text_method = options[:text_method] || :to_s
      multiple = options[:multiple]

      form_group(method, options) do
        safe_join [
          (label_with_description(method, options) unless options[:label] == false),
          tag.div(class: "form-imagecheck") do
            collection.map do |item|
              value = item.respond_to?(value_method) ? item.send(value_method) : item
              image = item.respond_to?(image_method) ? item.send(image_method) : item
              text = item.respond_to?(text_method) ? item.send(text_method) : item.to_s

              tag.label(class: "form-imagecheck-item") do
                safe_join [
                  if multiple
                    check_box(method, { class: "form-imagecheck-input", multiple: true }, value, nil)
                  else
                    radio_button(method, value, class: "form-imagecheck-input")
                  end,
                  tag.figure(class: "form-imagecheck-figure") do
                    tag.img(src: image, alt: text, class: "form-imagecheck-image")
                  end,
                  (tag.span(text, class: "form-imagecheck-caption") if options[:show_text])
                ].compact
              end
            end.join.html_safe
          end
        ]
      end
    end

    # Input group with prepend/append
    def input_group(method, options = {})
      prepend = options[:prepend]
      append = options[:append]
      prepend_button = options[:prepend_button]
      append_button = options[:append_button]

      form_group(method, options) do
        safe_join [
          (label_with_description(method, options) unless options[:label] == false),
          tag.div(class: "input-group") do
            safe_join [
              (tag.span(prepend, class: "input-group-text") if prepend),
              (prepend_button if prepend_button),
              string_field(method, merge_input_options({class: "form-control #{"is-invalid" if has_error?(method)}"}, options[:input_html])),
              (tag.span(append, class: "input-group-text") if append),
              (append_button if append_button)
            ].compact
          end
        ]
      end
    end

    # Floating label input
    def floating_input(method, options = {})
      input_type = options[:type] || :text

      form_group(method, options) do
        tag.div(class: "form-floating") do
          safe_join [
            if input_type == :textarea
              text_area(method, merge_input_options({
                class: "form-control #{"is-invalid" if has_error?(method)}",
                placeholder: options[:label] || method.to_s.humanize
              }, options[:input_html]))
            else
              text_field(method, merge_input_options({
                class: "form-control #{"is-invalid" if has_error?(method)}",
                placeholder: options[:label] || method.to_s.humanize
              }, options[:input_html]))
            end,
            label(method, options[:label] || method.to_s.humanize)
          ]
        end
      end
    end

    def merge_input_options(options, user_options)
      return options if user_options.nil?

      # Merge classes properly
      if options[:class] && user_options[:class]
        merged_options = options.merge(user_options)
        merged_options[:class] = "#{options[:class]} #{user_options[:class]}"
        merged_options
      else
        options.merge(user_options)
      end
    end
  end
end

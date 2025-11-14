# frozen_string_literal: true

require "ostruct"

module TablerUi
  # Core UI component dispatcher
  # Dynamically resolves component names and renders them via method_missing pattern
  class Ui
    include ActionView::Helpers::RenderingHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    # @param view_context [ActionView::Base] The view context where components are rendered
    def initialize(view_context)
      @view = view_context
    end

    # Dynamically handles component method calls
    # Converts component_name to TablerUi::ComponentName::Component class
    # Falls back to rendering partials if no component class exists
    #
    # @param name [Symbol] The component name (e.g., :navbar, :page_header)
    # @param args [Array] Arguments passed to the component
    # @param kwargs [Hash] Keyword arguments converted to component attributes
    # @param block [Proc] Optional block for content projection and slots
    # @return [String] Rendered HTML output
    def method_missing(name, *args, **kwargs, &block)
      klass_name = "TablerUi::#{name.to_s.camelize}::Component"
      Rails.logger.debug "TablerUI: Looking for #{klass_name}"
      component_class = klass_name.safe_constantize

      object = args.first
      object = OpenStruct.new(kwargs) if object.nil? && kwargs.any?
      object = OpenStruct.new(object) if object.is_a?(Hash)

      if component_class
        Rails.logger.debug "TablerUI: Found #{component_class}"
        component = component_class.new(@view)
        inject_data(component, object) if object.present?
      else
        Rails.logger.debug "TablerUI: Not found #{klass_name}, using partial"
        component = object
      end

      if block
        slot_context = SlotContext.new(@view)
        @view.capture(component || slot_context, &block)
        render_component(name, component, slot_context)
      else
        render_component(name, component)
      end
    end

    def respond_to_missing?(name, include_private = false)
      true
    end

    private

    # Renders the component partial with appropriate locals
    # @param name [Symbol] Component name
    # @param component [Object] Component instance or OpenStruct
    # @param slots [SlotContext, nil] Optional slot context for content projection
    # @return [String] Rendered HTML
    def render_component(name, component, slots = nil)
      partial_path = component_class?(component) ? "tabler_ui/#{name}/component" : "tabler_ui/#{name}"

      if slots
        @view.render(partial_path, name => component, slots: slots)
      else
        @view.render(partial_path, name => component)
      end
    end

    # Checks if the object is a TablerUi component class
    # @param object [Object] The object to check
    # @return [Boolean] True if it's a component class
    def component_class?(object)
      object.class.name.start_with?("TablerUi::") && object.class.name.demodulize == object.class.name.demodulize.camelize
    end

    # Injects data into component instance variables
    # @param component [Object] Component instance
    # @param data [OpenStruct, Hash] Data to inject
    def inject_data(component, data)
      data.to_h.each do |key, value|
        component.public_send("#{key}=", value) if component.respond_to?("#{key}=")
      end
    end
  end

  # Slot context for content projection
  # Allows components to capture and render named content blocks
  class SlotContext
    # @param view_context [ActionView::Base] The view context
    def initialize(view_context)
      @view_context = view_context
      @slots = {}
    end

    # Captures slot content via method_missing
    # @param name [Symbol] Slot name
    # @param block [Proc] Content block to capture
    # @return [String, nil] Captured content or nil
    def method_missing(name, *args, &block)
      if block_given?
        @slots[name] = @view_context.capture(&block)
      else
        @slots[name]
      end
    end

    def respond_to_missing?(name, include_private = false)
      true
    end
  end
end

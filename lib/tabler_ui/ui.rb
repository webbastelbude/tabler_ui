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
      component_class = klass_name.safe_constantize

      if component_class
        # Check if component expects keyword arguments (modern pattern)
        # or view_context as first argument (legacy pattern)
        init_method = component_class.instance_method(:initialize)

        if init_method.parameters.any? { |type, _| type == :keyreq || type == :key }
          # Modern pattern: component expects keyword arguments
          component = component_class.new(**kwargs)
        else
          # Legacy pattern: component expects view_context
          object = args.first
          object = OpenStruct.new(kwargs) if object.nil? && kwargs.any?
          object = OpenStruct.new(object) if object.is_a?(Hash)

          component = component_class.new(@view)
          inject_data(component, object) if object.present?
        end
      else
        object = args.first
        object = OpenStruct.new(kwargs) if object.nil? && kwargs.any?
        object = OpenStruct.new(object) if object.is_a?(Hash)
        component = object
      end

      if block
        slot_context = SlotContext.new(@view)

        # Check if component has methods like 'add', 'left', 'right', 'buttons', 'actions', 'item', 'tab'
        # If so, use the component itself for the block, otherwise use SlotContext
        if component.respond_to?(:add) || component.respond_to?(:left) ||
           component.respond_to?(:right) || component.respond_to?(:buttons) ||
           component.respond_to?(:actions) || component.respond_to?(:item) ||
           component.respond_to?(:tab)
          # Component has its own methods for building content
          @view.capture(component, &block)
          render_component(name, component, nil)
        else
          # Use SlotContext for slot-based content projection
          @view.capture(slot_context, &block)
          render_component(name, component, slot_context)
        end
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
      return false if object.nil?
      # Use Object.instance_method(:class) to get the actual Ruby class
      # This bypasses OpenStruct's method_missing which would return the :class attribute value
      klass = Object.instance_method(:class).bind(object).call
      return false unless klass.respond_to?(:name)
      klass_name = klass.name
      return false unless klass_name.is_a?(String)
      klass_name.start_with?("TablerUi::") && klass_name.demodulize == klass_name.demodulize.camelize
    rescue => e
      Rails.logger.error "component_class? error: #{e.message}, object: #{object.inspect}"
      false
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
        # Capture the block content - this properly handles <%= %> outputs
        content = @view_context.capture(&block)
        @slots[name] = content
        # Return empty string to avoid output in the capture context
        ""
      else
        @slots[name]
      end
    end

    def respond_to_missing?(name, include_private = false)
      true
    end

    # Check if any slots have been defined
    # @return [Boolean]
    def empty?
      @slots.empty?
    end

    # Check if a specific slot has content
    def present?(name = nil)
      if name
        @slots[name].present?
      else
        @slots.values.any?(&:present?)
      end
    end
  end
end

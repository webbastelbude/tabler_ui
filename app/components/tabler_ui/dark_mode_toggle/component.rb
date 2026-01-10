# frozen_string_literal: true

module TablerUi
  module DarkModeToggle
    class Component
      attr_reader :size, :custom_class

      def initialize(size: nil, class: nil)
        @size = size
        @custom_class = binding.local_variable_get(:class)
      end

      def icon_size
        case @size
        when :sm then 16
        when :lg then 32
        else 24
        end
      end

      def css_classes
        classes = ["nav-link", "px-0"]
        classes << @custom_class if @custom_class.present?
        classes.join(" ")
      end
    end
  end
end

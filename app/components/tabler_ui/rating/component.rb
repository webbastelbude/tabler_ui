# frozen_string_literal: true

module TablerUi
  module Rating
    class Component
      attr_accessor :id, :name, :value, :options, :required, :disabled, :custom_class, :size, :variant, :tooltip,
                    :clearable, :max_stars

      def initialize(id: nil, name: 'rating', value: nil, options: nil, required: false, disabled: false,
                     custom_class: nil, size: nil, variant: nil, tooltip: true, clearable: true, max_stars: 5)
        @id = id || "rating-#{SecureRandom.hex(4)}"
        @name = name
        @value = value
        @options = options || default_options
        @required = required
        @disabled = disabled
        @custom_class = custom_class
        @size = size
        @variant = variant
        @tooltip = tooltip
        @clearable = clearable
        @max_stars = max_stars
      end

      def default_options
        [
          { value: '', label: 'Select a rating' },
          { value: max_stars, label: 'Excellent' },
          { value: max_stars - 1, label: 'Very Good' },
          { value: max_stars - 2, label: 'Average' },
          { value: max_stars - 3, label: 'Poor' },
          { value: max_stars - 4, label: 'Terrible' }
        ].slice(0, max_stars + 1)
      end

      def controller_attributes
        {
          controller: 'tabler-ui--rating',
          'tabler-ui--rating-id-value' => id,
          'tabler-ui--rating-tooltip-value' => tooltip,
          'tabler-ui--rating-clearable-value' => clearable,
          'tabler-ui--rating-variant-value' => variant,
          'tabler-ui--rating-size-value' => size
        }
      end

      def select_classes
        classes = []
        classes << custom_class if custom_class
        classes.join(' ')
      end

      def selected?(option_value)
        value.to_s == option_value.to_s
      end
    end
  end
end

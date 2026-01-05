# frozen_string_literal: true

module TablerUi
  module Placeholder
    # Placeholder component for Tabler UI
    # Displays skeleton loading states for content
    #
    # @example Basic text placeholder
    #   <%= tabler_ui.placeholder type: :text, width: 9 %>
    #
    # @example Multiple text lines
    #   <%= tabler_ui.placeholder type: :text, lines: [10, 11, 8] %>
    #
    # @example Avatar placeholder
    #   <%= tabler_ui.placeholder type: :avatar %>
    #
    # @example Image placeholder
    #   <%= tabler_ui.placeholder type: :image, ratio: "21x9" %>
    #
    # @example Button placeholder
    #   <%= tabler_ui.placeholder type: :button, width: 4, variant: "primary" %>
    #
    # @example Card placeholder with glow animation
    #   <%= tabler_ui.placeholder type: :card, animation: :glow %>
    class Component
      attr_accessor :type, :width, :size, :animation, :ratio, :variant, :lines,
                    :rounded, :custom_class, :show_image, :show_button

      SIZES = %w[xs sm lg xl].freeze
      ANIMATIONS = %i[glow wave].freeze
      TYPES = %i[text avatar image button card list].freeze
      RATIOS = %w[1x1 4x3 16x9 21x9].freeze

      # Initialize placeholder component
      #
      # @param type [Symbol] Placeholder type (:text, :avatar, :image, :button, :card, :list)
      # @param width [Integer, nil] Column width for text placeholders (1-12)
      # @param size [String, nil] Size variant (xs, sm, lg, xl)
      # @param animation [Symbol, nil] Animation type (:glow, :wave)
      # @param ratio [String, nil] Aspect ratio for images (1x1, 4x3, 16x9, 21x9)
      # @param variant [String, nil] Button variant for button placeholders
      # @param lines [Array<Integer>, nil] Array of column widths for multiple text lines
      # @param rounded [Boolean] Whether avatar should be rounded (default: true)
      # @param custom_class [String, nil] Additional CSS classes
      # @param show_image [Boolean] Show image in card placeholder (default: true)
      # @param show_button [Boolean] Show button in card placeholder (default: true)
      def initialize(type: :text, width: nil, size: nil, animation: nil, ratio: nil,
                     variant: nil, lines: nil, rounded: true, custom_class: nil,
                     show_image: true, show_button: true)
        @type = type.to_sym
        @width = width
        @size = size
        @animation = animation&.to_sym
        @ratio = ratio
        @variant = variant
        @lines = lines
        @rounded = rounded
        @custom_class = custom_class
        @show_image = show_image
        @show_button = show_button
      end

      # Returns placeholder CSS classes for text/inline placeholders
      # @return [String] Combined CSS classes
      def placeholder_classes
        classes = ["placeholder"]
        classes << "placeholder-#{size}" if size && SIZES.include?(size.to_s)
        classes << "col-#{width}" if width
        classes << custom_class if custom_class
        classes.join(" ")
      end

      # Returns wrapper CSS classes with animation
      # @return [String] Combined CSS classes
      def wrapper_classes
        classes = []
        classes << "placeholder-#{animation}" if animation && ANIMATIONS.include?(animation)
        classes << custom_class if custom_class && type == :card
        classes.join(" ")
      end

      # Returns avatar CSS classes
      # @return [String] Combined CSS classes
      def avatar_classes
        classes = ["avatar", "placeholder"]
        classes << "avatar-rounded" if rounded
        classes << "avatar-#{size}" if size
        classes << custom_class if custom_class
        classes.join(" ")
      end

      # Returns button CSS classes
      # @return [String] Combined CSS classes
      def button_classes
        classes = ["btn", "disabled", "placeholder"]
        classes << "btn-#{variant}" if variant
        classes << "col-#{width}" if width
        classes << custom_class if custom_class
        classes.join(" ")
      end

      # Returns image ratio class
      # @return [String] Ratio class
      def ratio_class
        return "ratio-#{ratio}" if ratio && RATIOS.include?(ratio)
        "ratio-21x9"
      end

      # Check if animation should be applied
      # @return [Boolean]
      def has_animation?
        !animation.nil? && ANIMATIONS.include?(animation)
      end

      # Get lines array for multiple text lines
      # @return [Array<Integer>]
      def text_lines
        return lines if lines.is_a?(Array)
        return [width || 9] if width
        [9]
      end
    end
  end
end

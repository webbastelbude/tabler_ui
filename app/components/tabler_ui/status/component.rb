# frozen_string_literal: true

module TablerUi
  module Status
    # Status component for Tabler UI
    # Displays status indicators with various styles and colors
    #
    # @example Basic status
    #   <%= tabler_ui.status(text: "Active", color: "green") %>
    #
    # @example Status with dot
    #   <%= tabler_ui.status(text: "Online", color: "green", dot: true) %>
    #
    # @example Animated status dot
    #   <%= tabler_ui.status(text: "Processing", color: "blue", dot: true, animated: true) %>
    #
    # @example Lite variant
    #   <%= tabler_ui.status(text: "Pending", color: "yellow", lite: true) %>
    #
    # @example Standalone dot
    #   <%= tabler_ui.status(color: "green", dot: true, standalone: true) %>
    #
    # @example Status indicator
    #   <%= tabler_ui.status(color: "red", indicator: true) %>
    #
    # @example Animated status indicator
    #   <%= tabler_ui.status(color: "blue", indicator: true, animated: true) %>
    class Component
      COLORS = %w[
        blue azure indigo purple pink red orange yellow lime green teal cyan
      ].freeze

      attr_reader :text, :color, :dot, :animated, :lite, :standalone, :indicator

      # Initialize status component
      #
      # @param text [String, nil] Status text (optional for standalone dots/indicators)
      # @param color [String] Color variant (blue, green, red, etc.)
      # @param dot [Boolean] Show status dot
      # @param animated [Boolean] Animate the dot or indicator
      # @param lite [Boolean] Use lite variant (less prominent)
      # @param standalone [Boolean] Render as standalone dot (no text)
      # @param indicator [Boolean] Use status indicator style (3 circles)
      def initialize(text: nil, color: "blue", dot: false, animated: false, lite: false, standalone: false, indicator: false)
        @text = text
        @color = validate_color(color)
        @dot = dot
        @animated = animated
        @lite = lite
        @standalone = standalone
        @indicator = indicator
      end

      # Check if component has text
      def has_text?
        @text.present?
      end

      # Check if dot should be animated
      def animated?
        @animated
      end

      # Check if lite variant
      def lite?
        @lite
      end

      # Check if standalone dot
      def standalone?
        @standalone
      end

      # Check if status indicator
      def indicator?
        @indicator
      end

      # Check if regular status with dot
      def with_dot?
        @dot && !@standalone && !@indicator
      end

      # CSS classes for the status element
      def status_classes
        classes = []

        if @indicator
          classes << "status-indicator"
          classes << "status-indicator-animated" if @animated
          classes << "status-#{@color}"
        elsif @standalone
          classes << "status-dot"
          classes << "status-dot-animated" if @animated
          classes << "status-#{@color}"
        else
          classes << "status"
          classes << "status-#{@color}"
          classes << "status-lite" if @lite
        end

        classes.join(" ")
      end

      # CSS classes for the dot element (when used inside status)
      def dot_classes
        classes = ["status-dot"]
        classes << "status-dot-animated" if @animated
        classes.join(" ")
      end

      private

      def validate_color(color)
        return "blue" if color.nil?
        COLORS.include?(color.to_s) ? color.to_s : "blue"
      end
    end
  end
end

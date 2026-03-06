# frozen_string_literal: true

module TablerUi
  module Badge
    # Badge component for Tabler UI
    # Displays small count and labeling components
    #
    # @example Basic badge
    #   <%= tabler_ui.badge text: "New", color: "blue" %>
    #
    # @example Light variant
    #   <%= tabler_ui.badge text: "Pending", color: "yellow", light: true %>
    #
    # @example Pill badge
    #   <%= tabler_ui.badge text: "4", color: "red", pill: true %>
    #
    # @example Notification dot
    #   <%= tabler_ui.badge color: "red", notification: true %>
    #
    # @example Blinking notification
    #   <%= tabler_ui.badge color: "red", notification: true, blink: true %>
    #
    # @example With icon
    #   <%= tabler_ui.badge text: "Star", color: "yellow", icon: "star" %>
    #
    # @example As link
    #   <%= tabler_ui.badge text: "Click me", color: "blue", url: "/path" %>
    #
    # @example With size
    #   <%= tabler_ui.badge text: "Small", color: "green", size: :sm %>
    #   <%= tabler_ui.badge text: "Large", color: "green", size: :lg %>
    class Component
      COLORS = %w[
        blue azure indigo purple pink red orange yellow lime green teal cyan
        primary secondary success danger warning info
      ].freeze

      SIZES = %w[sm lg].freeze

      attr_reader :text, :color, :light, :pill, :notification, :blink,
                  :icon, :url, :size, :custom_class, :content

      attr_writer :content

      # Initialize badge component
      #
      # @param text [String, nil] Badge text
      # @param color [String] Color variant (blue, azure, indigo, purple, pink, red, orange, yellow, lime, green, teal, cyan)
      # @param light [Boolean] Use light/subtle variant (default: false)
      # @param pill [Boolean] Rounded pill shape (default: false)
      # @param notification [Boolean] Empty notification dot (default: false)
      # @param blink [Boolean] Blinking animation for notification dots (default: false)
      # @param icon [String, nil] Tabler icon name
      # @param url [String, nil] URL to make badge a link
      # @param size [String, Symbol, nil] Badge size (:sm or :lg)
      # @param custom_class [String, nil] Additional CSS classes
      def initialize(text: nil, color: nil, light: false, pill: false, notification: false,
                     blink: false, icon: nil, url: nil, size: nil, custom_class: nil)
        @text = text
        @color = validate_color(color)
        @light = light
        @pill = pill
        @notification = notification
        @blink = blink
        @icon = icon
        @url = url
        @size = validate_size(size)
        @custom_class = custom_class
      end

      # CSS classes for the badge element
      # @return [String] Combined CSS classes
      def badge_classes
        classes = ["badge"]

        if @color
          suffix = @light ? "-lt" : ""
          classes << "bg-#{@color}#{suffix}"
          classes << "text-#{@color}#{suffix}-fg"
        end

        classes << "badge-pill" if @pill
        classes << "badge-notification" if @notification
        classes << "badge-blink" if @blink
        classes << "badge-#{@size}" if @size
        classes << @custom_class if @custom_class

        classes.join(" ")
      end

      # Whether to render as a link
      # @return [Boolean]
      def link?
        @url.present?
      end

      # Whether the badge has an icon
      # @return [Boolean]
      def has_icon?
        @icon.present?
      end

      # Whether the badge has visible text content
      # @return [Boolean]
      def has_text?
        @text.present?
      end

      # HTML tag to render
      # @return [String] "a" or "span"
      def tag_name
        link? ? "a" : "span"
      end

      private

      def validate_color(color)
        return nil if color.nil?
        COLORS.include?(color.to_s) ? color.to_s : nil
      end

      def validate_size(size)
        return nil if size.nil?
        s = size.to_s
        SIZES.include?(s) ? s : nil
      end
    end
  end
end

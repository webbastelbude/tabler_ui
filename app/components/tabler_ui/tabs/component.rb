# frozen_string_literal: true

module TablerUi
  module Tabs
    # Tabs component for Tabler UI
    # Creates navigable tab panels with Bootstrap 5 tabs
    #
    # @example Basic usage with block
    #   <%= tabler_ui.tabs(id: "my-tabs") do |tabs| %>
    #     <% tabs.tab(title: "First Tab", icon: "home") do %>
    #       Content for first tab
    #     <% end %>
    #     <% tabs.tab(title: "Second Tab") do %>
    #       Content for second tab
    #     <% end %>
    #   <% end %>
    #
    # @example Card-style tabs
    #   <%= tabler_ui.tabs(id: "card-tabs", style: :card) do |tabs| %>
    #     ...
    #   <% end %>
    #
    # @example Pills style
    #   <%= tabler_ui.tabs(id: "pill-tabs", style: :pills) do |tabs| %>
    #     ...
    #   <% end %>
    class Component
      attr_reader :id, :style, :custom_class, :tabs

      Tab = Struct.new(:id, :title, :icon, :badge, :badge_color, :active, :content, keyword_init: true)

      # Initialize tabs component
      #
      # @param id [String] Unique ID for the tabs container (required for Bootstrap JS)
      # @param style [Symbol] Tab style - :tabs (default), :pills, :card, :underline
      # @param custom_class [String, nil] Additional CSS classes for the nav element
      def initialize(id:, style: :tabs, custom_class: nil)
        @id = id
        @style = style
        @custom_class = custom_class
        @tabs = []
        @tab_counter = 0
      end

      # Add a tab to the component
      #
      # @param title [String] Tab title text
      # @param icon [String, nil] Optional Tabler icon name
      # @param badge [String, nil] Optional badge text
      # @param badge_color [String] Badge color (default: "blue")
      # @param active [Boolean] Whether this tab is initially active (first tab is active by default)
      # @param block [Proc] Content block for the tab panel
      def tab(title:, icon: nil, badge: nil, badge_color: "blue", active: nil, &block)
        @tab_counter += 1
        tab_id = "#{@id}-tab-#{@tab_counter}"

        # First tab is active by default unless explicitly set
        is_active = active.nil? ? @tabs.empty? : active

        content = block_given? ? yield : nil

        @tabs << Tab.new(
          id: tab_id,
          title: title,
          icon: icon,
          badge: badge,
          badge_color: badge_color,
          active: is_active,
          content: content
        )

        # Return empty string to avoid output in capture context
        ""
      end

      # Returns the nav CSS classes based on style
      # @return [String] Combined CSS classes
      def nav_classes
        classes = ["nav"]

        case style
        when :pills
          classes << "nav-pills"
        when :card
          classes << "nav-tabs"
          classes << "card-header-tabs"
        when :underline
          classes << "nav-tabs"
          classes << "nav-tabs-alt"
        else
          classes << "nav-tabs"
        end

        classes << custom_class if custom_class
        classes.join(" ")
      end

      # Check if there are any tabs
      # @return [Boolean]
      def any?
        @tabs.any?
      end
    end
  end
end

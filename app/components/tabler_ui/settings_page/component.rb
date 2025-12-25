# frozen_string_literal: true

module TablerUi
  module SettingsPage
    # SettingsPage component for Tabler UI
    # Creates a settings page with sidebar navigation and content panels
    #
    # @example Basic usage with block
    #   <%= tabler_ui.settings_page(id: "my-settings", title: "Settings") do |sp| %>
    #     <% sp.item(title: "General", icon: "settings") do %>
    #       Content for general settings
    #     <% end %>
    #     <% sp.item(title: "Security", icon: "shield") do %>
    #       Content for security settings
    #     <% end %>
    #   <% end %>
    class Component
      attr_reader :id, :title, :items

      Item = Struct.new(:id, :title, :icon, :active, :content, keyword_init: true)

      # Initialize settings page component
      #
      # @param id [String] Unique ID for the settings container (required for Bootstrap JS)
      # @param title [String] Title displayed above the sidebar navigation
      def initialize(id:, title: "Settings")
        @id = id
        @title = title
        @items = []
        @item_counter = 0
      end

      # Add a settings item to the component
      #
      # @param title [String] Item title text
      # @param icon [String, nil] Optional Tabler icon name
      # @param active [Boolean] Whether this item is initially active (first item is active by default)
      # @param block [Proc] Content block for the settings panel (stored as proc, captured in template)
      def item(title:, icon: nil, active: nil, &block)
        @item_counter += 1
        item_id = "#{@id}-item-#{@item_counter}"

        # First item is active by default unless explicitly set
        is_active = active.nil? ? @items.empty? : active

        @items << Item.new(
          id: item_id,
          title: title,
          icon: icon,
          active: is_active,
          content: block  # Store the block as a Proc, will be captured in template
        )

        # Return empty string to avoid output in capture context
        ""
      end

      # Check if there are any items
      # @return [Boolean]
      def any?
        @items.any?
      end
    end
  end
end

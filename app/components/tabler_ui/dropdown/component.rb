# frozen_string_literal: true

module TablerUi
  module Dropdown
    # Dropdown component for Tabler UI
    # Provides a dropdown menu with configurable items
    #
    # @example Basic usage
    #   <%= tabler_ui.dropdown label: "Actions" do |dropdown| %>
    #     <% dropdown.item "Edit", edit_path %>
    #     <% dropdown.item "Delete", delete_path, method: :delete %>
    #     <% dropdown.divider %>
    #     <% dropdown.item "Archive", archive_path %>
    #   <% end %>
    class Component
      attr_accessor :label, :items, :button_variant, :align

      def initialize(view_context)
        @items = []
        @button_variant = 'primary'
        @align = 'left'
      end

      # Add a dropdown item
      # @param title [String] Item text
      # @param url [String] Item URL
      # @param options [Hash] Additional options (method:, active:, disabled:, icon:)
      def item(title, url = '#', **options)
        @items << { type: :item, title:, url:, **options }
      end

      # Add a divider
      def divider
        @items << { type: :divider }
      end

      # Add a header
      # @param title [String] Header text
      def header(title)
        @items << { type: :header, title: }
      end
    end
  end
end

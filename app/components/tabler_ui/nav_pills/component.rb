# frozen_string_literal: true

module TablerUi
  module NavPills
    # Link-based pill navigation (Tabler `nav-pills`), optionally inside a card.
    #
    # Unlike the `tabs` component (Bootstrap tab panels with JS), every item is a
    # plain link, which makes it suited for switching between filtered lists,
    # e.g. inside a Turbo Frame.
    #
    # @example
    #   <%= tabler_ui.nav_pills(card: true) do |pills| %>
    #     <% pills.item "Alle", url: documents_path, icon: "files", active: params[:tab].blank?, badge: 242 %>
    #     <% pills.item "Inbox", url: documents_path(tab: "inbox"), icon: "inbox", badge: 12, badge_color: "yellow",
    #                   data: { turbo_frame: "document_list" } %>
    #   <% end %>
    class Component
      Item = Struct.new(:title, :url, :icon, :active, :badge, :badge_color, :data, keyword_init: true)

      attr_reader :items, :card, :custom_class

      # @param card [Boolean] Wrap the pills in a card (default: false)
      # @param custom_class [String, nil] Additional classes for the `ul.nav`
      def initialize(card: false, custom_class: nil)
        @card = card
        @custom_class = custom_class
        @items = []
      end

      # @param title [String] Link text
      # @param url [String] Link target
      # @param icon [String, nil] Tabler icon name
      # @param active [Boolean] Highlight as current item
      # @param badge [String, Integer, nil] Count/label; hidden when nil
      # @param badge_color [String] Badge color (default: "blue")
      # @param data [Hash] data-* attributes of the link (e.g. turbo_frame)
      def item(title, url:, icon: nil, active: false, badge: nil, badge_color: "blue", data: {})
        @items << Item.new(title: title, url: url, icon: icon, active: active, badge: badge,
                           badge_color: badge_color, data: data)
        ""
      end

      def nav_classes
        ["nav", "nav-pills", custom_class].compact.join(" ")
      end

      def any?
        @items.any?
      end
    end
  end
end

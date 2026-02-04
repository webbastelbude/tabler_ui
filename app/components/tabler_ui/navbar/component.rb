# frozen_string_literal: true

module TablerUi
  module Navbar
    # Navbar component for Tabler UI
    # Provides a responsive navigation bar with left/right groups and dropdown support
    #
    # @example Basic usage
    #   <%= tabler_ui.navbar do |navbar| %>
    #     <% navbar.brand = link_to("MyApp", root_path) %>
    #     <% navbar.left do |nav| %>
    #       <% nav.add "Home", root_path, active: true %>
    #       <% nav.add "About", about_path %>
    #     <% end %>
    #   <% end %>
    #
    # @example With dropdown
    #   <%= tabler_ui.navbar do |navbar| %>
    #     <% navbar.left do |nav| %>
    #       <% nav.dropdown "Admin" do |dd| %>
    #         <% dd.add "Users", admin_users_path %>
    #         <% dd.add "Settings", admin_settings_path %>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    class Component
      attr_accessor :brand, :brand_autodark, :items_left, :items_right

      def initialize(brand: nil, brand_autodark: true)
        @brand = brand
        @brand_autodark = brand_autodark
        @items_left = NavigationGroup.new
        @items_right = NavigationGroup.new
      end

      # Yields block to configure left navigation items
      # @yield [NavigationGroup] items_left
      def left(&block)
        yield @items_left if block_given?
      end

      # Yields block to configure right navigation items
      # @yield [NavigationGroup] items_right
      def right(&block)
        yield @items_right if block_given?
      end

      # Navigation group container for menu items
      class NavigationGroup
        include Enumerable

        def initialize
          @items = []
        end

        # Add a simple navigation link
        # @param title [String] Link text
        # @param url [String] Link URL
        # @param options [Hash] Additional options (active:, target:, method:)
        def add(title, url: nil, **options)
          @items << { title:, url:, **options }
        end

        # Add a dropdown menu
        # @param title [String] Dropdown label
        # @yield [DropDownProxy] Dropdown items proxy
        def dropdown(title, align: nil)
          submenu = []
          yield DropDownProxy.new(submenu)
          @items << { title:, submenu:, align: }
        end

        # Add a dark mode toggle button
        def dark_mode_toggle
          @items << { dark_mode_toggle: true }
        end

        # Add a divider (vertical separator)
        def divider
          @items << { divider: true }
        end

        def each(&block)
          @items.each(&block)
        end

        def size
          @items.size
        end

        def count
          @items.count
        end

        def empty?
          @items.empty?
        end

        def [](index)
          @items[index]
        end

        def to_a
          @items
        end

        # Proxy for adding dropdown items
        class DropDownProxy
          def initialize(submenu)
            @submenu = submenu
          end

          # Add dropdown item
          # @param title [String] Link text
          # @param url [String] Link URL
          # @param options [Hash] Additional options
          def add(title, url: nil, **options)
            @submenu << { title:, url:, **options }
          end

          # Add a divider line between dropdown items
          def add_divider
            @submenu << { divider: true }
          end
        end
      end
    end
  end
end

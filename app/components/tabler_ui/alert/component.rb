# frozen_string_literal: true

module TablerUi
  module Alert
    # Alert component for Tabler UI
    # Displays contextual feedback messages
    #
    # @example Basic usage
    #   <%= tabler_ui.alert variant: "success", message: "Your changes have been saved!" %>
    #
    # @example With title and dismissible
    #   <%= tabler_ui.alert variant: "danger", title: "Error", message: "Something went wrong.", dismissible: true %>
    #
    # @example Important alert
    #   <%= tabler_ui.alert variant: "warning", message: "Your trial expires in 3 days.", important: true %>
    #
    # @example With icon
    #   <%= tabler_ui.alert variant: "info", message: "New update available.", icon: "download" %>
    #
    # @example With block content
    #   <%= tabler_ui.alert variant: "success" do %>
    #     <strong>Success!</strong> Your account has been created.
    #   <% end %>
    class Component
      attr_accessor :variant, :title, :message, :icon, :dismissible, :important, :link, :link_text, :custom_class, :content

      # Initialize alert component
      #
      # @param variant [String] Alert variant (success, info, warning, danger, or any Tabler color)
      # @param title [String, nil] Optional alert title
      # @param message [String, nil] Alert message
      # @param icon [String, nil] Optional icon name (Tabler icon)
      # @param dismissible [Boolean] Whether alert can be dismissed (default: false)
      # @param important [Boolean] Use important style with colored background (default: false)
      # @param link [String, nil] Optional link URL
      # @param link_text [String, nil] Link text (default: "Learn more")
      # @param custom_class [String, nil] Additional CSS classes
      def initialize(variant: "info", title: nil, message: nil, icon: nil, dismissible: false, important: false, link: nil, link_text: nil, custom_class: nil)
        @variant = variant
        @title = title
        @message = message
        @icon = icon
        @dismissible = dismissible
        @important = important
        @link = link
        @link_text = link_text || "Learn more"
        @custom_class = custom_class
      end

      # Returns the alert CSS classes
      # @return [String] Combined CSS classes
      def alert_classes
        classes = ["alert", "alert-#{variant}"]
        classes << "alert-dismissible" if dismissible
        classes << "alert-important" if important
        classes << custom_class if custom_class
        classes.join(" ")
      end

      # Returns the default icon for the variant
      # @return [String, nil] Icon name
      def default_icon
        return nil if icon == false
        return icon if icon.is_a?(String)

        case variant
        when "success" then "check"
        when "info" then "info-circle"
        when "warning" then "alert-triangle"
        when "danger" then "alert-circle"
        else nil
        end
      end

      # Check if alert has an icon
      # @return [Boolean]
      def has_icon?
        icon != false && default_icon.present?
      end
    end
  end
end

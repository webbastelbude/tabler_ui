# frozen_string_literal: true

module TablerUi
  module Modal
    # Modal dialog (Bootstrap 5 / Tabler)
    #
    # Opened by any element with data-bs-toggle="modal" data-bs-target="#<id>".
    #
    # @example
    #   <button class="btn" data-bs-toggle="modal" data-bs-target="#install-modal">Installieren</button>
    #
    #   <%= tabler_ui.modal(id: "install-modal", title: "Anwendung installieren", size: :lg) do |modal| %>
    #     <% modal.body do %>
    #       <p>Inhalt, z.B. ein Formular</p>
    #     <% end %>
    #     <% modal.footer do %>
    #       <button class="btn" data-bs-dismiss="modal">Abbrechen</button>
    #       <button class="btn btn-primary" form="install-form">Installieren</button>
    #     <% end %>
    #   <% end %>
    class Component
      SIZES = { sm: "modal-sm", lg: "modal-lg", xl: "modal-xl" }.freeze

      attr_reader :id, :title, :size, :static, :centered, :scrollable, :custom_class, :body_block, :footer_block

      # @param id [String] DOM id, target of data-bs-target
      # @param title [String] Header title
      # @param size [Symbol, nil] :sm, :lg or :xl (default: standard width)
      # @param static [Boolean] Do not close on backdrop click / Escape (use for running operations)
      # @param centered [Boolean] Vertically centered
      # @param scrollable [Boolean] Scroll inside the body for long content
      # @param custom_class [String, nil] Additional classes for .modal
      def initialize(id:, title:, size: nil, static: false, centered: false, scrollable: false, custom_class: nil)
        @id = id
        @title = title
        @size = size&.to_sym
        @static = static
        @centered = centered
        @scrollable = scrollable
        @custom_class = custom_class
      end

      def body(&block)
        @body_block = block
        ""
      end

      def footer(&block)
        @footer_block = block
        ""
      end

      def dialog_classes
        classes = ["modal-dialog"]
        classes << SIZES[size] if size && SIZES[size]
        classes << "modal-dialog-centered" if centered
        classes << "modal-dialog-scrollable" if scrollable
        classes.join(" ")
      end

      def modal_classes
        ["modal", "modal-blur", "fade", custom_class].compact.join(" ")
      end
    end
  end
end

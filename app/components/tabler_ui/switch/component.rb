# frozen_string_literal: true

module TablerUi
  module Switch
    # Toggle-Schalter (Tabler "form-switch").
    #
    #   <%= tabler_ui.switch name: "user[active]", checked: @user.active?, label: "Aktiv" %>
    #
    # Mit `url:` wird der Schalter in ein eigenes Formular gepackt, das beim Umlegen
    # automatisch abgeschickt wird (Stimulus `tabler-ui--switch`):
    #
    #   <%= tabler_ui.switch name: "domain[disabled]", checked: !domain.disabled?,
    #                        value: "0", unchecked_value: "1",
    #                        url: toggle_path, method: :patch, label: "Aktiv" %>
    class Component
      attr_reader :name, :checked, :label, :description, :value, :unchecked_value,
                  :id, :disabled, :url, :http_method, :title, :custom_class

      # @param name [String] Feldname (z.B. "domain[disabled]")
      # @param checked [Boolean] Schalter an?
      # @param label [String, nil] Beschriftung rechts neben dem Schalter
      # @param description [String, nil] Zusatztext unter der Beschriftung
      # @param value [String] gesendeter Wert bei "an"
      # @param unchecked_value [String, nil] gesendeter Wert bei "aus" (Hidden-Feld); nil = nichts senden
      # @param id [String, nil] DOM-ID der Checkbox
      # @param disabled [Boolean] Schalter sperren
      # @param url [String, nil] wenn gesetzt: eigenes Formular, das beim Umlegen abgeschickt wird
      # @param method [Symbol] HTTP-Methode des Formulars (Standard :patch)
      # @param title [String, nil] Tooltip
      # @param class [String, nil] zusätzliche CSS-Klassen am Label
      def initialize(name:, checked: false, label: nil, description: nil, value: "1", unchecked_value: "0",
                     id: nil, disabled: false, url: nil, method: :patch, title: nil, class: nil)
        @name = name
        @checked = checked ? true : false
        @label = label
        @description = description
        @value = value
        @unchecked_value = unchecked_value
        @id = id || "switch-#{SecureRandom.hex(4)}"
        @disabled = disabled
        @url = url
        @http_method = method
        @title = title
        @custom_class = binding.local_variable_get(:class)
      end

      def auto_submit?
        url.present?
      end

      def label_classes
        ["form-check", "form-switch", custom_class].compact_blank.join(" ")
      end

      def input_data
        auto_submit? ? { action: "change->tabler-ui--switch#submit" } : {}
      end
    end
  end
end

# frozen_string_literal: true

module TablerUi
  module Helper
    # Returns an instance of the TablerUi::Ui class for rendering components
    #
    # @return [TablerUi::Ui] UI component renderer instance
    #
    # @example Using the navbar component
    #   <%= tabler_ui.navbar do |navbar| %>
    #     <% navbar.left do |nav| %>
    #       <% nav.add "Home", root_path %>
    #     <% end %>
    #   <% end %>
    def tabler_ui
      @tabler_ui ||= TablerUi::Ui.new(self)
    end
  end
end

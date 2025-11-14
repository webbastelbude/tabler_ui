# frozen_string_literal: true

require_relative "tabler_ui/version"
require_relative "tabler_ui/engine" if defined?(Rails)
require_relative "tabler_ui/helper"
require_relative "tabler_ui/ui"

module TablerUi
  class Error < StandardError; end
end

# frozen_string_literal: true

module TablerUi
  class Engine < ::Rails::Engine
    isolate_namespace TablerUi

    config.autoload_paths << root.join("app/components")

    initializer "tabler_ui.assets" do |app|
      # Add assets to the asset pipeline
      app.config.assets.paths << root.join("app/assets/stylesheets")
      app.config.assets.paths << root.join("app/assets/javascripts")
      app.config.assets.precompile += %w[tabler_ui.css tabler_ui.js tabler_ui/tabler.css tabler_ui/tabler.js]
    end

    # Load importmap configuration for JavaScript modules
    initializer "tabler_ui.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
      end
    end

    initializer "tabler_ui.view_paths" do
      # Make components directory available as view path
      ActiveSupport.on_load(:action_controller_base) do
        prepend_view_path(TablerUi::Engine.root.join("app/components"))
      end

      ActiveSupport.on_load(:action_mailer) do
        prepend_view_path(TablerUi::Engine.root.join("app/components"))
      end
    end

    initializer "tabler_ui.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        helper TablerUi::Helper
      end

      ActiveSupport.on_load(:action_mailer) do
        helper TablerUi::Helper
      end
    end
  end
end

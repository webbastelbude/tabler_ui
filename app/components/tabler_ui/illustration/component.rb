# frozen_string_literal: true

module TablerUi
  module Illustration
    class Component
      SIZES = {
        xs: 100,
        sm: 150,
        md: 200,
        lg: 300,
        xl: 400,
        xxl: 600
      }.freeze

      def initialize(name:, variant: nil, size: nil, class: nil)
        @name = name
        @variant = variant
        @size = size
        @custom_class = binding.local_variable_get(:class)
      end

      def illustration_data
        if @name.blank?
          draw_error_illustration
          return
        end

        variant = @variant || "light"

        # Erst im Gem-Verzeichnis suchen, dann in der App
        gem_illustration_path = File.expand_path("../../../assets/illustrations/#{variant}/#{@name}.svg", __dir__)
        app_illustration_path = Rails.root.join("app", "assets", "illustrations", variant, "#{@name}.svg")

        illustration_path = if File.exist?(gem_illustration_path)
                              gem_illustration_path
                            elsif File.exist?(app_illustration_path)
                              app_illustration_path
                            else
                              nil
                            end

        if illustration_path && File.exist?(illustration_path)
          data = File.read(illustration_path)
          data = apply_size(data)
          data = add_custom_class(data)
          data
        else
          draw_error_illustration
        end
      end

      private

      def apply_size(data)
        return data unless @size.present?

        size_value = SIZES[@size.to_sym] || @size.to_i

        if data =~ /viewBox="0 0 (\d+) (\d+)"/
          orig_width = $1.to_f
          orig_height = $2.to_f
          new_height = (size_value * orig_height / orig_width).round
          data = data.gsub(/width="[^"]*"/, "width=\"#{size_value}\"")
          data = data.gsub(/height="[^"]*"/, "height=\"#{new_height}\"")
        end

        data
      end

      def add_custom_class(data)
        return data unless @custom_class.present?

        if data =~ /class="([^"]*)"/
          data.gsub(/class="([^"]*)"/, "class=\"\\1 #{@custom_class}\"")
        else
          data.gsub(/<svg/, "<svg class=\"#{@custom_class}\"")
        end
      end

      def draw_error_illustration
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" width="200" height="150" viewBox="0 0 200 150" class="illustration-error">
            <rect width="200" height="150" fill="#f8d7da" rx="8"/>
            <text x="100" y="70" text-anchor="middle" fill="#721c24" font-size="14">Illustration</text>
            <text x="100" y="90" text-anchor="middle" fill="#721c24" font-size="14">nicht gefunden</text>
            <text x="100" y="115" text-anchor="middle" fill="#721c24" font-size="12" opacity="0.7">#{@name || 'unbekannt'}</text>
          </svg>
        SVG
      end
    end
  end
end

module TablerUi
  module Icon
    class Component
      def initialize(icon:, filled: false, color: nil, pulse: false, tada: false, rotate: false, size: nil, class: nil)
        @icon = icon
        @filled = filled
        @color = color
        @pulse = pulse
        @tada = tada
        @rotate = rotate
        @size = size
        @custom_class = binding.local_variable_get(:class)
      end

      def icon_data
        if @icon.blank?
          draw_error_icon
          return
        end

        variant = @filled.blank? ? "outline" : "filled"

        icon_path = Rails.root.join("app", "assets", "icons", variant, "#{@icon}.svg")

        if File.exist?(icon_path)
          data = File.read(icon_path)
          data = add_animation_classes(data)

          if @color
            "<span class=\"text-#{@color}\">#{data}</span>"
          else
            data
          end
        else
          draw_error_icon
        end
      end

      private

      def add_animation_classes(data)
        data = data.gsub(/(class="([a-zA-Z -]*))/) { |s| s + ' icon-pulse' } if @pulse
        data = data.gsub(/(class="([a-zA-Z -]*))/) { |s| s + ' icon-tada' } if @tada
        data = data.gsub(/(class="([a-zA-Z -]*))/) { |s| s + ' icon-rotate' } if @rotate
        data = data.gsub(/(class="([a-zA-Z -]*))/) { |s| s + " icon-#{@size}" } if @size.present?
        data = data.gsub(/(class="([a-zA-Z -]*))/) { |s| s + " #{@custom_class}" } if @custom_class.present?
        data
      end

      def draw_error_icon
        '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="red" stroke-width="3"
  stroke-linecap="round" stroke-linejoin="round" class="icon icon-tabler icons-tabler-outline icon-tabler-bug icon-tada"><path stroke="none" d="M0
  0h24v24H0z" fill="none"/><path d="M9 9v-1a3 3 0 0 1 6 0v1" /><path d="M8 9h8a6 6 0 0 1 1 3v3a5 5 0 0 1 -10 0v-3a6 6 0 0 1 1 -3" /><path d="M3 13l4 0"
  /><path d="M17 13l4 0" /><path d="M12 20l0 -6" /><path d="M4 19l3.35 -2" /><path d="M20 19l-3.35 -2" /><path d="M4 7l3.75 2.4" /><path d="M20 7l-3.75
  2.4" /></svg>'
      end
    end
  end
end
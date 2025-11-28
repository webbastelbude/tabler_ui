module TablerUi
  module Datagrid
    class Component
      attr_reader :items

      def initialize(items: [])
        @items = items
      end

      def item(title, content = nil, &block)
        @items << {
          title: title,
          content: content,
          block: block
        }
      end

      def has_items?
        @items.any?
      end
    end
  end
end

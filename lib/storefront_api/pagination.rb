module StorefrontAPI
  class Pagination < Array
    def initialize(connection, class_name = nil)
      entries = connection.edges.to_a
      if class_name
        entries.map! do |entry|
          class_name.new(entry)
        end
      end

      super(entries)
      @page_info = connection.try(:page_info)
    end

    def has_next_page?
      !!@page_info.try(:has_next_page)
    end

    def last_cursor
      last.cursor
    end

    def has_previous_page?
      !!@page_info.try(:has_previous_page)
    end

    def first_cursor
      first.cursor
    end
  end
end

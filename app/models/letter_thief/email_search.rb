module LetterThief
  class EmailSearch
    PAGE_SIZE = 20

    attr_reader :query, :start_time, :end_time, :page, :total_count, :results, :has_next_page

    def initialize(params)
      @query = params[:query].to_s.strip
      @start_time = params[:start_time]
      @end_time = params[:end_time]
      @page = params[:page].to_i
      @page = 1 if @page < 1
    end

    def perform
      scope = EmailMessage.order(intercepted_at: :desc)

      if query.present?
        adapter = ActiveRecord::Base.connection.adapter_name.downcase
        scope = if adapter.include?("postgresql")
          scope.where(<<~SQL.squish, q: "%#{query}%")
            subject ILIKE :q
            OR array_to_string("from", ',') ILIKE :q
            OR array_to_string("to", ',') ILIKE :q
          SQL
        elsif adapter.include?("mysql")
          scope.where("`subject` LIKE :q OR `from` LIKE :q OR `to` LIKE :q", q: "%#{query}%")
        else
          scope.where('subject LIKE :q OR "from" LIKE :q OR "to" LIKE :q', q: "%#{query}%")
        end
      end

      scope = scope.where("intercepted_at >= ?", parse_datetime(start_time)) if start_time.present?
      scope = scope.where("intercepted_at <= ?", parse_datetime(end_time)) if end_time.present?

      @total_count = scope.count
      @results = scope.limit(PAGE_SIZE).offset((page - 1) * PAGE_SIZE)
      @has_next_page = total_count > page * PAGE_SIZE
      self
    end

    private

    def parse_datetime(value)
      Time.zone.parse(value) if value.present?
    rescue ArgumentError
      nil
    end
  end
end

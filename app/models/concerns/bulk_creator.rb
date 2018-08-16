module BulkCreator

  extend ActiveSupport::Concern

  module ClassMethods
    def bulk_create(columns, values, *args)
      records_to_create(values, args).each_slice(500) do |records|
        self.connection.execute bulk_insert_sql(columns, records)
      end
    end

    def bulk_insert_sql(columns, records)
      columns += [:created_at, :updated_at]
      <<-SQL
        INSERT INTO #{self.table_name} (#{columns.join(", ")})
        VALUES #{records.join(', ')}
      SQL
    end

    def records_to_create(values, *args)
      values.map do |value|
        "(#{value}, #{args.join(", ")}, '#{Time.current}', '#{Time.current}')"
      end
    end
  end

end

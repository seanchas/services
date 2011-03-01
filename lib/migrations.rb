module ActiveRecord
  module ConnectionAdapters
    module SchemaStatements
  
      def initialize_schema_migrations_table_with_table_prefixes
        ActiveRecord::Base.class_eval { def self.table_name_prefix; ""; end }
        initialize_schema_migrations_table_without_table_prefixes
      end
      
      alias_method_chain :initialize_schema_migrations_table, :table_prefixes
      
    end
  end
end

#!/usr/local/bin/ruby
# $Id$

class DBBase
   @klass = nil
   begin
      require "dbi"
      @klass = DBI
   rescue LoadError
      require "sqlite3"
      @klass = SQLite
   end

   class DBI < DBBase
      def initialize(dbname)
         @db = @klass.connect(dbname)
      end
   end
   class SQLite < DBBase
      def initialize(dbname)
         @db = @klass.new(dbname)
      end
   end
end

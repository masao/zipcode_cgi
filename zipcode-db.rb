#!/usr/local/bin/ruby
# $Id$

class ZipcodeDB
   def initialize(klass, dbname)
      @klass = klass
      if @klass.name == "DBI"
         @db = @klass.connect(dbname)
      elsif @klass.name == "SQLite3::Database"
         @db = @klass.new(dbname)
      else
         raise "unknown dbtype: #{klass}"
      end
   end
   def method_missing( name, args = nil )
      if @db.respond_to?(name)
         if args.nil?
            @db.send(name)
         else
            @db.send(name, args)
         end
      else
         raise NameError::new("method_missing: #{name}: #{args}")
      end
   end
end

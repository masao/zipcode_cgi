#!/usr/local/bin/ruby
# $Id$

class ZipcodeDB
   def initialize(klass, dbname)
      @klass = klass
      if @klass == DBI
         @db = @klass.connect(dbname)
      elsif @klass == SQLite3
         @db = @klass.new(dbname)
      end
   end
   def method_missing( name, args )
      if @db.respond_to(:name)
         @db.send(:name, args)
      else
         raise NameError
      end
   end
end

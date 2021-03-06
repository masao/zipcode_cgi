#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-
#
# 使い方：
# nkf -Se ken_all.csv | ruby zipcode-mkdb.rb

# Data from: http://www.post.japanpost.jp/zipcode/download.html

require 'fileutils'
require 'rubygems'
begin
   $:.unshift(ENV["HOME"] + "/lib/ruby")
   require 'sqlite3'
rescue LoadError
   require 'dbi'
end

Encoding.default_external = "utf-8" if defined? Encoding

DBNAME = "zipcode.db"
DBNAME_TMP = DBNAME + ".tmp"
FileUtils.rm_f(DBNAME_TMP) if FileTest.exist? DBNAME_TMP

CREATE_TABLE = <<EOF
CREATE TABLE zipcode (
       zipcode7	  TEXT,
       pref	  TEXT,
       city	  TEXT,
       city_yomi  TEXT,
       town	  TEXT,
       town_yomi  TEXT
       );
EOF

if FileTest.exist? DBNAME
   FileUtils.cp(DBNAME, DBNAME + ".old")
end

#dbh = DBI.connect("dbi:SQLite:#{DBNAME_TMP}")	# For DBI
#dbh['AutoCommit'] = false
dbh = SQLite3::Database.new(DBNAME_TMP)		# For SQLite3

dbh.transaction do
   #dbh.do(CREATE_TABLE)	# For DBI
   dbh.execute(CREATE_TABLE)	# For SQLite3
   sth = dbh.prepare("INSERT INTO zipcode VALUES(?, ?, ?, ?, ?, ?)");
   logfile = open("zipcode.log.#{Time.now.strftime("%Y%m%d")}", "w")
   ARGF.each_line do |line|
      data = line.split(/,/).map{|e| e.sub(/^\"(.*)\"$/, '\1'); }
      sth.execute(data[2], data[6], data[7], data[4], data[8], data[5]);
      logfile.puts [ data[2], data[6], data[7], data[8] ].join(" ")
   end
   logfile.close
end

FileUtils.mv(DBNAME_TMP, DBNAME)

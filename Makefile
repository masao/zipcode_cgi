all:
	@echo type \"make dist\"

DIST_FILES = README AUTHORS zipcode-db.rb zipcode-mkdb.rb zipcode.rb zipcode.rhtml
NAME = 	zipcode_cgi
VERSION=$(shell ruby -r./zipcode -e "print ZIPCODECGI_VERSION")
dist_dir = $(NAME)-$(VERSION)

dist:
	rm -rf $(dist_dir)
	mkdir $(dist_dir)
	cp -p $(DIST_FILES) $(dist_dir)
	tar zcvf $(dist_dir).tar.gz $(dist_dir)
	rm -rf $(dist_dir)

build:
	gem build vent.gemspec

install:
	gem install vent-*.gem

fury:
	git push fury master

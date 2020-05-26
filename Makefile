build:
	gem build vent.gemspec

install:
	gem install vent-*.gem

fury:
	git push fury master

.PHONY: examples
examples:
	@bundle exec ruby examples/wisper.rb

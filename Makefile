default: check

include disk_space_usage/Tasks.mk

.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

install: disk_space_usage/install

check: disk_space_usage/format disk_space_usage/check-cycles disk_space_usage/test

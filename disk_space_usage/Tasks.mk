.PHONY: disk_space_usage/install disk_space_usage/check

disk_space_usage/install:
	cd disk_space_usage; flutter pub get

disk_space_usage/check:
	cd disk_space_usage; dart format lib --line-length 100 --set-exit-if-changed
	cd disk_space_usage; flutter test
	cd disk_space_usage; dart run cyclic_dependency_checks

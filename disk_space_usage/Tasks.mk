disk_space_usage/install:
	cd disk_space_usage; flutter pub get

disk_space_usage/format:
	cd disk_space_usage; dart format lib --line-length 100 --set-exit-if-changed

disk_space_usage/test:
	cd disk_space_usage; flutter test

disk_space_usage/check-cycles:
	cd disk_space_usage; dart run cyclic_dependency_checks .

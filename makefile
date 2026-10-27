gen:
	dart run build_runner build

hello:
	echo "Hi!"; \
	echo "How are u?!"; \
	echo ":)";

icon:
	dart run flutter_launcher_icons

init_res:
	dart pub global activate flutter_asset_generator

format:
	dart format . --line-length 100

res:
	dart pub global run flutter_asset_generator:asset_generator --output lib/components/resources.g.dart --no-watch --no-preview
	dart format . --line-length 100

loc:
	flutter gen-l10n
	dart format . --line-length 100

#!/usr/bin/env bash
set -eu

FLUTTER_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/flutter-sdk.XXXXXX")"
trap 'rm -rf "$FLUTTER_ROOT"' EXIT
git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_ROOT"

export PATH="$FLUTTER_ROOT/bin:$PATH"
flutter config --no-analytics
flutter pub get
flutter build web --release

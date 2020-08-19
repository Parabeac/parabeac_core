#!/bin/sh

SKETCH=$(mdfind kMDItemCFBundleIdentifier=='com.bohemiancoding.sketch3' | head -n 1)

# pass on all given arguments
"$SKETCH/Contents/MacOS/sketchtool" "$@"
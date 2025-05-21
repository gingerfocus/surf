#!/bin/sh

case "$1" in
    "run" | "r") 
        # GDK_BACKEND=x11 ./zig-out/bin/surf https://example.com
        ./zig-out/bin/surf https://example.com
        ;;
    "build" | "b")
        zig build -Drelease-fast
        ;;
    "test" | "t")
        echo "TODO"
        ;;
    "" | *)
        echo "Usage: $0 {run|build}"
        exit 1
        ;;

esac

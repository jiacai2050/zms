#!/usr/bin/env bash

set -Eeuo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

nohup ${script_dir}/../zig-out/bin/zms &

sleep 5

fa=/tmp/a
fb=/tmp/b

curl -o ${fa} 0:9090/zig-macos-aarch64-0.12.0.tar.xz &

sleep 5

curl -o ${fb} 0:9090/zig-macos-aarch64-0.12.0.tar.xz

sleep 5

# Calculate MD5 hashes
md5_a=$(md5sum "$fa" | awk '{print $1}')
md5_b=$(md5sum "$fb" | awk '{print $1}')

# Compare hashes
if [ "$md5_a" == "$md5_b" ]; then
    echo "The files are identical."
else
    echo "The files are different. md5_a: $md5_a, md5_b: $md5_b"
    exit 1
fi

#!/usr/bin/env bash

out_dir="/tmp/zms-release/"
version=${RELEASE_VERSION:-unknown}

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT
cleanup() {
 trap - SIGINT SIGTERM ERR EXIT
 ls -ltrh "${out_dir}"
 rm -rf "${out_dir}/*"
}

mkdir -p "${out_dir}"
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

cd "${script_dir}/.."

targets=(
  "aarch64-linux"
  "x86_64-linux"
  "x86-linux"
  "aarch64-macos"
  "x86_64-macos"
  "x86_64-windows"
)

for target in "${targets[@]}"; do
  echo "Building for ${target}..."
  zig build -Doptimize=ReleaseSafe -Dtarget="${target}"
  if [[ "${target}" == "x86_64-windows" ]]; then
    mv zig-out/bin/zms.exe "${out_dir}/zms-${version}-${target}.exe"
    continue
  fi

  mv zig-out/bin/zms "${out_dir}/zms-${version}-${target}"
done

#!/usr/bin/env bash
# Install Shot Loader's xStudio preference definition next to the application.
# This script resolves paths from its own location, not the caller's cwd.

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source_file="${script_dir}/pref/plugin_shot_loader.json"
preference_dir="$(cd -- "${script_dir}/../.." && pwd -P)/preference"
destination_file="${preference_dir}/plugin_shot_loader.json"

if [[ ! -f "${source_file}" ]]; then
    printf 'Shot Loader preference file not found: %s\n' "${source_file}" >&2
    exit 1
fi

if [[ ! -d "${preference_dir}" ]]; then
    printf 'xStudio preference directory not found: %s\n' "${preference_dir}" >&2
    exit 1
fi

cp -- "${source_file}" "${destination_file}"
printf 'Installed Shot Loader preferences: %s\n' "${destination_file}"

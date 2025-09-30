#
# MIT License
#
# Copyright (c) 2021-2025 Tony Walker
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# Global defaults
BASE_IMAGE="docker.io/library/debian"
DEBIAN_VERSION="latest"
WINE_SOURCE="debian"
IMAGE_NAME="wine_container"
HOME_VOLUME="wine_volume"
COMMAND_LINE="/bin/bash"

display_help_footer() {
    echo ""
    echo "For more information, see: https://github.com/user/wine-container"
}

set_volume_permissions() {
    local volume_name="$1"
    local volume_path
    volume_path=$(podman volume inspect "$volume_name" --format '{{.Mountpoint}}' 2>/dev/null)
    if [ -n "$volume_path" ] && [ -d "$volume_path" ]; then
        if ! chmod u+rwx "$volume_path" 2>/dev/null; then
            echo "Warning: Failed to set permissions on $volume_path (this may be expected on some systems)" >&2
        fi
    else
        echo "Warning: Could not determine or access volume path for $volume_name" >&2
    fi
}

ensure_volume_exists() {
    local volume_name="$1"
    if ! podman volume exists "$volume_name" 2>/dev/null; then
        echo "* Creating volume $volume_name..."
        podman volume create "$volume_name" || {
            echo "Error: Failed to create volume $volume_name" >&2
            return 1
        }
        set_volume_permissions "$volume_name"
    fi
}

#!/bin/sh
set -eu

# If you mount /config/config.json, we copy it into the web root so FluffyChat can fetch it.
# Example: -v ./fluffychat/config.json:/config/config.json:ro
if [ -f /config/config.json ]; then
  cp /config/config.json /usr/share/nginx/html/config.json
fi

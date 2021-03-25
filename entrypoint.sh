#!/bin/bash
set -e
# Remove potential running server
rm -f /myapp/tmp/pids/*.pid
# exec servers main process
exec "$@"

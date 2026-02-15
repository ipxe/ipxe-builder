#!/bin/sh

# GitHub Actions does not (yet) allow for specifying a command for a
# service container.  Work around this by allowing pcscd to be invoked
# by passing a non-empty environment variable "RUN_PCSCD".
#
if [ -n "${RUN_PCSCD}" ] ; then
    rm -f /run/pcscd/pcscd.comm
    exec /usr/bin/pcscd --foreground --disable-polkit
fi

exec "$@"

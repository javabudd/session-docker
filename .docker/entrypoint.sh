#!/bin/bash

if [ -f "/etc/oxen/oxen_template.conf" ]; then
  envsubst < /etc/oxen/oxen_template.conf > /etc/oxen/oxen.conf
fi

if [ -f "/etc/oxen/storage_template.conf" ]; then
  envsubst < /etc/oxen/storage_template.conf > /etc/oxen/storage.conf
fi

if [ -f "/etc/loki/lokinet-router_template.ini" ]; then
  envsubst < /etc/loki/lokinet-router_template.ini > /etc/loki/lokinet-router.ini
fi

exec "$@"
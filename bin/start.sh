#!/bin/bash
source /run/flannel/subnet.env
exec supervisord -c /etc/supervisord.conf

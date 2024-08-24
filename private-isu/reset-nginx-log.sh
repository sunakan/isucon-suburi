#!/bin/bash

rm -rf /var/log/nginx/*.log
systemctl reload nginx

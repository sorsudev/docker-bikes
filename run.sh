#!/bin/sh

ls
cd api_code && node run_migrations.js &
node server.js


#!/bin/bash

echo "Remove existed container"
cd /home/ubuntu/deploy
docker-compose -f docker-compose.yml down || true

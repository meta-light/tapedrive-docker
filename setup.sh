#!/bin/bash

echo "Setting up Tapedrive Docker service..."

mkdir -p data config logs

echo "Building Docker image..."
docker-compose build

echo "Starting Tapedrive service..."
docker-compose up -d

echo "Service status:"
docker-compose ps

echo "To view logs:"
echo "docker-compose logs -f tapedrive"

echo "To stop the service:"
echo "docker-compose down"

echo "To restart the service:"
echo "docker-compose restart"

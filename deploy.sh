#!/bin/bash

# Configuration
SERVER="archie@45.79.23.144"
REMOTE_PATH="/var/www/welledumacated" # Adjust this to your Nginx root
BUILD_PATH="build/web"

echo "🚀 Building Flutter Web..."
flutter build web --release

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    echo "📤 Uploading to server..."
    # Create the remote directory if it doesn't exist
    ssh $SERVER "sudo mkdir -p $REMOTE_PATH && sudo chown -R archie:archie $REMOTE_PATH"
    
    # Sync files
    rsync -avz --delete $BUILD_PATH/ $SERVER:$REMOTE_PATH/
    
    echo "✨ Deployment complete!"
    echo "🔗 Visit your site at https://welledumacated.dev"
else
    echo "❌ Build failed. Please check errors above."
    exit 1
fi

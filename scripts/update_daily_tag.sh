#!/bin/bash

# Get today's date and timestamp
TODAY=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%H%M)
TAG_NAME="winr-$TODAY-$TIMESTAMP"

# Create new signed tag
echo "Creating new signed tag: $TAG_NAME"
git tag -s $TAG_NAME -m "Daily snapshot: $(date)"
git push origin $TAG_NAME

# Delete tags older than today (preserve today's tags)
echo "Removing tags from previous days..."
for tag in $(git tag -l "winr-*"); do
    if [[ $tag != winr-$TODAY* ]]; then
        echo "Deleting old tag: $tag"
        git tag -d $tag
        git push origin :refs/tags/$tag
    fi
done

echo "Tag management complete. Keeping all of today's tags."
echo "Current tags:"
git tag -l "winr-$TODAY*"
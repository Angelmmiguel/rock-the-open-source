#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"

# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo "Skipping deploy; just doing a build."
    exit 0
fi

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

# Config git
git config --global user.name "Travis CI"
git config --global user.email "bot@rock-the-open-source.com"
git config --global push.default simple

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
openssl aes-256-cbc -K $encrypted_7b3bd922f0aa_key -iv $encrypted_7b3bd922f0aa_iv -in deploy.enc -out deploy -d
chmod 600 deploy
eval `ssh-agent -s`
ssh-add deploy

# Clone the existing gh-pages for this repo into out/
# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deploy)
git clone $SSH_REPO out
cd out
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
cd ..

# Clean out existing contents
rm -rf out/* || exit 0

# Now that we're all set up, we can run the publish script
cp -a ./build/. ./out/
cd out

# Create the commit and push!
if git diff --quiet; then
    echo "No changes to the output on this push; exiting."
    exit 0
fi

echo "Publishing new changes"
git add -A
current=$(date +"%m_%d_%Y")
git commit -m "Publishing new changes ($current)"
# Push
git push $SSH_REPO $TARGET_BRANCH
echo "All the changes has been published"

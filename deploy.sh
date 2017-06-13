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

# Clone the existing gh-pages for this repo into out/
# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deploy)
git clone $REPO out
cd out
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
cd ..

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
openssl aes-256-cbc -K $encrypted_7b3bd922f0aa_key -iv $encrypted_7b3bd922f0aa_iv -in deploy.enc -out deploy -d
chmod 600 deploy
eval `ssh-agent -s`
ssh-add deploy

# Now that we're all set up, we can run the publish script
cp -r ./build/* out
cd out

# Create the commit and push!
if git diff-index --quiet HEAD --; then
  echo "No changes to push"
else
  echo "Publishing new changes"
  git add -A
  now=$(date +"%m_%d_%Y")
  git commit -m "Publishing new changes ($now)"

  # Configure git
  git config user.name "Travis CI"
  git config user.email "bot@rock-the-open-source.com"

  # Push
  git push
  echo "All the changes has been pubhlised"
fi

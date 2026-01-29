#!/bin/bash

# Elegant SDDM Theme - Maintainer Script

set -e # Exit on error

echo "🚀 Starting Automated Release..."

# Commit pending changes
if [[ -n $(git status -s) ]]; then
    echo "📦 Committing changes..."
    git add .
    git commit -m "chore: update theme" || echo "Nothing to commit?"
else
    echo "✨ Working tree clean."
fi

# Update version
echo "🔄 Calculating version..."
_count=$(git rev-list --count HEAD)
_hash=$(git rev-parse --short HEAD)
_pkgver="1.2.0.r${_count}.g${_hash}"

echo "   New Version: ${_pkgver}"
sed -i "s/^pkgver=.*/pkgver=${_pkgver}/" pkg/PKGBUILD

# Update .SRCINFO
echo "📄 Updating .SRCINFO..."
cd pkg
makepkg --printsrcinfo > .SRCINFO
# Sync .SRCINFO pkgver
grep -q "pkgver = " .SRCINFO && sed -i "s/^	pkgver = .*/	pkgver = ${_pkgver}/" .SRCINFO
cd ..

# Commit release
echo "📝 Committing release..."
git add pkg/PKGBUILD
git commit -m "chore: release version ${_pkgver}" || echo "Version already committed."

# Push to remotes
echo "☁️ Pushing to remotes..."
git push origin main
git push gitlab main

echo "✅ Done! All remotes synced."
echo "   Don't forget to push to AUR!"

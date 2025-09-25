#!/bin/bash
#flutter build web --release
mkdir "web_release"
cp -r build/web/* web_release
git add web_release
git commit -m "Deploy to GitHub Pages"
#git subtree push --prefix build/web main gh-pages
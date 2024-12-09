#!/bin/bash
flutter build web --release
git subtree push --prefix build/web origin gh-pages
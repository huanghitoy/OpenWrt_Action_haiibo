#!/bin/bash
REPO_URL="https://github.com/huanghitoy/openwrt"
REPO_BRANCH="v21.02.7"
git clone -b $REPO_BRANCH $REPO_URL $REPO_BRANCH
cd $REPO_BRANCH
./scripts/feeds update -a
./scripts/feeds install  -a

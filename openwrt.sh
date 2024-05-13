#!/bin/bash
REPO_URL="https://github.com/huanghitoy/openwrt"
REPO_BRANCH="openwrt-21.02"
git clone -b $REPO_BRANCH --depth=1 $REPO_URL $REPO_BRANCH
cd $REPO_BRANCH

./scripts/feeds update -a
./scripts/feeds install  -a

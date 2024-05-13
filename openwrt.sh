#!/bin/bash

git clone -b v21.02.7 https://github.com/huanghitoy/openwrt openwrt_21.02
cd openwrt_21.02
./scripts/feeds update -a
./scripts/feeds install  -a

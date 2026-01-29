#!/bin/sh
swift run -c release  FuzzilliCli  --storagePath=../out --jobs=32 --profile=duktape ../duktape-2.3.0/duk-fuzzilli

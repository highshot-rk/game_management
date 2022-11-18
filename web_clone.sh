#!/bin/bash
bundle install --without development test --jobs 3
script/web

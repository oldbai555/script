#!/bin/bash

sed -i 's/\r//' .env
export $(xargs <.env)
# source .env
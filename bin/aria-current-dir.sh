#!/bin/bash

cd "$(dirname "${1}")" || return 1
aria2c "${1}"

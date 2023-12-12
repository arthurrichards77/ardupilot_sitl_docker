#!/bin/bash
getent ahostsv4 $1 | head -1 | awk '{print $1}'
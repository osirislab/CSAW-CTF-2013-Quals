#!/bin/bash
#takes port as argument
socat -v TCP-LISTEN:$1,reuseaddr,fork EXEC:./miteegashun

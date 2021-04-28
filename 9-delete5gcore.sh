#!/usr/bin/env bash
#Author: fenar
echo -e "World is About to End!....\n"
echo
cd 5gcore-helm
echo "Removing Open5Gs"
helm -n open5gcore uninstall 5gcore
echo "The End"

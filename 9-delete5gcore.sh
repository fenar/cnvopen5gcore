#!/usr/bin/env bash
#Author: fenar
echo -e "World is About to End!....\n"
echo
cd 5gcore-helm
echo "Removing Open5Gs"
helm uninstall 5gcorenew
echo "The End"

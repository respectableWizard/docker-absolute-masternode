#!/bin/sh

set -e

#  Absolute Masternode docker template
#  Copyright © 2019 comozo
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

GIT_INFO=$(curl -sL "https://api.github.com/repos/absolute-community/absolute/releases/latest")

# Need to make sure I'm getting the right version
URL=$(printf "%s\n" "$GIT_INFO" | jq .assets[].browser_download_url -r | grep x86_64-linux | grep -v qt)

if [ -f "./limits.conf" ]; then 
    if grep "NODE_BINARY=" "./limits.conf"; then 
        NODE_BINARY=$(grep "NODE_BINARY=" "./limits.conf" | sed 's/NODE_BINARY=//g')
        if [ -n "$NODE_BINARY" ] && [ ! "$NODE_BINARY" = "auto" ]; then
            URL=$NODE_BINARY
        fi
    fi
fi

FILE=absolute

case "$URL" in
    *.tar.gz) 
        curl -L "$URL" -o "./$FILE.tar.gz"
        tar -xzvf "./$FILE.tar.gz"
        rm -f "./$FILE.tar.gz"
    ;;
    *.zip)
        curl -L "$URL" -o "./$FILE.zip"
        unzip "./$FILE.zip"
        rm -f "./$FILE.zip"
    ;;
esac

mv -f "$(find . -name absoluted)" /usr/local/bin
mv -f "$(find . -name absolute-cli)" /usr/local/bin

mv ./$FILE* /tmp

printf "%s" "$(printf "%s" "$GIT_INFO" | jq .tag_name -r | sed 's\v\\')" > ./version

exit 0
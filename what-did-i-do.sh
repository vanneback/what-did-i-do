#!/bin/bash
set -e
DATE=$1
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
DIR="$(dirname "$(readlink -f "$BASH_SOURCE")")"

usage () {
  echo "ERROR: <$DATE> is not a date"
  echo "Usage: $0 yyyy-mm-dd"
  exit 1
}

search_dir () {
  echo -e "${GREEN}\n*******************************************"
  echo "Searching basedir $1"
  echo -e "*******************************************${NC}"

  dir_list=`find $1 -name ".git" | xargs dirname`
  for dir in $dir_list; do
    echo "Searching subdir $dir"
    echo "------------------------------------"
    cd $dir
    git log --author="Emil Vannebäck" --after="${DATE} 00:00" --before="${DATE} 23:59"
  done
}

if [[ -z "$DATE" ]]; then usage; fi

date -d "$DATE" || {
  usage
}
echo "searching for commits during date $DATE"
while read p; do
  search_dir ~/$p
done <${DIR}/folders.txt

git log --after="${1} 00:00" --before="${1} 23:59"

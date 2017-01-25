#!/bin/bash

FRAMEWORK=$1
SITE_DIR=$2

IMPORT_FROM="Cartfile"
EXPORT_TO="$SITE_DIR/$FRAMEWORK/dependencies.json"

if [[ -f $IMPORT_FROM ]]; then
  # Count lines in Cartfile for later reference
  lastline=`<$IMPORT_FROM grep -c '[^[:space:]]'`
  count=1 # Initialise counter token
  # Write opening line of dependencies.json
  echo "{\"dependencies\":[" > $EXPORT_TO
  # Read Cartfile line by line
  while IFS= read -r -a array; do
    ((${#array[@]} >= 1)) || continue # ignore blank lines
    # Test line is in format: registry "org/repo"[ => version]
    # where version information is optional for matching
    if [[ ${array[@]} =~ ^(.+)[[:space:]]\"(.+)/(.+)\"[[:space:]]*(.+)*$ ]]
    then
      # Use regex groups to parse out parts of dependency declaration
      REGISTRY=${BASH_REMATCH[1]}
      ORGANISATION=${BASH_REMATCH[2]}
      REPO=${BASH_REMATCH[3]}
      VERSION=${BASH_REMATCH[4]}
      properties=(REGISTRY ORGANISATION REPO VERSION)
      pos=$(( ${#properties[*]} - 1 ))
      last=${properties[$pos]} # get length for later reference
      # Properties of a single dependency start writing here ===================
      echo "{" >> $EXPORT_TO
      for i in "${properties[@]}"; do
        key=`echo $i | tr '[:upper:]' '[:lower:]'`
        if [[ $i == $last ]]; then
          echo "\"$key\": \"${!i}\"" >> $EXPORT_TO
        else
          echo "\"$key\": \"${!i}\"," >> $EXPORT_TO
        fi
      done
      if [[ $count -eq $lastline ]]; then
        echo "}" >> $EXPORT_TO # omit separating comma for last block
      else
        echo "}," >> $EXPORT_TO
      fi
      # Properties of a single dependency end writing here =====================
      ((count++))
    fi
  done < $IMPORT_FROM # <-- defines which file is read in
  echo "]}" >> $EXPORT_TO # close dependencies.json
fi

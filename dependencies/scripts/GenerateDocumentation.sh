#!/bin/bash

print_color () { tput setab 7; tput setaf 0; echo "$1"; tput sgr0; }

build_docs () {
  jazzy \
    --swift-version 2.2 \
    --clean \
    --author James\ Bean \
    --author_url http://jamesbean.info \
    --github_url https://github.com/dn-m/$FRAMEWORK \
    --module-version $VERSION \
    --module $FRAMEWORK \
    --root-url https://dn-m.github.io \
    --output $SITE_DIR/$FRAMEWORK \
    --skip-undocumented \
    --hide-documentation-coverage \
    --theme $SITE_DIR/dependencies/templates/bean

  . $SITE_DIR/dependencies/scripts/HandleDependencies.sh $FRAMEWORK $SITE_DIR

  # Modify jazzy output to inject dependencies into navbar
    if [[ -e "$SITE_DIR/$FRAMEWORK/dependencies.json" ]]; then
      print_color "Adding dependencies to menus in $FRAMEWORK..."
      for html in $( find $SITE_DIR/$FRAMEWORK -name '*.html' ); do
        ruby $SITE_DIR/dependencies/scripts/InjectDependencies.rb "$html" "$SITE_DIR/$FRAMEWORK/dependencies.json"
      done
    fi
}

WORK_DIR=${PWD}
if [ $2 ]; then
  SITE_DIR=$2
else
  SITE_DIR=$WORK_DIR
fi
if [ $1 ]; then
  FRAMEWORKS_DIR=$1
else
  FRAMEWORKS_DIR="../Frameworks"
fi

# Make hashstash accessible in environment
hasStash=0
stashprefix="HASHSTASH__"
stashindex=0
STASHEDHASHES=()
if [[ -f "hashstash" ]]; then
  echo "hashstash exists!"
  hasStash=1
  # Read hashstash line by line
  while IFS="=" read -r -a array; do
    ((${#array[@]} >= 1)) || continue # ignore blank lines
    # Store each key as a prefixed (HASHSTASH__) variable
    printf -v "$stashprefix${array[@]:0:1}" %s ${array[@]:1}
    # Create an array of all stashed hashes
    STASHEDHASHES[$stashindex]="$stashprefix${array[@]:0:1}"
    ((stashindex++)) # increment index
  done < hashstash # <-- defines which file is read in
  # At this point we have a series of variables in the form
  # `HASHSTASH__ModuleName` and an array `STASHEDHASHES` of those variable names
  #statements
fi

cd $FRAMEWORKS_DIR

newindex=0
NEWHASHES=()
for FRAMEWORK in $( ls ); do
  if [[ -d $FRAMEWORK ]]; then

      cd $FRAMEWORK

      print_color "~~~ $FRAMEWORK ~~~"

      VERSION=$(git describe --tags | cut -d - -f -1)
      HASHKEY=$stashprefix$FRAMEWORK
      HASH=$(git log -n 1 --pretty=format:"%H")

      if [[ -n $VERSION ]]; then
        print_color "Version: $VERSION"
      else
        print_color "Version: undefined"
      fi

      if [[ $hasStash == 1 ]]; then
        if [ -n "${!HASHKEY}" ]; then
          # A hash has been stashed for this module, check for matches
          if [[ $HASH = ${!HASHKEY} ]]; then
            # The current hash and the stashed hash match
            print_color "$FRAMEWORK has not changed, skipping..."
          else
            # The current hash and the stashed hash don’t match, proceed
            build_docs
          fi
        else
          # There is no stashed hash, proceed
          build_docs
        fi
      else
        # There is no hashstash file
        build_docs
      fi

      # Save new hash value for stashing
      printf -v "$FRAMEWORK" %s $HASH
      # Create an array of all stashed hash keys
      NEWHASHES[$newindex]="$FRAMEWORK"
      ((newindex++)) # increment index

      cd ../

  fi
done

cd $SITE_DIR

# Clean old hashstash
if [[ -f "hashstash" ]]; then
  rm hashstash
fi
# Write new hashes to hashstash
for hash in "${NEWHASHES[@]}"
do
  echo "$hash=${!hash}" >> hashstash
done

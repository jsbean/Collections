#!/bin/bash

# Clean and build assets for main index
for i in $( ls ); do
  if [[ -d $i ]]; then
    if ! [ $i = dependencies -o $i = build ]; then
      if [ -d "build" ]; then
        rm -r build # Clean old build directory
      fi
      mkdir build # Recreate build directory
      for dir in js css img; do
        cp -R $i/$dir build/$dir # Copy js, css & img assets to build directory
      done
      break
    fi
  fi
done

# TODO: Port this to Swift
# -- Use a `Dictionary` to store subcategory children by their parent
# -- Iterate through key in `Dictionary`

# Declare Utility modules
UTILITY=(ParserTools ArithmeticTools ArrayTools CopyTools DictionaryTools DirectionTools EnumTools IntervalTools StringTools TreeTools ScriptingTools FrameworkTools)

# Declare MusicModel modules
MUSICMODEL=(MusicModel Duration Pitch PitchSpellingTools Dynamics EnsembleTools)

# Declare Graphics modules
GRAPHICS=(GraphicsTools Color ColorMode LayoutTools PathTools ProgressBar)

MUSICNOTATION=(Graph Staff)

# Declare Playback modules
PLAYBACK=(Timeline MetronomeController)

# Declare Interactivity
INTERACTIVITY=(AirTurn)

# Declare Uncategorized modules
MISC=()

misci=0
utilityi=0
musicmodeli=0
playbacki=0
graphicsi=0
musicnotationi=0
intervactivityi=0

for dir in $( ls ); do
  if [[ -d $dir ]]; then
    if [[ ${UTILITY[*]} =~ "$dir" ]]; then
      UTILITY_VERIFIED[utilityi]="$dir"
      ((utilityi++))
    elif [[ ${MUSICMODEL[*]} =~ "$dir" ]]; then
      MUSICMODEL_VERIFIED[musicmodeli]="$dir"
      ((musicmodeli++))
    elif [[ ${PLAYBACK[*]} =~ "$dir" ]]; then
      PLAYBACK_VERIFIED[playbacki]="$dir"
      ((playbacki++))
  	elif [[ ${GRAPHICS[*]} =~ "$dir" ]]; then
	  GRAPHICS_VERIFIED[graphicsi]="$dir"
	  ((graphicsi++))
    elif [[ ${INTERACTIVITY[*]} =~ "$dir" ]]; then
	  INTERACTIVITY_VERIFIED[graphicsi]="$dir"
	  ((intervactivityi++))
  	elif [[ ${MUSICNOTATION[*]} =~ "$dir" ]]; then
	  MUSICNOTATION_VERIFIED[musicnotationi]="$dir"
	  ((musicnotationi++))
    elif ! [ "$dir" = dependencies -o "$dir" = build ]; then
      MISC[$misci]="$dir"
      ((misci++))
    fi
  fi
done

if [ $utilityi -gt 0 ]; then
  export ${UTILITY_VERIFIED[@]}
fi
if [ $musicmodeli -gt 0 ]; then
  export ${MUSICMODEL_VERIFIED[@]}
fi
if [ $playbacki -gt 0 ]; then
  export ${PLAYBACK_VERIFIED[@]}
fi
if [ $graphicsi -gt 0 ]; then
  export ${GRAPHICS_VERIFIED[@]}
fi
if [ $interactivityi -gt 0 ]; then
  export ${INTERACTIVITY_VERIFIED[@]}
fi
if [ $musicnotationi -gt 0 ]; then
  export ${MUSICNOTATION_VERIFIED[@]}
fi
if [ $misci -gt 0 ]; then
  export ${MISC[@]}
  export hasMISC=1
  tput setab 3
  tput setaf 0
  echo "You have uncategorised subdirectories:"
  tput sgr0
  for dir in ${MISC[@]}; do
    echo "—— $dir"
  done
fi

if [[ -e main.md ]]; then
  ruby dependencies/scripts/Md2Mo.rb main.md dependencies/templates/main.mo
else
  print_color "Looks like you’re missing main.md! No homepage content for you."
fi
. dependencies/scripts/mo
mo dependencies/templates/index.mo > index.html

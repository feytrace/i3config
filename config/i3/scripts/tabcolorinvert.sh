#!/bin/bash

# based on Joedang100's solution on Reddit
if [ "$1" == "-m" && -z "$3" ]; then
  xprop -id "$3" -format TAG_INVERT 8c \
    -set TAG_INVERT $(\
                     xprop -id "$3" 8c TAG_INVERT \
                     | sed -e 's/.*= 1.*/0/' -e 's/.*= 0.*/1/' -e 's/.*not found.*/1/'\
                            )
else
    xprop -id $(xdotool getwindowfocus) -format TAG_INVERT 8c \
      -set TAG_INVERT $(\
                       xprop -id $(xdotool getwindowfocus) 8c TAG_INVERT \
                       | sed -e 's/.*= 1.*/0/' -e 's/.*= 0.*/1/' -e 's/.*not found.*/1/'\
                              )
fi


#!/bin/bash
# Dependencies: convert imagemagick xsel tesseract-ocr-...

if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    grimblast save area -
else
    import png:-
fi |
    convert - -modulate 100,0 -resize 400% -set density 300 png:- |
    tesseract stdin stdout -l eng+chi_sim --psm 3 -c preserve_interword_spaces=1 |
    # sed 's/'"$(printf '%b' '\014')"'//g;s/|/I/g' |
    if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
        wl-copy
    else
        xsel -bi
    fi

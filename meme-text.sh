#!/usr/bin/env bash
# Initialize variables to customize output
: "${FFILE:="${HOME}/.fonts/i/impact.ttf"}" # Let user choose font file
: "${FSIZE:=72}"                            # Let user choose font size in px
: "${BSIZE:=5}"                             # Let user choose stroke size in px
: "${OFFSET:='(h*0.05)'}"                   # Let user choose text offset in px
# TTEXT - Text to display at the top of the image
# BTEXT - Text to display at the bottom of the image

# Exit value index:
# 1 - Problem with command arguments
# 2 - Problem with output customization

# Show how to use the program
usage() {
    printf 'usage: [TTEXT=S BTEXT=S FFILE=S FSIZE=N BSIZE=N OFFSET=N] %s IN_FILE OUT_FILE\n' "${0##*/}"
}
usage_long() {
    usage
    cat <<EOF
    FFILE       Font to use            (default: ${HOME}/.fonts/i/impact.ttf)
    FSIZE       Font size in px        (default: 72)
    BSIZE       Stroke size in px      (default: 5)
    TTEXT       Top text (optional)
    BTEXT       Bottom text (optional)
    OFFSET      Text offset from edges (default: h*0.05)
Due to the way shell strings work, using an apostrophe may require escaping
multiple times, e.g.: TTEXT="I\\\\\\\\\'m okay" to display "I'm okay"
EOF
}

# Make sure all fields are full
if [[ $# -ne 2 ]]; then
    if [[ $# -eq 0 ]]; then
        usage_long
        exit 0
    else
        printf 'error: wrong number of arguments: got %d, expected 2.\n' "$#" >&2
        usage >&2
        exit 1
    fi
fi

# make sure input file exists
if ! [[ -f $1 ]]; then
    printf "error: %s is not a file.\n" "$1" >&2
    usage >&2
    exit 1
fi

# exit if no text would be overlain
if [[ -z $TTEXT ]] && [[ -z $BTEXT ]]; then
    echo 'error: both text fields are empty' >&2
    usage >&2
    exit 2
fi

# run if only top text provided
if [[ -n $TTEXT ]] && [[ -z $BTEXT ]]; then
    exec ffmpeg -i "$1" -vf "drawtext=fontfile=${FFILE}:text=${TTEXT}:fontcolor=white:borderw=${BSIZE}:fontsize=${FSIZE}:x=(w-text_w)/2:y=${OFFSET}" -an "$2"
fi

# run if only bottom text provided
if [[ -z $TTEXT ]] && [[ -n $BTEXT ]]; then
    exec ffmpeg -i "$1" -vf "drawtext=fontfile=${FFILE}:text=${BTEXT}:fontcolor=white:borderw=${BSIZE}:fontsize=${FSIZE}:x=(w-text_w)/2:y=(h-text_h)-${OFFSET}" -an "$2"
fi

# run if both top and bottom text are provided
ffmpeg -i "$1" -vf "[in] drawtext=fontfile=${FFILE}:text=${TTEXT}:fontcolor=white:borderw=${BSIZE}:fontsize=${FSIZE}:x=(w-text_w)/2:y=${OFFSET}, drawtext=fontfile=${FFILE}:text=${BTEXT}:fontcolor=white:borderw=${BSIZE}:fontsize=${FSIZE}:x=(w-text_w)/2:y=(h-text_h)-${OFFSET} [out]" -an "$2"

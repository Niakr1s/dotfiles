#!/usr/bin/env bash

# metadata=$(playerctl metadata)

# artist=$(awk '/artist/ { print $3 }' <<<"$metadata")
# title=$(awk '/title/ { print $3 }' <<<"$metadata")

# artist=$(grep '/artist/ { print $3 }' <<<"$metadata")
# title=$(grep '' <<<"$metadata")

# playerctl metadata | while read -e line
while read -e line
do
    if [[ $line =~ ':title' ]]
    then
        title=$(sed 's/.*:title\W*//' <<<"$line")
    fi
    if [[ $line =~ ':artist' ]]
    then
        artist=$(sed 's/.*:artist\W*//' <<<"$line")
    fi
done <<<$(playerctl metadata)

if [[ $artist && $title ]]
then
    echo "$artist - $title";
fi

while read var
do
    echo "${var%-*}"
done

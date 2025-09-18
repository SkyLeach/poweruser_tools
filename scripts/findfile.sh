DIR="~/src/findfiletest/"
WILDCARD="*.*"


cd "${DIR}"
for $fn in $(find ./ -type f -mindepth 1 -maxdepth "${RECUR}" -type f -iname "${WILDCARD}"); do
    echo $fn
done


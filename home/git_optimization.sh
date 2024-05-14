echo "Enabling git speed up"

git config feature.manyFiles true
git update-index --index-version 4
git config core.fsmonitor true

echo "Please also use git sparse-checkout for more speedup"
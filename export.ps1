pushd $PSScriptRoot
$outDir = "export"
mkdir $outDir -ErrorAction SilentlyContinue | Out-Null
Get-ChildItem *.scad -Exclude "_*.scad" | ForEach-Object { echo $_; openscad -o "$outDir/$($_.BaseName).stl" $_.Name }
popd
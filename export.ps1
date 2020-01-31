pushd $PSScriptRoot
$outDir = "export"
mkdir $outDir -ErrorAction SilentlyContinue | Out-Null
Get-ChildItem *.scad -Exclude "hdmi-socket-mount.scad" | ForEach-Object { openscad -o "$outDir/$($_.BaseName).stl" $_.Name }
popd
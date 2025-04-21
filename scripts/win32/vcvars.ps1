$VCVars_C = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat"
$VCVars_D = "D:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat"
$EnvVariableFile = "$env:temp\vcvars.txt"

if (Test-Path "$VCVars_C" -PathType Leaf) {
	cmd /c "call `"$VCVars_C`" x64 && set > `"$EnvVariableFile`""
} elseif (Test-Path "$VCVars_D" -PathType Leaf) {
	cmd /c "call `"$VCVars_D`" x64 && set > `"$EnvVariableFile`""
} else {
	throw "Could not find vcvarsall.bat"
}

Get-Content "$EnvVariableFile" | Foreach-Object {
	if ($_ -match "^(.*?)=(.*)$") {
		Set-Content "env:\$($matches[1])" $matches[2]
	}
}
Remove-Item "$EnvVariableFile"

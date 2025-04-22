function Set-Environment([string]$EnvVariableFile) {
	Get-Content "$EnvVariableFile" | Foreach-Object {
		if ($_ -match "^(.*?)=(.*)$") {
			Set-Content "env:\$($matches[1])" $matches[2]
		}
	}
	Remove-Item "$EnvVariableFile"
}

$EnvVariableFile = "$env:temp\vcvars.txt"

foreach ($Edition in @('Enterprise', 'Professional', 'Community')) {
	$VCVars_C = "C:\Program Files\Microsoft Visual Studio\2022\$Edition\VC\Auxiliary\Build\vcvarsall.bat"
	$VCVars_D = "D:\Program Files\Microsoft Visual Studio\2022\$Edition\VC\Auxiliary\Build\vcvarsall.bat"
	$Found = $false

	if (Test-Path "$VCVars_C" -PathType Leaf) {
		Write-Output "Using $VCVars_C"
		cmd /c "call `"$VCVars_C`" x64 && set > `"$EnvVariableFile`""
		$Found = $true
	} elseif (Test-Path "$VCVars_D" -PathType Leaf) {
		Write-Output "Using $VCVars_D"
		cmd /c "call `"$VCVars_D`" x64 && set > `"$EnvVariableFile`""
		$Found = $true
	}

	if ($Found) {
		Set-Environment "$EnvVariableFile"
		exit
	}
}

throw "Could not find vcvarsall.bat"

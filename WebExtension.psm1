Function Export-WebExtension {
	Param (
		$Path = '.'
	)
	Compress-Archive -Path "$Path\*" -DestinationPath ~\Downloads\extension.zip -Force
	Rename-Item -Path "$Path\manifest.json" -NewName manifest-v3.json
	Export-WebExtensionManifest -Path $Path -Source manifest-v3
	Compress-Archive -Path "$Path\*" -DestinationPath ~\Downloads\extension-v2.zip -Force
	Remove-Item -Path "$Path\manifest.json"
	Rename-Item -Path "$Path\manifest-v3.json" -NewName manifest.json
}
Function Export-WebExtensionManifest {
	Param (
		$Path = '.',
		$Version = 2,
		$Source = 'manifest',
		$Name = 'manifest'
	)
	$Data = Get-Content -Raw -Path "$Path\$Source.json" | ConvertFrom-Json -AsHashtable
	$PathV2 = "$Path\manifest-v2.json"
	If (Test-Path -PathType Leaf -Path $PathV2) {
		$DataV2 = Get-Content -Raw $PathV2 | ConvertFrom-Json -AsHashtable
		ForEach ($Key In $DataV2.Keys) {
			$Data[$Key] = $DataV2[$Key]
		}
	}
	$Data.manifest_version = 2
	$Data | ConvertTo-Json -Depth 10 | Set-Content -Path "$Path\$Name.json"
}
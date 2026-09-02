# optional parameter
param (
  [string]$Extension
);

# validate extension names
if ($Extension -notin $ExtensionNames){
  throw "Exension '$Extension' is not registered in the configuration file.";
}

# make sure the script stops when it encounters an error
$ErrorActionPreference = "Stop";

# locate the script repo relative to tools directory
$ToolsRoot = Split-Path -Parent $PSCommandPath;

# locate the config file relative to the tools directory
$ConfigFile = Join-Path $ToolsRoot "publish-config.json";

# does the configuration file exist?
if (-not (Test-Path $ConfigFile)) {
  throw "Configuration file not found: $ConfigFile";
}

# read the config file JSON
$config = Get-Content $ConfigFile -Raw | ConvertFrom-Json;

# verify that our required properties exist in the config file
if (-not $config.publishRoot) {
  throw "Missing required property 'publishRoot' in configuration file: $ConfigFile";
}

if (-not $config.whitelistFile) {
  throw "Missing required property 'whitelistFile' in configuration file: $ConfigFile";
} 

if (-not $config.excludeFile) {
  throw "Missing required property 'excludeFile' in configuration file: $ConfigFile";
}

if (-not $config.extensions) {
  throw "Missing required property 'extensions' in configuration file: $ConfigFile";
}

# does the whitelist file exist?
$WhitelistFile = Join-Path $ToolsRoot $config.whitelistFile;
if (-not (Test-Path $WhitelistFile)) {
  throw "Whitelist file not found: $WhitelistFile";
}

# does the exclude file exist?
$ExcludeFile = Join-Path $ToolsRoot $config.excludeFile;
if (-not (Test-Path $ExcludeFile)) {
  throw "Exclude file not found: $ExcludeFile";
}

# load and validate the extension registry
$ExtensionNames = @(
  $config.extensions.PSObject.Properties | Select-Object -ExpandProperty Name
);

if ($ExtensionNames.Count -eq 0) {
  throw "No extensions found in configuration file: $ConfigFile";
}
else {
  Write-Host "Found $($ExtensionNames.Count) extensions in configuration file: $ConfigFile";
}


# verify the config file has the required properties
Write-Host "Extension Parameter:";
Write-Host $Extension;
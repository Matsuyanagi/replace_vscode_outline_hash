<#
  File: replace_antigravity_outline_hash.ps1
  Description: Replaces the "#" symbols used in Antigravity outline view with spaces.
               Auto-detects serverWorkerMain.js, creates a backup, then performs the string replacement.

  Usage: .\replace_antigravity_outline_hash.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------- Constants ----------
$SEARCH_PATTERN  = '{return"#".repeat(e.level)+" "+e.text}'
$REPLACE_PATTERN = '{return" ".repeat(e.level)+e.text}'
$RELATIVE_SUFFIX = 'resources\app\extensions\markdown-language-features\dist\serverWorkerMain.js'

try {
    # 1. Get the path of the antigravity command
    Write-Host '[1/5] Searching for the antigravity command...'
    $codeCmd = (Get-Command antigravity -ErrorAction Stop).Source
    Write-Host "  -> Found: $codeCmd"

    # 2. Determine the Antigravity installation directory
    #    antigravity / antigravity.cmd is normally located under <AntigravityDir>\bin\
    Write-Host '[2/5] Determining Antigravity directory...'
    $codeBin  = Split-Path -Parent $codeCmd
    $antigravityDir = Split-Path -Parent $codeBin
    Write-Host "  -> Antigravity directory: $antigravityDir"

    # 3. Search for serverWorkerMain.js
    Write-Host '[3/5] Searching for serverWorkerMain.js...'
    $candidates = Get-ChildItem -Path $antigravityDir -Filter 'serverWorkerMain.js' -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -like "*$RELATIVE_SUFFIX" }

    if (-not $candidates) {
        throw "serverWorkerMain.js was not found (search path: $antigravityDir)"
    }

    $targetFile = $candidates[0].FullName
    Write-Host "  -> Found: $targetFile"

    # 4. Create backup
    Write-Host '[4/5] Creating backup...'
    $backupFile = "$targetFile.bak"
    Copy-Item -Path $targetFile -Destination $backupFile -Force
    Write-Host "  -> Backup: $backupFile"

    # 5. String replacement
    Write-Host '[5/5] Performing string replacement...'
    $content = [System.IO.File]::ReadAllText($targetFile)

    if ($content.Contains($SEARCH_PATTERN)) {
        $newContent = $content.Replace($SEARCH_PATTERN, $REPLACE_PATTERN)
        [System.IO.File]::WriteAllText($targetFile, $newContent)
        Write-Host '  -> Replacement completed.'
    }
    else {
        Write-Host '  -> Target string was not found (may have already been replaced).'
    }

    Write-Host "`nDone."
}
catch {
    Write-Error "An error occurred: $_"
    exit 1
}

pause

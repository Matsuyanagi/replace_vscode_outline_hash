# replace_vscode_outline_hash

A PowerShell script that removes the `#` prefix symbols from VSCode's Outline view for Markdown files, making the outline cleaner and easier to read.

## Background

By default, VSCode's Outline panel displays Markdown headings with `#` symbols:

```
# My Heading
## Section
### Subsection
```

This script patches VSCode's internal `serverWorkerMain.js` so the outline shows headings **without** the `#` symbols:

```
My Heading
  Section
    Subsection
```

## Requirements

- Windows
- PowerShell 5.1 or later
- Visual Studio Code installed and the `code` command available in `PATH`

## Usage

> **⚠️ Run as Administrator**  
> Writing to VSCode's installation directory requires elevated privileges.

1. Open PowerShell **as Administrator**.
2. Run the script:

```powershell
.\replace_vscode_outline_hash.ps1
```

The script will:

1. Locate the `code` executable via `PATH`
2. Determine the VSCode installation directory
3. Find `serverWorkerMain.js` inside the installation
4. Create a backup (`serverWorkerMain.js.bak`)
5. Replace the target string to remove `#` prefixes from the outline

After running, **reload VSCode** (or restart it) to see the change take effect.

## Restoring the Original

To restore the original behavior, copy the backup file back:

```powershell
Copy-Item "path\to\serverWorkerMain.js.bak" "path\to\serverWorkerMain.js" -Force
```

## Notes

- This script patches a minified JS file inside the VSCode installation. **VSCode updates will overwrite the patch**, so you may need to re-run the script after each update.
- If VSCode is installed in a location that requires administrator rights (e.g., `C:\Program Files`), the script must be run as Administrator.
- If the target string is not found (e.g., after a VSCode update changed the file), the script will report it and exit safely without modifying anything.

## License

MIT

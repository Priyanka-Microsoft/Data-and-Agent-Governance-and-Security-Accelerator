function Import-AzModuleSafe {
  <#
  .SYNOPSIS
    Wraps Import-Module to handle 'Assembly with same name is already loaded' errors
    that occur on GitHub Actions runners where Az modules are pre-loaded.
  #>
  [CmdletBinding()]
  param([Parameter(Mandatory, Position = 0)][string[]]$Name)

  foreach ($n in $Name) {
    try {
      Import-Module $n -ErrorAction Stop
    } catch {
      if ($_.Exception.Message -match 'Assembly with same name is already loaded') {
        if (Get-Module -Name $n -ErrorAction SilentlyContinue) {
          Write-Verbose "$n already loaded in session; skipping re-import."
        } else {
          throw
        }
      } else {
        throw
      }
    }
  }
}

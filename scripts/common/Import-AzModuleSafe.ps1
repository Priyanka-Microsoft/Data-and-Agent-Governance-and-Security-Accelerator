function Import-AzModuleSafe {
  param([Parameter(Mandatory, Position = 0)][string[]]$Name)
  foreach ($n in $Name) {
    try {
      Import-Module $n -ErrorAction Stop
    } catch {
      if ($_.Exception.Message -match 'Assembly with same name is already loaded') {
        if (Get-Module -Name $n -ErrorAction SilentlyContinue) {
          Write-Verbose "$n already loaded in session; skipping re-import."
        } else { throw }
      } else { throw }
    }
  }
}

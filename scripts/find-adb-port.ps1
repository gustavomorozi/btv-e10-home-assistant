<#
  Procura a porta TCP do ADB numa TV box (Windows PowerShell 5.1+).
  Uso:  .\find-adb-port.ps1 -Ip 192.168.0.X [-Start 1 -End 65535]
  Depois: adb connect IP:PORTA

  Não envia nada além de tentativas de conexão TCP ao IP que você informar.
#>
param(
  [Parameter(Mandatory = $true)][string]$Ip,
  [int]$Start = 1,
  [int]$End = 65535,
  [int]$TimeoutMs = 400
)

$open = New-Object System.Collections.Concurrent.ConcurrentBag[int]
$ports = $Start..$End
$batchSize = 800

Write-Host "Varrendo $Ip portas $Start-$End ..." -ForegroundColor Cyan
for ($i = 0; $i -lt $ports.Count; $i += $batchSize) {
  $batch = $ports[$i..([Math]::Min($i + $batchSize, $ports.Count) - 1)]
  $tasks = foreach ($p in $batch) {
    $c = New-Object Net.Sockets.TcpClient
    [pscustomobject]@{ Port = $p; Client = $c; Task = $c.ConnectAsync($Ip, $p) }
  }
  Start-Sleep -Milliseconds $TimeoutMs
  foreach ($t in $tasks) {
    if ($t.Task.IsCompleted -and -not $t.Task.IsFaulted -and $t.Client.Connected) { $open.Add($t.Port) }
    $t.Client.Close()
  }
}

$found = $open | Sort-Object
if (-not $found) { Write-Host "Nenhuma porta aberta encontrada." -ForegroundColor Yellow; exit 1 }
Write-Host "Portas abertas: $($found -join ', ')" -ForegroundColor Green
Write-Host "Teste cada uma:  adb connect $Ip`:PORTA   (a do adbd costuma ser alta, ex.: 11993)"

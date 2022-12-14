# Drucker Hostname oder IP
$prhostname = 'dr6085'
# Druckertreiber-Name
$drivername = 'Lexmark Universal v2 XL'
# Zu druckende PDF Datei. Wird mit Standardprogramm auf angelegten Drucker gedruckt
$outfile = 'Print-PDFNewPrinter.pdf'

# Get-PrinterDriver -Name "Lexmark Universal v* XL"

$prhostname = Read-Host "Drucker Hostname (oder IP) eingeben z.B. DR6085"

Write-Host "Teste Erreichbarkeit von $prhostname"
if (!(Test-Path -Path $outfile -PathType Leaf))
{
    Write-Host "Fehler: Datei $outfile nicht vorhanden"
    break
} 

if (Test-NetConnection $prhostname)
{
    Write-Host "Erstelle Anschluss: $prhostname"
    Add-PrinterPort -Name $prhostname.ToUpper() -PrinterHostAddress $prhostname

    Write-Host "Erstelle Drucker: $prhostname"
    Add-Printer -Name $prhostname.ToUpper() -DriverName $drivername -PortName $prhostname

    (Get-Printer -Name $prhostname).Name
    Write-Host "Drucke $outfile auf $prhostname"
    Start-Process -FilePath $outfile -Verb PrintTo $prhostname -PassThru -WindowStyle Hidden | %{sleep 10;$_} | kill

    Write-Host "Lösche Drucker: $prhostname"
    Remove-Printer -Name $prhostname

    Write-Host "Lösche Anschluss: $prhostname"
    Remove-PrinterPort -Name $prhostname
} else
{
    Write-Host "Fehler: $prhostname nicht erreichbar."
}

# Get all Intel wired network adapters
$adapters = Get-NetAdapter | 
    Where-Object {
        $_.InterfaceDescription -like "*Intel*" -and
        $_.InterfaceDescription -notlike "*Wi-Fi*" -and 
        $_.InterfaceDescription -notlike "*Wireless*" -and 
        $_.InterfaceDescription -notlike "*Bluetooth*"
    } | Sort-Object Name

if ($adapters.Count -eq 0) {
    Write-Host "No Intel wired network adapters found!" -ForegroundColor Red
    exit
}

# List all Intel wired network adapters found
Write-Host "Found $($adapters.Count) Intel wired adapter(s):" 
$adapters | ForEach-Object { Write-Host "$($_.Name)  ($($_.InterfaceDescription))" -ForegroundColor White }

$tweaks = @{
    
    # === Disable Interrupt Moderation ===
    "*InterruptModeration"       = "0"

    # === Offloads & Flow Control ===
    "*FlowControl"               = "0"
    "*LsoV2IPv4"                 = "0"
    "*LsoV2IPv6"                 = "0"
    "*TCPChecksumOffloadIPv4"    = "3"      # 3 = [Rx+Tx enabled]
    "*TCPChecksumOffloadIPv6"    = "3"
    "*UDPChecksumOffloadIPv4"    = "3"
    "*UDPChecksumOffloadIPv6"    = "3"
    "*IPChecksumOffloadIPv4"     = "3"

    # === Buffers ===
    "*ReceiveBuffers"            = "256"
    "*TransmitBuffers"           = "512"

    # === Other ===
    "*PriorityVLANTag"           = "0"      # Disable VLAN priority tagging
    "*JumboPacket"               = "1514"   # Disable Jumbo Frames [set to 9014 to enable]
}

foreach ($adapter in $adapters) {
    Write-Host "`nApplying tweaks to: $($adapter.Name) ..." -ForegroundColor Yellow -NoNewline
    
    $applied = 0
    $unsupported = 0

    foreach ($tweak in $tweaks.GetEnumerator()) {
        try {
            Set-NetAdapterAdvancedProperty -Name $adapter.Name `
                                          -RegistryKeyword $tweak.Key `
                                          -RegistryValue $tweak.Value `
                                          -ErrorAction Stop | Out-Null
            $applied++
        }
        catch {
            $unsupported++
        }
    }
    
    Write-Host "`nDone ($applied applied, $unsupported unsupported)." -ForegroundColor Green
}

# List of registry values to set to "0" (String/REG_SZ)
$tweaks= @(
    "ASPM", "AdvancedEEE", "AutoPowerSaveModeEnabled", "CLKREQ", "EEE",
    "EEELinkAdvertisement", "EEEPlus", "EeePhyEnable", "EnableAspm",
    "EnableDynamicPowerGating", "EnableGreenEthernet", "SipsEnabled",
    "ULPMode", "EnableModernStandby", "PowerSavingMode", "EnablePowerManagement",
    "EnableSavePowerNow", "ForceEnableClkReq", "GigaLite", "NicAutoPowerSaver",
    "PnPCapabilities", "PowerDownPll", "PowerSaveMode", "ReduceSpeedOnPowerDown",
    "RxAbsIntDelay", "RxIntDelay", "SavePowerNowEnabled", "SmartPowerDownEnable",
    "SmartSpeed", "ThroughputBoosterEnabled", "TxAbsIntDelay", "TxIntDelay",
    "EnableConnectedPowerGating", "bLowPowerEnable"
)



foreach ($adapter in $adapters) {
    Write-Host "`nApplying registry tweaks for: $($adapter.Name) ..." -ForegroundColor Yellow

    $regPath = $null

    # Primary Method: Lookup driver path via PnPDeviceID in Enum hive
    if ($adapter.PnPDeviceID) {
        $enumPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($adapter.PnPDeviceID)"
        $driverSubKey = (Get-ItemProperty -Path $enumPath -Name "Driver" -ErrorAction SilentlyContinue).Driver
        if ($driverSubKey) {
            $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\$driverSubKey"
        }
    }

    # Fallback Method: Match InterfaceGuid with NetCfgInstanceId in Class hive
    if (-not $regPath -or -not (Test-Path $regPath)) {
        $classBase = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
        $matchedKey = Get-ChildItem -Path $classBase -ErrorAction SilentlyContinue | Where-Object {
            (Get-ItemProperty -Path $_.PSPath -Name "NetCfgInstanceId" -ErrorAction SilentlyContinue).NetCfgInstanceId -eq $adapter.InterfaceGuid
        }
        if ($matchedKey) {
            $regPath = $matchedKey.PSPath
        }
    }

    if ($regPath -and (Test-Path $regPath)) {
        $applied = 0
        foreach ($tweak in $tweaks) {
            Set-ItemProperty -Path $regPath -Name $tweak -Value "0" -Type String -ErrorAction SilentlyContinue
            $applied++
        }
        Write-Host "Done ($applied keys processed)." -ForegroundColor Green
    } else {
        Write-Host "Could not locate registry path for this adapter." -ForegroundColor Red
    }
}

Write-Host "`nRestarting adapters..." -ForegroundColor Yellow
foreach ($adapter in $adapters) {
    Disable-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 800
    Enable-NetAdapter -Name $adapter.Name -Confirm:$false
}
Write-Host "Done." -ForegroundColor Green
pause
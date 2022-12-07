#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/6.input"
)


$messages = New-Object Collections.Generic.List[PSCustomObject]

$packetMarkerLength = 4
$messageMarkerLength = 14

function Test-Marker() {
    param (
        [string]$candidate
    )

    for ($i = 0; $i -lt $candidate.Length - 1; $i++) {
        for ($j = $i + 1; $j -lt $candidate.Length; $j++) {
            # Write-Error "$i $j"
            Write-Progress -Activity "Considering candidate marker $candidate..." `
                -Id 2 -Status "Does $($candidate[$i]) == $($candidate[$j])?" `
                -PercentComplete ((($i * $j + $j) / ($candidate.Length * $candidate.Length)) * 100)
            # Start-Sleep -Milliseconds $(Get-Random -Maximum 50 -Minimum 0)
            if ($candidate[$i] -eq $candidate[$j]) {
                Write-Progress -Activity "Marker check" -Id 2 -Completed
                return $false
            }
        }
    }
    Write-Progress -Activity "Marker check" -Id 2 -Completed
    return $true
}

Get-Content $FileName | ForEach-Object {
    $scanLength = $packetMarkerLength
    $statusPrefix = "Possible Packet Marker"

    $message = [PSCustomObject]@{
        PacketMarker  = -1
        MessageMarker = -1
        Buffer = $_
    }
    $messages.Add($message)

    for ($i = 0; $i -lt $_.Length - $scanLength; $i++) {
        $candidate = $_.Substring($i, $scanLength)
        Write-Progress -Activity "Considering $($_.Substring(0, 5))...$($_.Substring($_.Length - 5, 5))" -Id 1 `
            -Status "$statusPrefix $candidate... $($i + 1) / $($_.Length - 3)" `
            -PercentComplete ((($i + 1) / $_.Length) * 100)
        
        if (Test-Marker $candidate) {
            if ($message.PacketMarker -gt 0) {
                $message.MessageMarker = $i + $scanLength
                break
            } else {
                $message.PacketMarker = $i + $scanLength
                $scanLength = $messageMarkerLength
                $statusPrefix = "Possible Message Marker"
            }
            
        }
    }
}
Start-Sleep -Milliseconds 300
Write-Progress "Activity" -Completed
$messages
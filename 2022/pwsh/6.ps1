#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/6.input"
)


$messages = New-Object Collections.Generic.List[PSCustomObject]

$start_of_packet_marker_length = 4
$start_of_message_marker_length = 14

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
            # Write-Error "$i - $j"
        }
    }
    Write-Progress -Activity "Marker check" -Id 2 -Completed
    return $true
}

Get-Content $FileName | ForEach-Object {
    $scan_size = $start_of_packet_marker_length


    $message = [PSCustomObject]@{
        PacketMarker  = -1
        MessageMarker = -1
        Buffer = $_
    }
    $messages.Add($message)

    for ($i = 0; $i -lt $_.Length - $scan_size; $i++) {
        $candidate = $_.Substring($i, $scan_size)
        Write-Progress -Activity "Considering $($_.Substring(0, 5))...$($_.Substring($_.Length - 5, 5))" -Id 1 `
            -Status "Possible Marker $candidate... $($i + 1) / $($_.Length - 3)" `
            -PercentComplete ((($i + 1) / $_.Length) * 100)
        
        if (Test-Marker $candidate) {
            if ($message.PacketMarker -gt 0) {
                $message.MessageMarker = $i + $scan_size
                break
            } else {
                $message.PacketMarker = $i + $scan_size
                $scan_size = $start_of_message_marker_length
            }
            
        }
    }
}
Start-Sleep -Milliseconds 300
Write-Progress "Activity" -Completed
$messages
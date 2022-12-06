#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/6.input"
)


$results =  New-Object Collections.Generic.List[int]

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
    for ($i = 3; $i -lt $_.Length; $i++) {
        # Start-Sleep -Milliseconds 750
        $candidate = $_.Substring($i - 3, 4)
        Write-Progress -Activity "Considering $($_.Substring(0, 5))...$($_.Substring($_.Length - 5, 5))" -Id 1 `
            -Status "Possible Marker $candidate... $($i + 1) / $($_.Length - 3)" `
            -PercentComplete ((($i + 1) / $_.Length) * 100)
        
        if (Test-Marker $candidate) {
            # $i
            $results.Add($i + 1)
            break;
        }
    }
}
Start-Sleep -Milliseconds 300
Write-Progress "Activity" -Completed
$results
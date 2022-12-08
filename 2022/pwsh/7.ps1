#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/7.input"
)

class Folder {
    [Folder] $Parent
    [Collections.Generic.Dictionary[String, Int]] $Files = @{}
    [Collections.Generic.Dictionary[String, Folder]] $Folders = @{}


    [int]TotalSize(){
        $returnValue = $this.Folders.Values | ForEach-Object {
            $_.TotalSize()
        }
        $returnValue += $This.Files.Values | Measure-Object -Sum | ForEach-Object Sum

        return $returnValue | Measure-Object -Sum | ForEach-Object Sum
    }
}

class Result {
    [Collections.Generic.List[Folder]] $MatchingFolders
    [int] $Sum
}


function Build-Folders() 
{
    <#
        .SYNOPSIS
            Takes directory and file info and builds a [Folder] from it.
    #>
    [CmdletBinding()]
    [OutputType([Folder])]
    param (
        [Parameter(Mandatory, valueFromPipeline)]
        [String] $Line
    )
    
    begin { 
        $rootFolder = [Folder]::New()
        $currentFolder = $rootFolder
    }

    process { 
        if ($Line -match '^\$ cd (.+)') {
            $argument = $Matches[1]
            Write-Debug "directory $argument"

            if ($argument -eq '..') {
                $currentFolder = $currentFolder.Parent
            } else {
                if ($currentFolder.Folders.Keys.Contains($argument))
                {
                    $currentFolder = $currentFolder.Folders[$argument]
                } 
                else 
                {
                    $newFolder = [Folder]::New()
                    $newFolder.Parent = $currentFolder
                    $currentFolder.Folders.Add($argument, $newFolder)
                    $currentFolder = $newFolder
                }
            }
             
        } 
        elseif ($Line -match '^(\d+) (.+)')
        {
            $fileSize = $Matches[1]
            $fileName = $Matches[2]
            Write-Debug "file $fileName ($fileSize)"
            $currentFolder.Files.Add($fileName, $fileSize)
        }
    }

    end {
        $rootFolder
    }
}


function Get-Folders() 
{
    <#
        .SYNOPSIS
            Takes a folder and returns every folder within it.

        .EXAMPLE
            $subFolders = $rootFolder | Get-Folders
    #>
    [CmdletBinding()]
    [OutputType([Folder[]])]
    param (
        [Parameter(Mandatory, valueFromPipeline)]
        [Folder]$folder
    )
    
    $allFolders = @()
    $folder.Folders.Values | ForEach-Object { 
        $allFolders += $_
        $allFolders += $_ | Get-Folders
    }

    return $allFolders

}

# Part 1
$maxFolderSize = 100000
$rootFolder = Get-Content $FileName | Build-Folders
$sumOfQualifyingFolders = $rootFolder | Get-Folders
    | ForEach-Object { if ($_.TotalSize() -lt $maxFolderSize) { $_.TotalSize() } }
    | Measure-Object -Sum | ForEach-Object Sum

Write-Host "Part 1: $sumOfQualifyingFolders"

# Part 2
$diskSize = 70000000
$updateSize = 30000000
$diskUsed = $rootFolder.TotalSize()
$freespaceNeeded = $updateSize - ($diskSize - $diskUsed)
$toBeDeletedFolderSize = $rootFolder | Get-Folders
    | ForEach-Object { if ($_.TotalSize() -gt $freespaceNeeded) { $_.TotalSize() } }
    | Sort-Object | Select-Object -First 1

Write-Host "Part 2: $toBeDeletedFolderSize"

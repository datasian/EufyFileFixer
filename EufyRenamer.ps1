$camerapath = "C:\PATH\TO\YOUR\Eufy\Folder"

$cameraid = @{
    T8411PASDF = "REPLACE ME WITH YOURS"
    T8411PABCD = "SECOND ITEM EXAMPLE"
}

class eufyVideoFile {
    $fileobject
    [string]$fixedfilename
    [datetime]$date
    [bool]$renameme = $false
    [void]GetDate()
    {
        if ($this.fileobject)
        {
            $regexstring = "_(\d{4})_(\d{2})_(\d{2})_(\d{2})_(\d{2})_(\d{2})$"
            $filename = $this.fileobject.basename
            if ($filename -match $regexstring)
            {
                $this.date = "{0}/{1}/{2} {3}:{4}:{5}" -f $matches[1],$matches[2],$matches[3],$matches[4],$matches[5],$matches[6]
            }
            else{
                throw "This file [$($this.fileobject.Name)] did not match a date format"
            }
        }
        else{
            throw "This object doesn't have a file assigned to it"
        }
    }
    [void]GetName([hashtable]$cameranamedefinition)
    {
        if ($this.fileobject)
        {
            $regexstring = "^([a-zA-Z \d]+)_(\d{4}_\d{2}_\d{2}_\d{2}_\d{2}_\d{2})"
            $filename = $this.fileobject.basename
            if ($filename -match $regexstring)
            {
                if ($cameranamedefinition[$matches[1]])
                {
                    $this.fixedfilename = $cameranamedefinition[$matches[1]] + "_" + $matches[2] + $this.fileobject.extension
                    $this.renameme = $true
                }
            }
            else {
                throw "This object doesn't have a file assigned to it"
            }
        }
    }
    [void]FixFile()
    {
        if (-not ($this.fileobject))
        {
            throw "This object doesn't have a file assigned to it yet. Do this first with `$object.fileobject = whatever Get-Item gives you"
        }
        if (-not ($this.date))
        {
            $this.GetDate()
        }

        #fix file date first
        Write-Host "  [$($this.fileobject.name)]> Setting date from [$($this.fileobject.LastWriteTime)] to [$($this.date)]" -ForegroundColor Gray
        $this.fileobject.LastWriteTime = $this.date
        #rename the actual file
        if ($this.renameme)
        {
            Write-Host "  [$($this.fileobject.name)]> Setting date from [$($this.fileobject.LastWriteTime)] to [$($this.date)]" -ForegroundColor Gray
            Rename-Item -Path $this.fileobject.fullname -NewName $this.fixedfilename -Verbose
        }
    }
}

#$videoobjects = New-Object System.Collections.Generic.List[]

Write-Host "Getting video files. Please wait... " -NoNewline
$videofiles = Get-Childitem $camerapath -recurse -file
Write-Host " found $($videofiles.count) files."

$count = 1
foreach ($file in $videofiles)
{
    Write-Host "[$count/$($videofiles.count)] Working on $($file.FullName)"
    $thing = [eufyVideoFile]::new()
    $thing.fileobject = $file
    $thing.GetDate()
    $thing.GetName($cameraid)
    $thing.FixFile()
    $count++
}


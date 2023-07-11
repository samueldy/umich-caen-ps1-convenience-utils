# Want to wake up my research computer
# Thanks to https://www.pdq.com/blog/wake-on-lan-wol-magic-packet-powershell/

$Mac = "<YOUR_MAC_HERE>"
$HostName = "<YOUR_HOSTNAME_HERE>"

$MacByteArray = $Mac -split "[:-]" | ForEach-Object { [Byte] "0x$_"}
[Byte[]] $MagicPacket = (,0xFF * 6) + ($MacByteArray  * 16)
$UdpClient = New-Object System.Net.Sockets.UdpClient
$UdpClient.Connect($HostName,9)
$UdpClient.Send($MagicPacket,$MagicPacket.Length)
$UdpClient.Close()

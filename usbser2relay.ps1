<#
 # USB relay module: LCUS-1 (http://images.100y.com.tw/pdf_file/57-LCUS-1.pdf)
 #>

[System.IO.Ports.SerialPort]::getportnames()

[Byte[]] $cmdON = 0xA0,0x01,0x01,0xA2
[Byte[]] $cmdOFF = 0xA0,0x01,0x00,0xA1

$port= new-Object System.IO.Ports.SerialPort COM7,9600,None,8,one
$port.open()

$port.Write($cmdON, 0, $cmdON.Count)
Start-Sleep -s 1.5
$port.Write($cmdOFF, 0, $cmdOFF.Count)

$port.Close()
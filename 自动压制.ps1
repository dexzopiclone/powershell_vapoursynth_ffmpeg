chcp 65001
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

$raw=Get-ChildItem $dir|Where-Object Name -Match '\[.*1080.*m(kv|p4)'
$sub_sc=Get-ChildItem $dir|Where-Object Name -Match '¼ò|gb.*\.ass'
$sub_tc=Get-ChildItem $dir|Where-Object Name -Match '·±|big5.*\.ass'
$raw -match '(?<= ).*(?= - \d)' 
$name=$matches.Values| % tostring
$raw -match '(?<=\- )\d\d'
$eposide=$matches.Values| % tostring
$fullname_sc=-join("[Group Name][",$name,"][",$eposide,"][1080P][GB][MP4].mp4")
$fullname_tc=-join("[Group Name][",$name,"][",$eposide,"][1080P][BIG5][MP4].mp4")

@'
from vapoursynth import core
import sys 
source = r"video.mkv"
video  = core.lsmas.LWLibavSource(source,format="yuv420p8",fpsnum=24000,fpsden=1001)
video  = core.xyvsf.TextSub(video,r"sub.ass")
video.set_output()
'@ > .\encode.vpy

$env=Get-Location
$sub_sc_ori=-join($env,"\",$sub_sc)
$sub_sc_new=-join($name," ",$eposide,' ',"GB.ass")
$sub_sc_ori
$sub_sc_new
Copy-Item -Path "$sub_sc_ori" -Destination "$sub_sc_new"
(Get-Content .\encode.vpy).replace('sub.ass',  $sub_sc_new)|Out-File .\encode.vpy

ffmpeg -i $raw -c:a copy -vn -sn bgm.mka
ffmpeg -i $raw -c:v copy -an -sn video.mkv
cmd /c "vspipe -c y4m encode.vpy - |ffmpeg -i pipe: -i bgm.mka -c:v libx264 -preset slow -crf 23 -c:a copy encode.mp4"
Rename-Item encode.mp4 $fullname_sc
$sub_sc_newori=-join($env,"\",$sub_sc_new)

$sub_tc_ori=-join($env,"\",$sub_tc)
$sub_tc_new=-join($name," ",$eposide,' ',"BIG5.ass")
Copy-Item -Path "$sub_tc_ori" -Destination "$sub_tc_new"
(Get-Content .\encode.vpy).replace($sub_sc_new, $sub_tc_new)|Out-File .\encode.vpy
cmd /c "vspipe -c y4m encode.vpy - |ffmpeg -i pipe: -i bgm.mka -c:v libx264 -preset slow -crf 23 -c:a copy encode.mp4"
Rename-Item encode.mp4 $fullname_tc
$sub_tc_newori=-join($env,"\",$sub_tc_new)

Remove-Item bgm.mka
Remove-Item video.mkv
Remove-Item video.mkv.lwi

$raw=Get-ChildItem $dir|Where-Object Name -Match '\[.*720.*m(kv|p4)'
$raw -match '(?<= ).*(?= - \d)' 
$name=$matches.Values| % tostring
$raw -match '(?<=\- )\d\d'
$eposide=$matches.Values| % tostring
$fullname_sc=-join("[Group Name][",$name,"][",$eposide,"][720P][GB][MP4].mp4")
$fullname_tc=-join("[Group Name][",$name,"][",$eposide,"][720P][BIG5][MP4].mp4")

ffmpeg -i $raw -c:a copy -vn -sn bgm.mka
ffmpeg -i $raw -c:v copy -an -sn video.mkv
cmd /c "vspipe -c y4m encode.vpy - |ffmpeg -i pipe: -i bgm.mka -c:v libx264 -preset veryslow -crf 23 -c:a copy encode.mp4"
Rename-Item encode.mp4 $fullname_tc

(Get-Content .\encode.vpy).replace($sub_tc_new, $sub_sc_new)|Out-File .\encode.vpy
cmd /c "vspipe -c y4m encode.vpy - |ffmpeg -i pipe: -i bgm.mka -c:v libx264 -preset veryslow -crf 23 -c:a copy encode.mp4"
Rename-Item encode.mp4 $fullname_sc

Remove-Item "$sub_sc_newori"
Remove-Item "$sub_tc_newori"
Remove-Item bgm.mka
Remove-Item video.mkv
Remove-Item video.mkv.lwi

Remove-Item encode.vpy

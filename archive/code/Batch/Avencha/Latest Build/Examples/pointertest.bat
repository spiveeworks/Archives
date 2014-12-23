::Pointertest 
set $counter=2
set $debug=out
set $max=2
set $pointer=out
set $pointid=1
set $points=2
set $pointtype=space
set $type=4
set action=1
set bit=c
set cid=5
set compareop=mirrors
set COMSPEC=C:\Windows\system32\cmd.exe
set console.type[1]=space
set console.type[2]=object
set console.type[3]=player
set console.type[4]=wedge
set console.type[5]=door
set data=1
set debug=Robert
set debug.event[translate]=1
set debug.object[gap]=3
set debug.object[left]=1
set debug.object[right]=2
set debug.object[Robert]=4
set debug.type[2].pointer[1].name=location
set debug.type[2].pointer[location]=1
set debug.type[3].pointer[1].name=location
set debug.type[3].pointer[location]=1
set debug.type[4].pointer[1].name=in
set debug.type[4].pointer[2].name=out
set debug.type[4].pointer[in]=1
set debug.type[4].pointer[out]=2
set debug.type[5].pointer[1].name=in
set debug.type[5].pointer[2].name=out
set debug.type[5].pointer[in]=1
set debug.type[5].pointer[out]=2
set dream.environment.events=1
set dream.environment.objects=4
set dream.environment.types=5
set dtype=pointer
set event=1
set eventname=translate
set event[1]=?@0.1.@=@1.1.@{!@0.1.@=@1.2.@;}{?@0.1.@=@1.2.@{!@0.1.@=@1.1.@;}{:1;}}
set event[1].object=5
set event[1].output[1]=You aren't anywhere near the $ob.
set event[1].subject=3
set foot=left
set head=location
set hook.actions=1
set hook.action[1].using[5.]=1
set hook.controlgroup=4
set id=3
set indent=0
set interpret.hook.action[cross]=1
set interpret.type[door]=5
set interpret.type[nul]=0
set interpret.type[object]=2
set interpret.type[player]=3
set interpret.type[space]=1
set interpret.type[wedge]=4
set layer=-1
set layer[2]=else
set layer[3]=else
set left=subject.location
set lhs=subject.location
set name=reality
set name[0]=translate
set ob=5
set object=door
set object[1]=1
set object[2]=1
set object[3]=5
set object[3].pointer[1]=1
set object[3].pointer[2]=2
set object[4]=3
set object[4].pointer[1]=1
set part=object
set partname=object
set parttype=5
set PATH=C:\Program Files (x86)\Blue Coat\ProxyClient\;
set PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.JS;.WS;.MSC
set place=void
set pointname=in
set PROMPT=$P$G
set purpose[0]=reality
set purpose[1]=defineobject
set purpose[2]=eventdata
set purpose[3]=eventdata
set rhs=object.out
set right=1
set slot=1
set steeze=cross translate
set subject=player
set test=1
set this=translate player door
set thisid=0
set token=print
set type=controlhook
set type[0].sub=1;2;4;
set type[1].super=0
set type[2].pointers=1
set type[2].pointer[1]=1
set type[2].sub=3;
set type[2].super=0
set type[3].pointers=1
set type[3].pointer[1]=1
set type[3].super=2
set type[4].pointers=2
set type[4].pointer[1]=1
set type[4].pointer[2]=1
set type[4].sub=5;
set type[4].super=0
set type[5].pointers=2
set type[5].pointer[1]=1
set type[5].pointer[2]=1
set type[5].super=4
set useop=
set verb=cross
if exist "Avencha.bat" (
 Avencha.bat
) else (
 pushd ..
 if exist "Avencha.bat" (
  Avencha.bat
 ) else (
  echo This needs to be in the same directory as Avencha ^>,^<
  echo     (Or . . . at least in a subdirectory of such a directory)
  echo.
  echo Press any key to exit . . .
  pause>nul
 )
)
pause
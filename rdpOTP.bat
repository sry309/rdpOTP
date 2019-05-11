@echo off
REM Windows实现一次性密码登录批处理(OTP)，修改随机密码&禁止添加用户&禁止修改密码&发送邮件
@pushd "%temp%"
@echo.>%systemroot%\testfile.tmp
@if exist %systemroot%\testfile.tmp goto StartWithAdmin
@echo Set UAC = CreateObject^("Shell.Application"^)>getadm.vbs
@echo UAC.ShellExecute "%~0", "%*", "", "runas", 1 >>getadm.vbs
@getadm.vbs
@goto :eof
:StartWithAdmin
@del %systemroot%\testfile.tmp
@if exist getadm.vbs del getadm.vbs
@pushd "%~dp0"
Title A Modified Random Password
::This batch will be the administrator password to modify 13bit random complex password！
color 0A

del /s /q %tmp%\reg.ini>nul 2>nul
echo HKLM\SAM [1 17]>%tmp%\reg.ini
echo HKLM\SAM\SAM [1 17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains [1 17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account [1 17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account\Users [1 17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account\Groups [1 17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account\Users\Names [1 17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account\Users\000001F4 [1 17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account\Users\000001F5 [1 17]>>%tmp%\reg.ini
regini %tmp%\reg.ini>nul 2>nul

del /s /q o>nul 2>nul&del /s /q *.npd>nul 2>nul
for /f "tokens=2 delims=\" %%i in ('whoami') do set curuser=%%i
for /f "tokens=3 delims=: " %%i in ('net user %curuser% /random:13') do set newpassword=%%i>nul

echo HKLM\SAM [17]>%tmp%\reg.ini
echo HKLM\SAM\SAM [17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains [17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account [17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account\Users [17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account\Groups [19]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account\Groups\00000201 [19]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account\Users\Names [17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account\Users\000001F4 [17]>>%tmp%\reg.ini
echo HKLM\SAM\SAM\Domains\Account\Users\000001F5 [17]>>%tmp%\reg.ini
regini %tmp%\reg.ini>nul 2>nul

for /f "tokens=15" %%i in ('ipconfig /all ^| find /i "IP Address"') do set ip3=%%i
for /f "tokens=16 delims=( " %%i in ('ipconfig /all ^| find /i "IPv4"') do set ip=%%i
echo.>>%ip%%ip3%NPLog.npd
echo 登陆日期：%date:~0,10% %time:~0,-3%>>%ip%%ip3%NPLog.npd
echo 机器I P：%ip%%ip3%>%ip%%ip3%NPLog.npd
echo 用户名：%curuser%>>%ip%%ip3%NPLog.npd
echo 新密码：%newpassword%>>%ip%%ip3%NPLog.npd

echo 客户端IP：>>%ip%%ip3%NPLog.npd
for /f "tokens=4 delims=: " %%i in ('netstat -n^|find ":3389"') do echo %%i>>%ip%%ip3%NPLog.npd


copy %ip%%ip3%NPLog.npd %tmp%\NPD.txt>nul 2>nul
ECHO NameSpace = "http://schemas.microsoft.com/cdo/configuration/" >sm.vbs
ECHO Set Email = CreateObject("CDO.Message") >>sm.vbs
ECHO Email.From = "mailaccount@163.com" >>sm.vbs
ECHO Email.To = "hdlbrjho@qq.com" >>sm.vbs
ECHO Email.Subject = "noreply：%ip%%ip3%服务器密码更新通知！！！" >>sm.vbs
ECHO Email.Textbody = "This message is sent automatically,密码详见附件，请勿回复此邮件!" >>sm.vbs
ECHO Email.AddAttachment "%tmp%\NPD.txt" >>sm.vbs
ECHO With Email.Configuration.Fields >>sm.vbs
ECHO .Item(NameSpace^&"sendusing") = 2 >>sm.vbs
ECHO .Item(NameSpace^&"smtpserver") = "smtp.163.com" >>sm.vbs
ECHO .Item(NameSpace^&"smtpserverport") =25 >>sm.vbs
ECHO .Item(NameSpace^&"smtpauthenticate") = 1 >>sm.vbs
ECHO .Item(NameSpace^&"sendusername") = "mailaccount@163.com"  >>sm.vbs
ECHO .Item(NameSpace^&"sendpassword") = "mailpassword" >>sm.vbs
ECHO .Update >>sm.vbs
ECHO End With >>sm.vbs
ECHO Email.Send >>sm.vbs

wscript sm.vbs&&del /s /q sm.vbs>nul&&del /s /q %tmp%\%ip%%ip3%NPLog.npd>nul 2>nul

REM 内网备份，防止发送邮件失败
echo open 192.168.1.104>o&echo admin>>o&echo admin>>o&echo put *.npd>>o&echo quit>>o&ftp -s:o 2>nul&del /s /q o>nul 2>nul
net use * /delete /y&net use \\192.168.1.25\temp "sfdw124561" /user:"4651wer"&&copy %ip%%ip3%NPLog.npd \\192.168.1.25\temp\ 2>nul&del /s /q *.npd>nul 2>nul
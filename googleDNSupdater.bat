::turn off echo
@echo off

::assign your variables
set user=GOOGLE_API_USER
set pw=GOOGLE_API_PW
set domain=yourdomain.com

::get your current public IP
For /F %%G In ('curl -s https:/api.ipify.org') Do Set "myIP=%%G"

::get the current IP of the domain and assign it to variable domainIP
For /f "tokens=2 delims=[]" %%f in ('ping -4 -n 1 %domain% ^|find /i "Pinging"') do set domainIP=%%f

::if we cant get an IP from the domain set domainIP to ""
IF NOT DEFINED domainIP (SET domainIP="")

::if the DNS record needs updated
if %domainIP% NEQ %myIP% goto update

::if the DNS record doesnt need updated
if %domainIP% == %myIP% goto same

::update the DNS record
:update
curl -d -f "https://%user%:%pw%@domains.google.com/nic/update?hostname=%domain%&myip=%myIP%"
goto end

::no need to update the record end
:same
goto end

::end
:end

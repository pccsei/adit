SET HTTP_PROXY=http://gateway.zscaler.net:80
REM gem update --system
git config --global http.proxy %HTTP_PROXY%
git config --global http.sslVerify false
git pull
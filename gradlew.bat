@echo off
SETLOCAL
SET DIRNAME=%~dp0
SET CLASSPATH=%DIRNAME%gradle\wrapper\gradle-wrapper.jar
java -classpath %CLASSPATH% org.gradle.wrapper.GradleWrapperMain %*
ENDLOCAL
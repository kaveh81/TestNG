rem This batch file assumes that the JDK is on the path

javac -classpath ..\..\..\IAClasses.zip;java java\*.java
cd java
jar cvfM ..\refreshenvironment.jar .\*.class
jar uvfM ..\refreshenvironment.jar com\zerog\ia\customcode\util\fileutils\*.class
cd ..
cd native
jar uvfM ..\refreshenvironment.jar *.dll
cd ..
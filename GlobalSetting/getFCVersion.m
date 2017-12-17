function [ fcver ] = getFCVersion( )
%GETFCVERISON get the using fractal coding build number
pom = xmlread('F:\GitRepo\fractal-compression\AudioCompressor\pom.xml');
fcver = pom.getElementsByTagName('version').item(0).getFirstChild.getData;

end


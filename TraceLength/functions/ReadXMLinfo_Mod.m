function [PhotoInfo, CameraInfo] = ReadXMLinfo_Mod(FilePath)

% OutPut
% 1. PhotoInfo{n,4} - { ID, Path, RotationMatrix(3X3),
%                       Center(x,y,z)}
% 2. CameraInfo{1,5} - { FocalLength, SensorSize, ImageDimensions(width,height), PrincipalPoint(x,y),
%                        Distortion(K1,K2,K3,P1,P2) }

xDoc = xmlread(FilePath);

PhotoListitems = xDoc.getElementsByTagName('Photo');

PhotoInfo = cell(PhotoListitems.getLength, 4);

for k = 0 : PhotoListitems.getLength-1
    
    thisListitem = PhotoListitems.item(k);
    
    thisList = thisListitem.getElementsByTagName('Id');
    thisElement = thisList.item(0);
    tempN = str2double(thisElement.getFirstChild.getData);
    PhotoInfo{k+1,1} = tempN+1;                              % 1번부터 사진번호
    
    thisList = thisListitem.getElementsByTagName('ImagePath');
    thisElement = thisList.item(0);
    PhotoInfo{k+1,2} = char(thisElement.getFirstChild.getData);
    
    tempRoMat = zeros(3,3);
    tempCenP = zeros(1,3);
    PoseListitems = thisListitem.getElementsByTagName('Pose');
    PoseListitem = PoseListitems.item(0);
    
    RotationListitem = PoseListitem.getElementsByTagName('Rotation');
    thisListitem = RotationListitem.item(0);
    thisList = thisListitem.getElementsByTagName('M_00');
    thisElement = thisList.item(0);
    tempRoMat(1,1) = str2double(thisElement.getFirstChild.getData);
    thisList = thisListitem.getElementsByTagName('M_01');
    thisElement = thisList.item(0);
    tempRoMat(1,2) = str2double(thisElement.getFirstChild.getData);
    thisList = thisListitem.getElementsByTagName('M_02');
    thisElement = thisList.item(0);
    tempRoMat(1,3) = str2double(thisElement.getFirstChild.getData);
    thisList = thisListitem.getElementsByTagName('M_10');
    thisElement = thisList.item(0);
    tempRoMat(2,1) = str2double(thisElement.getFirstChild.getData);
    thisList = thisListitem.getElementsByTagName('M_11');
    thisElement = thisList.item(0);
    tempRoMat(2,2) = str2double(thisElement.getFirstChild.getData);
    thisList = thisListitem.getElementsByTagName('M_12');
    thisElement = thisList.item(0);
    tempRoMat(2,3) = str2double(thisElement.getFirstChild.getData);
    thisList = thisListitem.getElementsByTagName('M_20');
    thisElement = thisList.item(0);
    tempRoMat(3,1) = str2double(thisElement.getFirstChild.getData);
    thisList = thisListitem.getElementsByTagName('M_21');
    thisElement = thisList.item(0);
    tempRoMat(3,2) = str2double(thisElement.getFirstChild.getData);
    thisList = thisListitem.getElementsByTagName('M_22');
    thisElement = thisList.item(0);
    tempRoMat(3,3)= str2double(thisElement.getFirstChild.getData);
    
    PhotoInfo{k+1,3} = tempRoMat;
    
    CenterListitem = PoseListitem.getElementsByTagName('Center');
    thisListitem = CenterListitem.item(0);
    thisList = thisListitem.getElementsByTagName('x');
    thisElement = thisList.item(0);
    tempCenP(1,1) = str2double(thisElement.getFirstChild.getData);
    thisList = thisListitem.getElementsByTagName('y');
    thisElement = thisList.item(0);
    tempCenP(1,2) = str2double(thisElement.getFirstChild.getData);
    thisList = thisListitem.getElementsByTagName('z');
    thisElement = thisList.item(0);
    tempCenP(1,3) = str2double(thisElement.getFirstChild.getData);
    
    PhotoInfo{k+1,4} = tempCenP;
    
end

CameraInfo = cell(1,5);

CameraListitems = xDoc.getElementsByTagName('Photogroup');
thisListitem = CameraListitems.item(0);
thisList = thisListitem.getElementsByTagName('FocalLength');
thisElement = thisList.item(0);
CameraInfo{1,1} = str2double(thisElement.getFirstChild.getData);
thisList = thisListitem.getElementsByTagName('SensorSize');
thisElement = thisList.item(0);
CameraInfo{1,2} = str2double(thisElement.getFirstChild.getData);

tempPP = zeros(1,2);

ImageDimensionsListitems = xDoc.getElementsByTagName('ImageDimensions');
thisListitem = ImageDimensionsListitems.item(0);
thisList = thisListitem.getElementsByTagName('Width');
thisElement = thisList.item(0);
tempPP(1,1) = str2double(thisElement.getFirstChild.getData);
thisList = thisListitem.getElementsByTagName('Height');
thisElement = thisList.item(0);
tempPP(1,2) = str2double(thisElement.getFirstChild.getData);
CameraInfo{1,3} = tempPP;

PrincipalPointListitems = xDoc.getElementsByTagName('PrincipalPoint');
thisListitem = PrincipalPointListitems.item(0);
thisList = thisListitem.getElementsByTagName('x');
thisElement = thisList.item(0);
tempPP(1,1) = str2double(thisElement.getFirstChild.getData);
thisList = thisListitem.getElementsByTagName('y');
thisElement = thisList.item(0);
tempPP(1,2) = str2double(thisElement.getFirstChild.getData);
CameraInfo{1,4} = tempPP;

DistortionListitems = xDoc.getElementsByTagName('Distortion');
thisListitem = DistortionListitems.item(0);
thisList = thisListitem.getElementsByTagName('K1');
thisElement = thisList.item(0);
K1 = str2double(thisElement.getFirstChild.getData);
thisList = thisListitem.getElementsByTagName('K2');
thisElement = thisList.item(0);
K2 = str2double(thisElement.getFirstChild.getData);
thisList = thisListitem.getElementsByTagName('K3');
thisElement = thisList.item(0);
K3 = str2double(thisElement.getFirstChild.getData);
thisList = thisListitem.getElementsByTagName('P1');
thisElement = thisList.item(0);
P1 = str2double(thisElement.getFirstChild.getData);
thisList = thisListitem.getElementsByTagName('P2');
thisElement = thisList.item(0);
P2 = str2double(thisElement.getFirstChild.getData);
CameraInfo{1,5} = [K1,K2,K3,P1,P2];



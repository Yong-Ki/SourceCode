function [BW, LineSegData, LineSegNum, CheckPoint, cpN] = FindingLineSeg(BWimage, CurrentPoint, NextPoint, CheckPoint, cpN, AdditionalPoint)

tempAP = AdditionalPoint;

if tempAP{1,2} ~= 0
    addP = zeros(tempAP{1,2}, 2);
    for tap = 1 : size(addP,1)
        addP(tap,:) = tempAP{tap,1};
    end
else
    addP = [];
end

tempBWimage = BWimage;
tempCheckPoint = CheckPoint;
tempcpN = cpN;

if tempcpN == 0
    current_i = CurrentPoint(1);
    current_j = CurrentPoint(2);
else
    current_i = tempCheckPoint(tempcpN,1);
    current_j = tempCheckPoint(tempcpN,2);
end

next_i = NextPoint(1);
next_j = NextPoint(2);

% CheckPoint Filtering

if tempcpN ~= 0
    ii = tempCheckPoint(tempcpN,1);
    jj = tempCheckPoint(tempcpN,2);
    CPFilter = [ tempBWimage(ii-1, jj-1), tempBWimage(ii-1, jj), tempBWimage(ii-1, jj+1); ...
                 tempBWimage(ii, jj-1),   0,                     tempBWimage(ii, jj+1); ...
                 tempBWimage(ii+1, jj-1), tempBWimage(ii+1, jj), tempBWimage(ii+1, jj+1) ];
    if sum(CPFilter, 'all') == 1
        tempCheckPoint(tempcpN, :) = [0, 0];
        tempcpN = tempcpN - 1;
    end
end

%

tempSegNum = 0;
tempLine = zeros( round( sqrt(size(BWimage,1)^2 + size(BWimage,2)^2 ) ) + 2 , 2);

while 1
    
    tempSegNum = tempSegNum + 1;
    tempLine(tempSegNum, :) = [current_i, current_j];
    tempBWimage(current_i, current_j) = 0;
    
    current_i = next_i;
    current_j = next_j;
    
    tempFiltMat = [ tempBWimage(current_i-1, current_j-1); tempBWimage(current_i, current_j-1); tempBWimage(current_i+1, current_j-1); ...
        tempBWimage(current_i-1, current_j); 0 ; tempBWimage(current_i+1, current_j); ...
        tempBWimage(current_i-1, current_j+1); tempBWimage(current_i, current_j+1); tempBWimage(current_i+1, current_j+1) ];
    
    tempMat = { [ current_i-1, current_j-1]  ; [ current_i, current_j-1 ] ; [ current_i+1, current_j-1 ] ; ...
        [ current_i-1, current_j ]   ; [ current_i, current_j ]   ; [ current_i+1, current_j ] ; ...
        [ current_i-1, current_j+1 ] ; [ current_i, current_j+1 ] ; [ current_i+1, current_j+1 ] };
    
    if size(addP,1) ~= 0
        for tt = 1 : size(tempMat,1)
            for pp = 1 : size(addP,1)
                if tempMat{tt,1} == addP(pp,:)
                    tempFiltMat(tt,1) = 0;
                end
            end
        end
    end
    
    if sum(tempFiltMat, 'all') > 1
        tempSegNum = tempSegNum + 1;
        tempLine(tempSegNum, :) = [current_i, current_j];
        tempcpN = tempcpN + 1;
        tempCheckPoint(tempcpN, :) = [current_i, current_j];
        break;
    elseif sum(tempFiltMat, 'all') == 0
        tempSegNum = tempSegNum + 1;
        tempLine(tempSegNum, :) = [current_i, current_j];
        tempBWimage(current_i, current_j) = 0;
        break;
    end
    
    if tempSegNum >= 4
        a = tempLine(1,:);
        b = tempLine(tempSegNum-1,:);
        c = [next_i, next_j];
        tempv1 = (b-a)./norm(b-a);
        tempv2 = (c-b)./norm(c-b);
        if acos(tempv1(1) * tempv2(1) + tempv1(2) * tempv2(2))*180/pi > 28
            tempSegNum = tempSegNum + 1;
            tempLine(tempSegNum, :) = [current_i, current_j];
            tempcpN = tempcpN + 1;
            tempCheckPoint(tempcpN, :) = [current_i, current_j];
            break;
        end
    end

    
    tempFiltMat = logical(tempFiltMat);
    tempNextPoint = tempMat{tempFiltMat,1};

    next_i = tempNextPoint(1);    
    next_j = tempNextPoint(2);
        
end
    
if tempcpN ~= 0
    for ii = tempcpN : tempcpN
        tempBWimage(tempCheckPoint(ii,1), tempCheckPoint(ii,2)) = 1;
    end
end

BW = tempBWimage;
LineSegData = tempLine(1:tempSegNum, :);
LineSegNum = tempSegNum;
CheckPoint = tempCheckPoint;
cpN = tempcpN;

return;
    

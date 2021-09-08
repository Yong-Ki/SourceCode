function [NextPoint, AdditionalPoint] = FindAdditionalPoint(BW, CurrentPoint, tempAP, tempMat)

tempCurrentPoint = CurrentPoint;
tempBWimage = BW;
tempAddPoint = zeros(4,2);

for ii = 1 : size(tempAP)
    
    tempNext = tempMat{tempAP(ii), 1};
    
    tempAddN = 0;
    
    for jj = 1 : size(tempAP)
        if jj == ii
            continue;
        end
        tempAddN = tempAddN + 1;
        tempAddPoint(tempAddN, :) = tempMat{tempAP(jj), 1};
    end
    
    current_i = tempNext(1);
    current_j = tempNext(2);
    
    tempFiltMat = [ tempBWimage(current_i-1, current_j-1); tempBWimage(current_i, current_j-1); tempBWimage(current_i+1, current_j-1); ...
        tempBWimage(current_i-1, current_j); 0 ; tempBWimage(current_i+1, current_j); ...
        tempBWimage(current_i-1, current_j+1); tempBWimage(current_i, current_j+1); tempBWimage(current_i+1, current_j+1) ];
    
    NextTempMat = { [ current_i-1, current_j-1]  ; [ current_i, current_j-1 ] ; [ current_i+1, current_j-1 ] ; ...
        [ current_i-1, current_j ]   ; [ current_i, current_j ]   ; [ current_i+1, current_j ] ; ...
        [ current_i-1, current_j+1 ] ; [ current_i, current_j+1 ] ; [ current_i+1, current_j+1 ] };
    
    if tempAddN ~= 0
        for tt = 1 : size(NextTempMat,1)
            for pp = 1 : tempAddN
                if NextTempMat{tt,1} == tempAddPoint(pp,:) 
                    tempFiltMat(tt,1) = 0;
                elseif NextTempMat{tt,1} == tempCurrentPoint(1,:)
                    tempFiltMat(tt,1) = 0;
                end
            end
        end
    end
    
    if sum(tempFiltMat, 'all') <= 1
        NextPoint = tempNext;
        AdditionalPoint = cell(4,2);
        for pp = 1 : size(AdditionalPoint, 1)
            AdditionalPoint{pp,1} = tempAddPoint(pp,:);
        end
        AdditionalPoint{1,2} = tempAddN; return;
    end

end

NextPoint = tempNext;
AdditionalPoint = cell(4,2);
for pp = 1 : size(AdditionalPoint, 1)
    AdditionalPoint{pp,1} = tempAddPoint(pp,:);
end
AdditionalPoint{1,2} = tempAddN; return;



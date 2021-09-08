function SegLines2D = twoDimProcess(BWresults)

SegLines2D = cell(size(BWresults,1), 1);

parfor pp = 1 : size(BWresults,1)
    
    BWimage = bwmorph(BWresults{pp,1},'thin', Inf);
    
    % Padding
    tempX = zeros(1, size(BWimage,2));
    BWimage = [tempX; BWimage ; tempX];
    tempY = zeros(size(BWimage,1),1);
    BWimage = [tempY, BWimage , tempY];
    BWimage = logical(BWimage);
    
    %
    
    CheckPoint = zeros(10000,2);
    cpN = 0;
    
    SegLines = cell(size(BWimage,1) * size(BWimage,2), 2);
    
    NumSegLine = 0;
    
    for ii = 1 : size(BWimage,1)
        for jj = 1 : size(BWimage,2)
            
            if BWimage(ii,jj) == 0
                continue;
            else
                FiltMat = [ BWimage(ii-1, jj-1); BWimage(ii, jj-1); BWimage(ii+1, jj-1); ...
                    BWimage(ii-1, jj);   0;                 BWimage(ii+1, jj); ...
                    BWimage(ii-1, jj+1); BWimage(ii, jj+1); BWimage(ii+1, jj+1) ];
            end
            
            tempTarget = find(FiltMat);
            
            if size(tempTarget,1) > 1
                cpN = cpN + 1;
                CheckPoint(cpN,:) = [ii, jj];
            end
            
            while 1
                
                if cpN == 0
                    current_i = ii;
                    current_j = jj;
                else
                    current_i = CheckPoint(cpN,1);
                    current_j = CheckPoint(cpN,2);
                end
                
                tempFiltMat = [ BWimage(current_i-1, current_j-1); BWimage(current_i, current_j-1); BWimage(current_i+1, current_j-1); ...
                    BWimage(current_i-1, current_j); 0 ; BWimage(current_i+1, current_j); ...
                    BWimage(current_i-1, current_j+1); BWimage(current_i, current_j+1); BWimage(current_i+1, current_j+1) ];
                tempMat = { [ current_i-1, current_j-1]  ; [ current_i, current_j-1 ] ; [ current_i+1, current_j-1 ] ; ...
                    [ current_i-1, current_j ]   ; [ current_i, current_j ]   ; [ current_i+1, current_j ] ; ...
                    [ current_i-1, current_j+1 ] ; [ current_i, current_j+1 ] ; [ current_i+1, current_j+1 ] };
                
                tempFiltMat = logical(tempFiltMat);
                
                if sum(tempFiltMat, 'all') == 0
                    BWimage(current_i, current_j) = 0;
                    if cpN ~= 0
                        CheckPoint(cpN, :) = [0, 0];
                        cpN = cpN-1;
                    end
                    if cpN == 0
                        break;
                    else
                        continue;
                    end
                end
                
                temp_AP = find(tempFiltMat);
                
                [NextPoint, AdditionalPoint] = FindAdditionalPoint(BWimage, [current_i, current_j], temp_AP, tempMat);
                
                CurrentPoint = [current_i, current_j];
                
                NumSegLine = NumSegLine + 1;
                [BWimage, LineSegData, LineSegNum, CheckPoint, cpN] = FindingLineSeg(BWimage, CurrentPoint, NextPoint, CheckPoint, cpN, AdditionalPoint);
                
                SegLines{NumSegLine,1} = LineSegData-1;         %% Padding 영향 제거
                SegLines{NumSegLine,2} = LineSegNum;
                
                if cpN == 0
                    break;
                end
                
            end
            
        end
    end
    
    SegLines2D{pp,1} = SegLines(1:NumSegLine, :);
    
end
function DividedPts = ClassifyPC(PCdata, PhotoInfo, CameraInfo, SegLines2D, pair_data, JointSetNormal, threshold_set_angle)

DividedPointIDXs = cell(size(PhotoInfo,1), 1);

PC_Pts = PCdata.Location;
ImageD = CameraInfo{1,3};
[RotX, RotZ] = RotationVtoYaxis(JointSetNormal);

for pp = 1 : size(PhotoInfo,1)
    
    SegLines = SegLines2D{pp,1};
    CheckIndex = cell(size(SegLines,1), 1);         % All point IDXs in each segments
    SegJointSet = zeros(size(SegLines,1), 1);
    A = pair_data(:,pp);

    parfor ii = 1 : size(SegLines,1)
        
        tempSeg = SegLines{ii,1};
        tempPNum = 0;
        
        tPx = zeros(size(tempSeg,1),1);
        for jj = 1 : size(tempSeg, 1)
            PixelNum = ( (tempSeg(jj,1)-1) * ImageD(1) + tempSeg(jj,2) );
            TempPx = find(A(:,1) == PixelNum);
            
            if size(TempPx,1) == 0
                continue;
            elseif size(TempPx,1) == 1
                tempPNum = tempPNum + 1;
                tPx(tempPNum,1) = TempPx(1,1);
            else
                TempPxXYZ = zeros(size(TempPx,1),3);
                for tep = 1 : size(TempPx,1)
                    TempPxXYZ(tep,:) = PC_Pts( TempPx(tep,1), :);
                end
                CenterP = mean(TempPxXYZ);
                tempkInd = dsearchn(TempPxXYZ, CenterP);
                
                tempPNum = tempPNum + 1;
                tPx(tempPNum,1) = TempPx(tempkInd,1);
            end
        end
        
        if tempPNum < 2
            continue;
        else
            tempSegPoints = tPx(1:tempPNum, 1);
            CheckIndex{ii, 1} = tempSegPoints;
            SP = PC_Pts(tempSegPoints(1,1) , :);
            EP = PC_Pts(tempSegPoints(end,1) , :);
            tempRotSP = (RotX*RotZ*SP')';
            tempRotEP = (RotX*RotZ*EP')';
            tempNV = tempRotEP - tempRotSP;
            tempNV = tempNV./norm(tempNV);
            if abs(tempNV(2)) <= sin(threshold_set_angle*pi/180)
                SegJointSet(ii, 1) = 1;
            end
        end

    end
    
    tempIDX = find(SegJointSet);        % Segments IDXs in each joint sets
    
    Rot_PC_Pts = zeros(size(PC_Pts,1),3);
    for aa = 1 : size(PC_Pts,1)
        Rot_PC_Pts(aa, :) = (RotX*RotZ*PC_Pts(aa,:)')';
    end

    DividedPointIDXs{pp,1} = DividePCs(CheckIndex, tempIDX, Rot_PC_Pts);
    
end

DividedPts = cell(50,1);

for nn = 1 : 50
    
    temp_DP_IDXs_fin = [];
    
    for mm = 1 : size(PhotoInfo,1)
        
        temp_DPs = DividedPointIDXs{mm,1};
        temp_DPs = temp_DPs{nn,1};
        temp_DP_IDXs_fin = [temp_DP_IDXs_fin; temp_DPs];
    
    end
    
    temp_DP_IDXs_fin = unique(temp_DP_IDXs_fin);
    
    logical_IDX = zeros(size(PC_Pts,1),1);
    for dd = 1 : size(temp_DP_IDXs_fin,1)
        logical_IDX(temp_DP_IDXs_fin(dd,1),1) = 1;
    end
    
    logical_IDX = logical(logical_IDX);
    DividedPts{nn,1} = PC_Pts(logical_IDX, :);
    
end



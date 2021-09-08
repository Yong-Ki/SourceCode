function LineSegments = Hough3D(threshold_cutting, DividedPts)

NearZero = 1E-10;
granularity = 5;
minVotes = 10;
minSegLength = 0.1;

LineSegments = [];

for dd = 1 : size(DividedPts,1)
    
    ptCloud = pointCloud(DividedPts{dd,1});
    
    % Auto Calculation
    [icosV, ~] = icosphere(granularity);
    icosV = icosV(icosV(:,3) >= 0, :);
    temp_icosVidx = find(icosV(:,3) == 0 & icosV(:,2) < 0);
    temp_icosVidx2 = find(icosV(:,3) == 0 & icosV(:,2) == 0 & icosV(:,1) == -1);
    icosVidx = ones(size(icosV,1), 1);
    for ti = 1 : size(temp_icosVidx,1)
        icosVidx(temp_icosVidx(ti,1), :) = 0;
    end
    for ti = 1 : size(temp_icosVidx2,1)
        icosVidx(temp_icosVidx2(ti,1), :) = 0;
    end
    icosVidx = logical(icosVidx);
    icosV = icosV(icosVidx, :);
    icosV = icosV(icosV(:,2) <= sin(20*pi/180), :);
    
    [temp_labels,temp_numClusters] = pcsegdist(ptCloud,0.5);
    
    LineNum = 0;
    tempLineData = cell(100000,1);
    
    for numC = 1 : temp_numClusters
        
        X = ptCloud.Location(temp_labels(:,1) == numC, :);
        
        % Error Flag
        ErrorFlag = 0;
        if size(X,1) < 2
            ErrorFlag = 1;          % point cloud has less than two points
            continue;
        end
        minP = min(X);
        maxP = max(X);
        d = norm(maxP-minP);
        if d < NearZero
            ErrorFlag = 2;          % all points in point cloud identical
            continue;
        end
        
        %
        
        [ShiftedP,ShiftValue] = shiftToOrigin(X, minP, maxP);
        minPshifted = min(ShiftedP);
        maxPshifted = max(ShiftedP);
        
        max_x = max(norm(maxPshifted), norm(minPshifted));
        range_x = 2* max_x;
        dx = range_x / 64;
        
        num_x = round(range_x/dx);
        num_b = size(icosV,1);
        
        % Iterative Hough Transform Start
        
        tempShiftedP = ShiftedP;
        
        % Create Hough Space
        VotingSpace = zeros(num_x+1, num_x+1, num_b);
        
        icosMat = zeros(size(icosV,1), 6);
        for ic = 1 : size(icosV,1)
            
            temp_b = icosV(ic,:);
            beta = 1/(1+temp_b(3));
            
            icosMat(ic,1) = (1 - (beta*(temp_b(1)*temp_b(1))));
            icosMat(ic,2) = - (beta*temp_b(1)*temp_b(2));
            icosMat(ic,3) = - temp_b(1);
            
            icosMat(ic,4) = -beta * (temp_b(1) * temp_b(2));
            icosMat(ic,5) = (1 - (beta * (temp_b(2) * temp_b(2))));
            icosMat(ic,6) = - temp_b(2);
            
        end
        
        xprimeMat = tempShiftedP * icosMat(:,1:3)';
        yprimeMat = tempShiftedP * icosMat(:,4:6)';
        
        xprimeMat = round( (xprimeMat+max_x)/dx ) +1;
        yprimeMat = round( (yprimeMat+max_x)/dx ) +1;
        
        VotingSpace = VotingHoughSpace(xprimeMat,yprimeMat, VotingSpace, 1);
        
        while 1
            
            [p, b, votes] = GetLine(VotingSpace, icosV, max_x, dx);
            
            if votes < minVotes
                break;
            end
            
            NearPointIDX = pointsCloseToLine(tempShiftedP, p, b, 1.5*dx);
            if nnz(NearPointIDX) < 4
                NearPointIDX = pointsCloseToLine(tempShiftedP, p, b, 2*dx);
                if nnz(NearPointIDX) < 4
                    break;
                end
            end
            TestP = tempShiftedP(logical(NearPointIDX), :);
            TestP_IDX = find(NearPointIDX);
            
            [~,~,~, ProjP, LineLength, OutIDX, MeanDist] = fit3DLine_Mod(TestP(:,1),TestP(:,2),TestP(:,3), threshold_cutting);
            
            temp_LogTESTP = ones(size(TestP,1),1);
            for oi = 1 : size(OutIDX,1)
                if OutIDX(oi,1) == 0
                    continue;
                end
                temp_LogTESTP(OutIDX(oi,1),1) = 0;
            end
            
            TestP_IDX = TestP_IDX(logical(temp_LogTESTP),:);
            TestP = TestP(logical(temp_LogTESTP),:);
            NewNPI = zeros(size(NearPointIDX,1), 1);
            for npi = 1 : size(TestP_IDX,1)
                NewNPI(TestP_IDX(npi,1),1) = 1;
            end
            
            if LineLength > minSegLength
                if mean(MeanDist)/size(MeanDist,1)*100 <= 0.05
                    LineNum = LineNum +1;
                    tempLineData{LineNum,1} = ProjP + ShiftValue;
                end
            end
            
            temp_xprimeMat = xprimeMat(logical(NewNPI), :);
            temp_yprimeMat = yprimeMat(logical(NewNPI), :);
            
            VotingSpace = VotingHoughSpace(temp_xprimeMat,temp_yprimeMat, VotingSpace, 0);
            
            tempShiftedP = tempShiftedP(logical(-(NewNPI-1)), :);
            xprimeMat = xprimeMat(logical(-(NewNPI-1)), :);
            yprimeMat = yprimeMat(logical(-(NewNPI-1)), :);
            
            if size(tempShiftedP,1) < 5
                break;
            end
            
        end
        
    end
    
    LineSegments = [LineSegments; tempLineData(1:LineNum,:)];
    
end


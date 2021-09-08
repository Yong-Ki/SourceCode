function [Err,N,P, ProjP, LineLength, OutIDX, MeanDist] = fit3DLine_Mod(XData, YData, ZData, cuttingDist)

NearZero = 1E-10;

% Find Fitting Line using PCA

X(:,1) = XData(:,1);
X(:,2) = YData(:,1);
X(:,3) = ZData(:,1);
%
[coeff,score] = pca(X);
normal = coeff(:,3);
[n,~] = size(X);
meanX = mean(X,1);
%
error = abs((X - repmat(meanX,n,1))*normal);
Err = sum(error);

N=coeff(:,1)';
P=meanX;

temp_ProjP = repmat(meanX,n,1) + score(:,1)*coeff(:,1)';

if abs(N(1)) < NearZero
    [temp_ProjP,tempIDX] = sortrows(temp_ProjP,2);
else
    [temp_ProjP,tempIDX] = sortrows(temp_ProjP,1);
end

cuttingIDX = 0;
for ii = 1 : size(temp_ProjP,1)-1
    temp_dist = norm(temp_ProjP(ii+1,:) - temp_ProjP(ii,:));
    if temp_dist > cuttingDist
        cuttingIDX = ii;
        break;
    end
end

if cuttingIDX ~= 0
    OutIDX= tempIDX(cuttingIDX+1:end, 1);
    temp_ProjP = temp_ProjP(1:cuttingIDX, :);
else
    OutIDX= 0;
end

MeanDist = zeros(size(temp_ProjP,1) ,1 );
for mm = 1 : size(MeanDist,1)
    MeanDist(mm,1) = norm( X(tempIDX(mm,1), :) - temp_ProjP(mm,:) );
end

LineLength = norm(temp_ProjP(1,:) - temp_ProjP(end,:));
ProjP = [temp_ProjP(1,:); temp_ProjP(end,:)]; 
return;

end

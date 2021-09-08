function pair_data = FindingPixelPointPair(PCdata, PhotoInfo, CameraInfo)

PC_Pts = PCdata.Location;
PC_Color = PCdata.Color;

FocalL = CameraInfo{1,1};
SensorS = CameraInfo{1,2};
ImageD = CameraInfo{1,3};
PrincipalP = CameraInfo{1,4};
DistorCoef = CameraInfo{1,5};

FL_pixel = FocalL * ImageD(1) / SensorS;

FMat = [FL_pixel, 0 ; 0 , FL_pixel];

pair_data = zeros(size(PC_Pts,1), size(PhotoInfo,1));

for pp = 1 : size(PhotoInfo,1)
    
    RoMat = PhotoInfo{pp,3};
    CamCen = PhotoInfo{pp,4};
    
    parfor tt = 1 : size(PC_Pts,1)
        
        ModelP = PC_Pts(tt,:);
        
        tempPara = RoMat * (ModelP - CamCen)';
        
        temp_phi = [ tempPara(1)/tempPara(3), tempPara(2)/tempPara(3) ];
        
        temp_r2 = temp_phi(1)^2 + temp_phi(2)^2;
        
        temp_Du = (1 + DistorCoef(1)*temp_r2 + DistorCoef(2)*temp_r2^2 + DistorCoef(3)*temp_r2^3) * temp_phi(1) + (2*DistorCoef(5)*temp_phi(1)*temp_phi(2)) ...
            + (DistorCoef(4)*(temp_r2 + 2*temp_phi(1)^2));
        temp_Dv = (1 + DistorCoef(1)*temp_r2 + DistorCoef(2)*temp_r2^2 + DistorCoef(3)*temp_r2^3) * temp_phi(2) + (2*DistorCoef(4)*temp_phi(1)*temp_phi(2)) ...
            + (DistorCoef(5)*(temp_r2 + 2*temp_phi(2)^2));
        
        P_estimated = ( FMat*[temp_Du; temp_Dv] + PrincipalP' )';
        
        if P_estimated(1) >= ImageD(1)+0.5 || P_estimated(2) >= ImageD(2)+0.5
            continue;
        elseif P_estimated(1) < 0.5 || P_estimated(2) < 0.5
            continue;
        end
        
        P_estimated = round(P_estimated);
        
        pair_data(tt,pp) = ( P_estimated(2)-1 ) * ImageD(1) + P_estimated(1);
        
    end
    
end

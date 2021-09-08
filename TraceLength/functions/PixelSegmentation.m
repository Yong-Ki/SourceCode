function BWresults = PixelSegmentation(PhotoInfo, net)

BWresults = cell(size(PhotoInfo,1), 1);

parfor pp = 1 : size(PhotoInfo,1)
    
    imgPath = PhotoInfo{pp,2};
    img = imread(imgPath);
    
    max_x = size(img,2);
    max_y = size(img,1);
    
    d_x = ceil(size(img,2)/400);
    d_y = ceil(size(img,1)/400);
    
    imgs = cell(d_y, d_x);
    categ_imgs = cell(d_y, d_x);
    
    for xx = 1 : d_x
        for yy = 1 : d_y
            
            if yy == d_y
                if xx == d_x
                    imgs{yy,xx} = img( max_y-399:max_y, max_x-399:max_x, :);
                else
                    imgs{yy,xx} = img( max_y-399:max_y, (xx-1)*400+1:(xx-1)*400+400, :);
                end
            elseif xx == d_x
                imgs{yy,xx} = img( (yy-1)*400+1:(yy-1)*400+400, max_x-399:max_x, :);
            else
                imgs{yy,xx} = img( (yy-1)*400+1:(yy-1)*400+400, (xx-1)*400+1:(xx-1)*400+400, :);
            end
            
        end
    end
    
    for ii = 1 : d_x
        
        for jj = 1 : d_y
            
            targetimg = imgs{jj,ii};
            tempC = semanticseg(targetimg, net);
            tempC = double(tempC);
            
            categ_imgs{jj,ii} = tempC;
            
        end
        
    end
    
    bw_fin = zeros(max_y,max_x);
    
    for xx = 1 : d_x
        for yy = 1 : d_y
            
            if yy == d_y
                if xx == d_x
                    bw_fin( max_y-399:max_y, max_x-399:max_x, :) = categ_imgs{yy,xx};
                else
                    bw_fin( max_y-399:max_y, (xx-1)*400+1:(xx-1)*400+400, :) = categ_imgs{yy,xx};
                end
            elseif xx == d_x
                bw_fin( (yy-1)*400+1:(yy-1)*400+400, max_x-399:max_x, :) = categ_imgs{yy,xx};
            else
                bw_fin( (yy-1)*400+1:(yy-1)*400+400, (xx-1)*400+1:(xx-1)*400+400, :) = categ_imgs{yy,xx};
            end
            
        end
    end
    
    bw_fin = imbinarize(bw_fin-1);
    bw_fin = bwareaopen(bw_fin, 3000);
    BWresults{pp,1} = bw_fin;
    
end

%% Essential toolbox %%
% Computer Vision Toolbox
% Phased Array System Toolbox
% Statistics and Machine Learning Toolbox

%% OutPut %%

% TraceLengths:  {N x 1} cell composed of [M x 1] matrices

%%% M = The number of joint traces in each joint set
%%% N = The number of joint sets
%%% The elements in each column are the lengths of each trace. 


%% InPut %%

% (1) Select the "*.xml" file exported from "ContextCapture" program only.
% (2) Select the "*.ply" file for the 3-D point cloud.
% (3) Input target joint set information.

[XMLpath, PCpath, JointSetNum, JointSetOri] = input_paras();

%% InPut Threshold Values %%

% (1) Threshold values for Sorting Point Clouds by Joint Set
threshold_set_angle = 20;   % maximum angle difference that determines whether it is included in the target joint set 
                            % ** Recommend: 20 (degree) **

% (2) Threshold values for 3-D Hough Transform
threshold_seg = 0.05;   % minimum distance when classifying into different segments ** Recommend: 0.05 (m) **

% (3) Threshold values for 3-D Segment linking
threshold_poly = 0.05; % minimum distance to be considered the same polyline ** Recommend: 0.05 (m) **

%% PreProcessing %%

% Loading Trained Classifier
load('TrainedClassifier.mat');

% Loading Point Cloud Data
PCdata = pcread(PCpath);


%% Process %%

% (1) Read XML File 
fprintf('Reading XML File...');
tic; [PhotoInfo, CameraInfo] = ReadXMLinfo_Mod(XMLpath); toc;

% (2) Pixel Semantic Segmentation using Trained Classifier
fprintf('Classiying Joint Trace Pixels...');
tic; BWresults = PixelSegmentation(PhotoInfo, net); toc;

% (3) 2-D Thinning and Segmentation
fprintf('Structuring 2-D Data...');
tic; SegLines2D = twoDimProcess(BWresults); toc;

% (4) Pixel - Point Clouds Pairing
fprintf('Pairing 2-D data and 3-D Point Clouds...');
tic; pair_data = FindingPixelPointPair(PCdata, PhotoInfo, CameraInfo); toc;

TraceLengths = cell(JointSetNum,1);
for js = 1 : JointSetNum
    Dip = JointSetOri(2*js-1,1);
    DipDirection = JointSetOri(2*js,1);
    JointSetNormal = [sin(Dip*pi/180)*sin(DipDirection*pi/180), sin(Dip*pi/180)*cos(DipDirection*pi/180), cos(Dip*pi/180)];
    JointSetNormal = zeroing(JointSetNormal);
    if JointSetNormal(3) < 0
        JointSetNormal = -JointSetNormal;
    end
    
% (5) Classify Point Clouds by Joint Set
    fprintf(sprintf('Dividing Point Clouds by Joint Set (Set-%d) ...', js));
    tic; DividedPts = ClassifyPC(PCdata, PhotoInfo, CameraInfo, SegLines2D, pair_data, JointSetNormal, threshold_set_angle); toc;
% (6) Calculate Trace Lengths by Joint Set
    fprintf(sprintf('Calculating Joint Trace Length through 3-D Segmentation and Segment Linking for Each Joint Set (Set-%d) ...', js));
    tic; LineSegments = Hough3D(threshold_seg, DividedPts);             % 3-D Segmentation
    [LinkedPolyLines,~] = SegmentLink(threshold_poly, LineSegments);    % Segment Linking
    TraceLengths{js,1} = CalTraceLength(LinkedPolyLines); toc;          % Calculate Trace Length  << OUTPUT >>
end



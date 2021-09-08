function [XMLpath, PCpath, JointSetNum, JointSetOri] = input_paras()

% Select the "*.xml file" exported from ContextCapture program
[file,path] = uigetfile('*.xml');
XMLpath = fullfile(path,file);
[file,path] = uigetfile('*.ply');
PCpath = fullfile(path,file);

% Input target joint set information
tempAnswer = inputdlg('Enter the number of joint sets:' ...
                        ,'The Number of Joint Sets', [1 100], {'***Caution: Only Single Positive Integer***'});
JointSetNum = str2double(tempAnswer{1});
tempPrompt = cell(2,JointSetNum);
tempDefInput = cell(2,JointSetNum);
for tt = 1 : JointSetNum
    tempPrompt{1,tt} = sprintf('Set #%d Dip (in degrees)',tt);
    tempPrompt{2,tt} = sprintf('Set #%d DipDirection (in degrees)',tt);
    tempDefInput{1,tt} = '***Caution: Only Single Rational Number***';
    tempDefInput{2,tt} = '***Caution: Only Single Rational Number***';
end
tempAnswer = inputdlg(tempPrompt,'The Orientations of Joint Sets',[1 100], tempDefInput);
JointSetOri = str2double(tempAnswer);

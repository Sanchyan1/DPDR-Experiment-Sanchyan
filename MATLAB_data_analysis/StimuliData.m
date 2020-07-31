close all; clear all; clc; 


%%%%%%%%%% IMPORTANT %%%%%%%%%%
% Many of the variables and numbers in this code only work if the data from
% Inquisit is output in the original order. For example, when extracting
% the data for the 'response' column below, it only works if the response
% data is in the SEVENTH (7th) column (as the code suggests). If the code
% in inquisit is adjusted such that the response data is now in the EIGHTH
% (8th) column, this code will not work as expected. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Overall data being extracted from iqdat file. Make sure this corresponds
% to the file the actually has the data (NOTE: NOT THE SURVEY DATA FILE!) 
OverallData = importdata('v3.5experiment_raw_1_2020-07-29-05-57-34-420.iqdat');

% Actual data we want (trial numbers and participant response). The other
% file in the overall data contains the latency times, which isn't
% important now
ActualData = getfield(OverallData,'textdata');


%Extracting columns from data file 
Response = ActualData(2:end,7);
TrialCode = ActualData(2:end,6);
StimulusItem = ActualData(2:end,8); 


%% TEST TO SEE IF ANY CATCH TRIALS HAVE BEEN WRONGLY INPUT BY THE USER %% 

for i = 1:length(TrialCode)
    
   % Making the i'th value in the TrialCode a set of characters  
   tempCharacter = char(TrialCode(i)); 
   
   %Extracting the last 4 characters, assuming the word is
   %"CatchTrialpos4" or similar (that's why we have 11)
   trialCodeNumber = tempCharacter(11:end);
   
   % Taking the corresponding word in the response data column, and
   % converting to characters
   inputNumber = char(Response(i));
   
   %Checking string
   trialCodeCheck = string(tempCharacter(1:end-4));
   catchTrialWord = "CatchTrial";
   
   
   if strcmp(inputNumber,trialCodeNumber)
       fprintf('The catch trial on trial %.f was done correctly \n', i+1); 
   elseif strcmp(trialCodeCheck,catchTrialWord)
       fprintf('The catch trial on trial %.f was done incorrectly \n', i+1);
   end
end

%% SECTION FOR ANALYZING USER DATA %% 

numResponse = {};
% Resetting response column into numbers 
for j = 1:length(Response)
    if strcmp(Response(j),'neg4')
        numResponse{j} = -4;
    elseif strcmp(Response(j),'neg3')
        numResponse{j} = -3;
    elseif strcmp(Response(j),'neg2')
        numResponse{j} = -2;
    elseif strcmp(Response(j),'neg1')
        numResponse{j} = -1;
    elseif strcmp(Response(j),'pos1')
        numResponse{j} = 1;
    elseif strcmp(Response(j),'pos2')
        numResponse{j} = 2;
    elseif strcmp(Response(j),'pos3')
        numResponse{j} = 3;
    elseif strcmp(Response(j),'pos4')
        numResponse{j} = 4;
    else
        numResponse{j} = Response(j);
    end
end

% Making it the same direction as Response cells
numResponse = transpose(numResponse);


% prompt = 'Catch trials were not done correctly, proceed anyway? Type Y';
% 
% input = input(prompt,'s');


% IMPORTANT: Variable names below are according to the type of picture
% shown in the quiz. For example, PurpleValley refers to the picture of
% flowers that look purple, in a valley. The find function will find all
% photos containing the PurpleValley name, and their respective saturation
% adjustments (as a number, e.g. 0.2, 1.4). To extend this code for other
% stimuli, make sure adjustments are made here.


% + 1 to get the index of the response, since the stimulus is presented
% before a response is required
% PurpleValley = sort(StimulusItem(find(contains(StimulusItem,'PurpleValley')))); 


% Finding the flowers, and storing them. Adding one, to get the index of
% the trial which corresponds to the user inputting a response. 
stim_PurpleValley = find(contains(StimulusItem,'PurpleValley')) + 1;
stim_ThreePink = find(contains(StimulusItem,'ThreePink')) + 1; 
stim_White = find(contains(StimulusItem,'White')) + 1; 
stim_Blossom = find(contains(StimulusItem,'Blossom')) + 1; 
stim_TwoY = find(contains(StimulusItem,'TwoY')) + 1; 
stim_OneR = find(contains(StimulusItem,'OneR')) + 1; 
stim_Purple = find(contains(StimulusItem,'Purple') & not(contains(StimulusItem,'PurpleValley'))) + 1; % As we already used purple before
stim_OneOrange = find(contains(StimulusItem,'OneOrange')) + 1;
stim_TwoR = find(contains(StimulusItem,'TwoR')) + 1;
stim_TwoPink = find(contains(StimulusItem,'TwoPink')) + 1;


% Finding the actual rating, corresponding to index determined above
rating_PurpleValley = cell2mat(numResponse(stim_PurpleValley));
rating_ThreePink = cell2mat(numResponse(stim_ThreePink));
rating_White = cell2mat(numResponse(stim_White));
rating_Blossom = cell2mat(numResponse(stim_Blossom));
rating_TwoY = cell2mat(numResponse(stim_TwoY));
rating_OneR = cell2mat(numResponse(stim_OneR));
rating_Purple = cell2mat(numResponse(stim_Purple));
rating_OneOrange = cell2mat(numResponse(stim_OneOrange));
rating_TwoR = cell2mat(numResponse(stim_TwoR));
rating_TwoPink = cell2mat(numResponse(stim_TwoPink));

% Making the StimulusItem cells a string
StimulusItem = string(StimulusItem);

% Putting the rating, and the corresponding flower into a string matrix. -1
% to get the index of the flower itself 
str_PurpleValley = sortrows([StimulusItem(stim_PurpleValley-1), rating_PurpleValley]);
str_ThreePink = sortrows([StimulusItem(stim_ThreePink-1),rating_ThreePink]);
str_White = sortrows([StimulusItem(stim_White-1),rating_White]);
str_Blossom = sortrows([StimulusItem(stim_Blossom-1),rating_Blossom]);
str_TwoY = sortrows([StimulusItem(stim_TwoY-1),rating_TwoY]);
str_OneR = sortrows([StimulusItem(stim_OneR-1),rating_OneR]);
str_Purple = sortrows([StimulusItem(stim_Purple-1),rating_Purple]);
str_OneOrange = sortrows([StimulusItem(stim_OneOrange-1),rating_OneOrange]);
str_TwoR = sortrows([StimulusItem(stim_TwoR-1),rating_TwoR]);
str_TwoPink = sortrows([StimulusItem(stim_TwoPink-1),rating_TwoPink]); 

% Final useful set of data 
PurpleValley = [str2double(extractBetween(str_PurpleValley(:,1),"PurpleValley_",".jpg")),str2double(str_PurpleValley(1:end,2))]; 
ThreePink = [str2double(extractBetween(str_ThreePink(:,1),"ThreePink_",".jpg")),str2double(str_ThreePink(1:end,2))]; 
White = [str2double(extractBetween(str_White(:,1),"White_",".jpg")),str2double(str_White(1:end,2))]; 
Blossom = [str2double(extractBetween(str_Blossom(:,1),"Blossom_",".jpg")),str2double(str_Blossom(1:end,2))]; 
TwoY = [str2double(extractBetween(str_TwoY(:,1),"TwoY_",".jpg")),str2double(str_TwoY(1:end,2))]; 
OneR = [str2double(extractBetween(str_OneR(:,1),"OneR_",".jpg")),str2double(str_OneR(1:end,2))];
Purple = [str2double(extractBetween(str_Purple(:,1),"Purple_",".jpg")),str2double(str_Purple(1:end,2))];
OneOrange = [str2double(extractBetween(str_OneOrange(:,1),"OneOrange_",".jpg")),str2double(str_OneOrange(1:end,2))];
TwoR = [str2double(extractBetween(str_TwoR(:,1),"TwoR_",".jpg")),str2double(str_TwoR(1:end,2))];
TwoPink = [str2double(extractBetween(str_TwoPink(:,1),"TwoPink_",".jpg")),str2double(str_TwoPink(1:end,2))];



%% PLOTTING %% 

% Loading images
pic_PurpleValley = imread('PurpleValley_1.0.jpg');
pic_ThreePink = imread('ThreePink_1.0.jpg');
pic_White = imread('White_1.0.jpg');
pic_Blossom = imread('Blossom_1.0.jpg');
pic_TwoY = imread('TwoY_1.0.jpg');
pic_OneR = imread('OneR_1.0.jpg');
pic_Purple = imread('Purple_1.0.jpg');
pic_OneOrange = imread('OneOrange_1.0.jpg');
pic_TwoR = imread('TwoR_1.0.jpg');
pic_TwoPink = imread('TwoPink_1.0.jpg');

% Label variables 
plotTitle = 'Plot of participant answers to different levels of saturation for image on left';
xLabel = 'Level of saturation';
yLabel = 'Participant response for realness'; 


% Purple Valley, fig 1 
figure(1);
subplot(2,2,1)
imshow(pic_PurpleValley); 
subplot(2,2,2)
x = PurpleValley(:,1);
y = PurpleValley(:,2);
bar(x,y,0.1);
title(plotTitle); 
xlabel(xLabel);
ylabel(yLabel); 


% ThreePink, fig 1 
figure(1);
subplot(2,2,3)
imshow(pic_ThreePink); 
subplot(2,2,4)
x = ThreePink(:,1);
y = ThreePink(:,2);
bar(x,y,0.1);
title(plotTitle); 
xlabel(xLabel);
ylabel(yLabel); 

% White, fig 2 
figure(2);
subplot(2,2,1)
imshow(pic_White); 
subplot(2,2,2)
x = White(:,1);
y = White(:,2);
bar(x,y,0.1);
title(plotTitle); 
xlabel(xLabel);
ylabel(yLabel); 


% Blossom, fig 2 
figure(2);
subplot(2,2,3)
imshow(pic_Blossom); 
subplot(2,2,4)
x = Blossom(:,1);
y = Blossom(:,2);
bar(x,y,0.1);
title(plotTitle); 
xlabel(xLabel);
ylabel(yLabel); 


% TwoY, fig 3 
figure(3);
subplot(2,2,1)
imshow(pic_TwoY); 
subplot(2,2,2)
x = TwoY(:,1);
y = TwoY(:,2);
bar(x,y,0.1);
title(plotTitle); 
xlabel(xLabel);
ylabel(yLabel); 


% OneR, fig 3 
figure(3);
subplot(2,2,3)
imshow(pic_OneR); 
subplot(2,2,4)
x = OneR(:,1);
y = OneR(:,2);
bar(x,y,0.1);
title(plotTitle); 
xlabel(xLabel);
ylabel(yLabel); 



% Purple, fig 4 
figure(4); 
subplot(2,2,1)
imshow(pic_Purple); 
subplot(2,2,2)
x = Purple(:,1);
y = Purple(:,2);
bar(x,y,0.1);
title(plotTitle); 
xlabel(xLabel);
ylabel(yLabel);


% OneOrange, fig 4
figure(4);
subplot(2,2,3)
imshow(pic_OneOrange); 
subplot(2,2,4)
x = OneOrange(:,1);
y = OneOrange(:,2);
bar(x,y,0.1);
title(plotTitle); 
xlabel(xLabel);
ylabel(yLabel); 


% TwoR, fig 5 
figure(5); 
subplot(2,2,1)
imshow(pic_TwoR); 
subplot(2,2,2)
x = TwoR(:,1);
y = TwoR(:,2);
bar(x,y,0.1);
title(plotTitle); 
xlabel(xLabel);
ylabel(yLabel);

% TwoPink, fig 5 
figure(5);
subplot(2,2,3)
imshow(pic_TwoPink); 
subplot(2,2,4)
x = TwoPink(:,1);
y = TwoPink(:,2);
bar(x,y,0.1);
title(plotTitle); 
xlabel(xLabel);
ylabel(yLabel); 


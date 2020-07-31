clear all; close all; clc; 

%% IMPORTING DATA %% 

temp_SurveyData = importdata('DPDR_final_survey_1_2020-07-29-00-34-59-403.iqdat');

Questions = getfield(temp_SurveyData,'textdata');
NumberData = getfield(temp_SurveyData,'data');

% FrequencyQuestions = Questions(2,7:4:end); 
% DurationQuestions

FrequencyAnswer = NumberData(1,1:4:end); 
DurationAnswer = NumberData(1,3:4:end); 
ResponseTimeFrequency = NumberData(1,2:4:end); 
ResponseTimeDuration = NumberData(1,4:4:end); 

%% CATCH TRIAL %% 


%% ENDORSED QUESTIONS (Questions Answered) %% 

QuestionsAnswered = 0; 
for i = 1:length(FrequencyAnswer)
    if FrequencyAnswer(i) == 0 && DurationAnswer(i) ~= 0
        return; 
    elseif FrequencyAnswer(i) ~= 0 && DurationAnswer(i) ~= 0 
        QuestionsAnswered = QuestionsAnswered + 1;
    end
end

%% AVERAGES (Frequency and Duration), only works if previous condition is met %%

FrequencyAverage = round(mean(FrequencyAnswer));
DurationAverage = round(mean(DurationAnswer)); 

%% TOTAL SCORE %% 

TotalScore = sum(FrequencyAnswer) + sum(DurationAnswer);

%% FINAL OUTPUT %% 

fprintf('Participant endorsed %.f questions \nWith an average frequency of %.f \nAn average duration of %.f \nAnd total score of %.f', QuestionsAnswered, FrequencyAverage, DurationAverage, TotalScore); 
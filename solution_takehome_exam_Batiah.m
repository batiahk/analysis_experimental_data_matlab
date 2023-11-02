%matlab final assignment 2023 BatiahK

%Data_Lesson8 contains data from an experiment which uses a matching game.
%This script finds occurrences of "picked match"
%and returns the average number of occurrences in addition to the RT (seconds) for each group.

%For all participants in Data_Lesson8 folder:
clear
subjdir = 'C:\Users\keiss\OneDrive\Documents\MATLAB\Data_Lesson8';

%start group counters: number of participants, number of matches, and rt
contT1.count = 0;
contT1.matches = 0;
contT1.rt = 0;
contT2.count = 0;
contT2.matches = 0;
contT2.rt = 0;
subjT1.count = 0;
subjT1.matches = 0;
subjT1.rt = 0;
subjT2.count = 0;
subjT2.matches = 0;
subjT2.rt = 0;

%create a directory of the participant folders
subjectFolders = dir(subjdir);
%the dir function adds "." and ".." . remove these!
subjectFolders = subjectFolders(~ismember({subjectFolders.name}, {'.', '..'})); 

% iterate over subject folders in directory and read the excel file for the currect participant

for i = 1:length(subjectFolders)
    subjFile = dir(fullfile(subjdir, subjectFolders(i).name, '*.xls'));
    excelFilePath = fullfile(subjdir, subjectFolders(i).name, subjFile.name);
    [NUM,TXT,RAW] = xlsread(excelFilePath);
    
%Focus specifically on trials in which they choose match cards ("Picked_match")
%Divide participants by group and time point (subjT1, subjT2, contT1, cont2)
%Extract The number of times they choose a match card by group (sum of "picked_match" occurrences per group)

%find occurrences of 'Picked_match' for subject
%count number of occurrences
    [rowMatch,colMatch] = find(strcmp('Picked_match',RAW));
    subjNumMatches = length(colMatch);

%find columns of begin time and end time to calculate RT
    [rowStart,colStart] = find(strcmp('Start Time [mSec]',RAW));
    [rowEnd,colEnd] = find(strcmp('End Time [mSec]',RAW));
    startCol = colStart(1);
    endCol = colEnd(1);

%add RTs from the rows of 'Picked_match' to summ of RT for this subject
    currSumRT = 0;
    for j = 1:length(rowMatch) %iterates over row numbers with Picked_match
        currRow = rowMatch(j); %currRow contains the current row number
        endTime = RAW{currRow, endCol};
        startTime = RAW{currRow, startCol};
        RTdiff = (endTime - startTime) / 1000; % caculate rt in seconds for that trial
        currSumRT = currSumRT + RTdiff; % add rt to current subject's overall rt
              
    end

%calculate avg rt for current subject
    currRTavg = currSumRT / subjNumMatches;

%Extract the average reaction time for choosing a match card separately by group
%and time point (End Time [mSec] - Start  Time [mSec])
% create group counters for number of matches, num of group members and
% group RT total
    
    if contains(subjFile.name, 'cont')
        if contains(subjFile.name, 'T1')
            contT1.count = contT1.count + 1;
            contT1.matches = contT1.matches + subjNumMatches;
            contT1.rt = contT1.rt + currRTavg;
        elseif contains(subjFile.name, 'T2')
            contT2.count = contT2.count + 1;
            contT2.matches = contT2.matches + subjNumMatches;
            contT2.rt = contT2.rt + currRTavg;
        end
    elseif contains(subjFile.name, 'subj')
        if contains(subjFile.name, 'T1')
            subjT1.count = subjT1.count + 1;
            subjT1.matches = subjT1.matches + subjNumMatches;
            subjT1.rt = subjT1.rt + currRTavg;
        elseif contains(subjFile.name, 'T2')
            subjT2.count = subjT2.count + 1;
            subjT2.matches = subjT2.matches + subjNumMatches;
            subjT2.rt = subjT2.rt + currRTavg;
        end
    end
end

% calculate avg number of trials for group by deviding num of matches by num of participants
contT1.Mavg = contT1.matches/contT1.count;
contT2.Mavg = contT2.matches/contT2.count;
subjT1.Mavg = subjT1.matches/subjT1.count;
subjT2.Mavg = subjT2.matches/subjT2.count;
% calculate the avg group rt by deviding summation of individual RT avgs by num of participants
contT1.rtavg = contT1.rt/contT1.count;
contT2.rtavg = contT2.rt/contT2.count;
subjT1.rtavg = subjT1.rt/subjT1.count;
subjT2.rtavg = subjT2.rt/subjT2.count;

% Display all results
groups = {'Controls at T1' 'Controls at T2' 'Subjects at T1' 'Subjects at T2'};
grpAvgRT = {contT1.rtavg, contT2.rtavg, subjT1.rtavg, subjT2.rtavg};
grpAvgMatches = {contT1.Mavg, contT2.Mavg, subjT1.Mavg, subjT2.Mavg};
for m = 1:length(groups)
    message1 = ['The average number of trials that group ', groups{m},' picked match cards in is '];
    message2 = ['and their average group RT in seconds is '];
    disp(message1);
    disp(grpAvgMatches{m});%split up lines to avoid square symbol instead of value in disp
    disp(message2);
    disp(grpAvgRT{m}); 
end

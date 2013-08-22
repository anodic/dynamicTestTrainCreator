% @brief Context Information Regression modeling
%
% @author: Andrej Košir
%


%% Settings
% <set>
absoluteRootPath = 'D:\00xBeds\14-DataPreparation';
dataPath = '02-Data';
toolsPath = '03-Tools';


addpath(fullfile(absoluteRootPath, dataPath));
addpath(fullfile(absoluteRootPath, toolsPath));


%% Load data
dataFile = 'newCoMoDa3.xlsx';
[~,~,rawItems] = xlsread(fullfile(absoluteRootPath,dataPath,dataFile));
dataMatrix = cell2mat(rawItems(2:end,:));


%% prepare counters
[countPerUsr,userIds]=hist(dataMatrix(:,1),unique(dataMatrix(:,1)));

maxUsrIndex = max(userIds);
ratingsPerUser = zeros(maxUsrIndex,1);

for i = 1 : length(countPerUsr)
    ratingsPerUser(userIds(i)) = countPerUsr(i);
end


[countPerItm,itemIds]=hist(dataMatrix(:,2),unique(dataMatrix(:,2)));

maxItemIndex = max(userIds);
ratingsPerItem = zeros(maxItemIndex,1);

for i = 1 : length(countPerItm)
    ratingsPerItem(itemIds(i)) = countPerItm(i);
end


%% create training and test set
numOfRows = size(dataMatrix,1);
numOfColumns = size(dataMatrix,2);
jumpedRows = zeros(1,15);

for foldIndex=1:10
    
    testSetIndx = 1;
    testSet = zeros(1,numOfColumns);
    
    ratingsPerUserTemp = ratingsPerUser;
    ratingsPerItemTemp = ratingsPerItem;
    
    % randomization of rows
    currentMatrix = dataMatrix(randperm(numOfRows),:);
     
    noGoods=0;
    taken=0;
    for j = 1:size(currentMatrix,1)
        
        if(ratingsPerUserTemp(currentMatrix(j,1))>4 && ratingsPerItemTemp(currentMatrix(j,2))>4)
            disp('uzeo');
            taken = taken +1;
            uID = currentMatrix(j,1);
            iID = currentMatrix(j,2);
            amountUser = ratingsPerUserTemp(currentMatrix(j,1));
            amountItem = ratingsPerItemTemp(currentMatrix(j,2));
            extractedRow = currentMatrix(j,:);
            jumpedRows = [jumpedRows;extractedRow];
            testSet(testSetIndx,:)=extractedRow;
            testSetIndx = testSetIndx+1;
            currentMatrix(j,:)=[];
            ratingsPerUserTemp(uID) = ratingsPerUserTemp(uID)-1;
            ratingsPerItemTemp(iID) = ratingsPerItemTemp(iID)-1;
        else
            disp('ne mogu ga uzeti')
            noGoods = noGoods+1;
            
        end
        
        if (testSetIndx >= 300)
            break;
        end
        
    end
    
    testSetShort = [testSet(:,1:15)];% testSet(:,9:20)];
    trainSetShort = [currentMatrix(:,1:15)];% currentMatrix(:,9:20)];
    
    trainSetName = ['newCoMoDaOnlyContextTrain' num2str(foldIndex) '.xlsx'];
    testSetName = ['newCoMoDaOnlyContextTest' num2str(foldIndex) '.xlsx'];
    
        
    xlswrite(testSetName, testSetShort);
    xlswrite(trainSetName, trainSetShort);
    %csvwrite(testSetName, testSetShort);
    %csvwrite(trainSetName, trainSetShort);
    
    
end


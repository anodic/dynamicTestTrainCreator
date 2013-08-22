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
dataFile = 'matrix2DdataNoIdiots.xls';
[~,~,rawItems] = xlsread(fullfile(absoluteRootPath,dataPath,dataFile));
dataMatrix = cell2mat(rawItems(2:end,:));
numOfRows = size(dataMatrix,1);
disp(['Start database size: ' num2str(numOfRows)]);


%% paramethers and counters
usrMinParam= 3;
itmMinParam= 2;

disp(['Min ratings per user is set to: ' num2str(usrMinParam)]);
disp(['Min ratings per item is set to: ' num2str(itmMinParam)]);

startIteration=1;

%% count ratings per user and item
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




%% eliminate rows
% eliminate users with less than usrMinParam ratings, and items with less than itmMinParam ratings

while startIteration==1;
    startIteration =0;
    
    numOfRows = size(dataMatrix,1);
%     disp(['Start database size: ' num2str(numOfRows)]);
    numOfColumns = size(dataMatrix,2);
    
    for i  = 1: numOfRows
        if (ratingsPerUser(dataMatrix(i,1))< usrMinParam)
            startIteration =1;
            ratingsPerUser(dataMatrix(i,1)) = ratingsPerUser(dataMatrix(i,1)) - 1;
            ratingsPerItem(dataMatrix(i,2)) = ratingsPerItem(dataMatrix(i,2)) - 1;
            dataMatrix(i,:)=[];
        end
        
        if (ratingsPerItem(dataMatrix(i,2))< itmMinParam)
            startIteration =1;
            ratingsPerUser(dataMatrix(i,1)) = ratingsPerUser(dataMatrix(i,1)) - 1;
            ratingsPerItem(dataMatrix(i,2)) = ratingsPerItem(dataMatrix(i,2)) - 1;
            dataMatrix(i,:)=[];
        end
        numOfRows = size(dataMatrix,1);
        if i>=numOfRows
            break
        end
    end
    
end




disp(['Final database size: ' num2str(numOfRows)]);
disp(' ');

test = xlsread('D:\00xBeds\03-MatrixFactorizationWithContext\data\LDOScontextDB\LDOScomoda-newOldTestSet\LDOScontextTEST.xlsx');
train = xlsread('D:\00xBeds\03-MatrixFactorizationWithContext\data\LDOScontextDB\LDOScomoda-newOldTestSet\matrix2DdataNewOldTestSet.xlsx');

for i = 1:length(test)
    
    usr=test(i,1);
    itm= test(i,2);
    rtng = test(i,3);
    
    location =find(train(:,1)==usr & train(:,2)==itm & train(:,3)==rtng);
    
    if location
        train(location,:)=[];
    end
end

xlswrite('D:\00xBeds\03-MatrixFactorizationWithContext\data\LDOScontextDB\LDOScomoda-newOldTestSet\LDOScontextTRAINNewOldTestSet.xlsx', train)
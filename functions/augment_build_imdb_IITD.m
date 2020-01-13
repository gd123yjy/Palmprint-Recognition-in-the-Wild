% build imdb
function []=augment_build_imdb(expNum,dbName,imgType,dataListName)
fprintf('building imdb\n')
% expNum = 'exp1'; 
% dbName = 'IITD'; 
% imgType = 'img'; 
% dataListName = 'DataNclass.mat';

pathTrain = fullfile('../databases/',dbName,'/flip/',imgType,'/train/');
pathTest = fullfile('../databases/',dbName,'/flip/',imgType,'/test/');
mkdir(fullfile(pwd,'/imdbDataList/',expNum));
pathSave = fullfile(pwd,'/imdbDataList/',expNum,'/');
fileTrain = dir(pathTrain); fileTrain = fileTrain(3:end);
fileTest = dir(pathTest); fileTest = fileTest(3:end);

indTrain = 1;
indTest = 1;
indMetaTransform = 1;
identityTransformation(:,:,1) = 1;
identityTransformation(:,:,2) = 0;
identityTransformation(:,:,3) = 0;
identityTransformation(:,:,4) = 1;
identityTransformation(:,:,5) = 0;
identityTransformation(:,:,6) = 0;

for i=1:length(fileTrain)
    tabId(i) = str2num(fileTrain(i).name(1:3));
end

labelDict = unique(tabId);

% build imdb training set
for i=1:length(fileTrain) 
    classId = str2num(fileTrain(i).name(1:3));
    
    imdb.tr.image{indTrain} = fileTrain(i).name;
    classId = find(classId == labelDict);
    imdb.tr.label(indTrain) = classId;
    indTrain = indTrain + 1;
end


%% build imdb test set
for i=1:length(fileTest)
    classId = str2num(fileTest(i).name(1:3));
    classId = find(classId == labelDict);
    imdb.val.image{indTest} = fileTest(i).name;
    imdb.val.label(indTest) = classId;
    indTest = indTest + 1;      
end

z=unique(imdb.val.label);
z2=unique(imdb.tr.label);

%% consistency (closed set) checker
% if an image from test/probe set is not in train/gallery set then return 
% pause and return this image
if(iscell(z))
for i=1:length(z)
    flag = false;
    for j=1:length(z2)
        if(strcmp(z{i},z2{j}))
            flag = true;
        end
    end
    if(flag == false)
        z{i}
        pause
    end
end
else
    for i=1:length(z)
    flag = false;
    for j=1:length(z2)
        if(z(i)==z2(j))
            flag = true;
        end
    end
    if(flag == false)
        z(i)
        pause
    end
    end
end

% prepare imdb struct to save
imdb.meta.labelDict = labelDict;
imdb.meta.classes = unique(z2);
imdb.meta.imgType = imgType;
imdb.meta.dataSetName = dbName;
imdb.meta.numClassesGallery = length(z2);
imdb.meta.numClassesProbe = length(z);

save(fullfile(pathSave,dataListName),'imdb');
fprintf('imdb saved\n');
z=unique(imdb.val.label);
z2=unique(imdb.tr.label);
fprintf('unique classes in training/gallery set %d:\n',length(z2));
fprintf('unique classes in testing/probe set %d:\n',length(z));
fprintf('affine transformation parameters:\n');

end

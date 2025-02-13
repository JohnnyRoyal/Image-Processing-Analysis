%2.1.2
clear
load("mnist.mat");

%trainning data χωρισμένο σε training set και validation όπου το validation
%set δείχνει το λάθος στο νευρονικό δίκτυο
%μετά έχω το test set δεδομένα που δεν έχει ξαναδεί το δίκτυο για να
%παρατηρήσω την πραγματική του απόδοση σε γενικές περιπτώσεις δεδομένων
%εισόδου
%επομένος χωρίζω το training data σε 80-20% training-validation και έχω και το test set μου


percent = 100/100;
wholeSize = 60000;
newSize = wholeSize*percent
splitIndex = newSize*0.8; % σημείο διαίρεσης του struct που κρατάει τα training data

% τα δυο νέα structs
trainingSet = struct('images',{training.images(:,:,1:splitIndex)},'labels',{training.labels(1:splitIndex)});    %48.000 εικόνες για το trainingset
validationSet = struct('images',{training.images(:,:,splitIndex:newSize)},'labels',{training.labels(splitIndex:newSize)});  %12.000 εικόνες για validationset

%Μεγέθη του Training και Validation Set
T = size(trainingSet.labels);
V = size(validationSet.labels);

%μετατροπή τους ετσί ώστε να φορτώνονται σωστά στην trainnet ,
% ουσιαστικά απλά δηλώνω ότι έχουνε βάθος=1 δηλαδή είναι greyscale και όχι rgb
%(βάθος=3)

reshapeTrainingSetimages= reshape(trainingSet.images,28,28,1,48000);  % Μέγεθος: [28, 28, 1, 48000]
reshapeValidationSetimages = reshape(validationSet.images, 28, 28, 1, []);  % Μέγεθος: [28, 28, 1, 12000]

%τεστ μετατροπής των δεδομένων μου για την είσοδο

img = reshapeTrainingSetimages(:,:,:,1);

%test με default παραμέτρους
[featureVector,hogVisualization] = extractHOGFeatures(img);
whos featureVector

figure Name 'Default';
imshow(img); 
hold on;
plot(hogVisualization);

%test με ελαφριές παραμέτρους
[featureVector,hogVisualization] = extractHOGFeatures(img,CellSize=[8,8],NumBins=3);
whos featureVector

figure Name 'Ελαφρί';
imshow(img); 
hold on;
plot(hogVisualization);


%test παραμέτρους βελτιστοποιημένες για ακρίβεια ,λόγω της μικρής εικόνας
[featureVector,hogVisualization] = extractHOGFeatures(img,CellSize=[4,4],NumBins=11);
whos featureVector

figure Name 'Παραμετροποιημένη';
imshow(img); 
hold on;
plot(hogVisualization);

TrainingHOGset = struct('Features',cell(1,splitIndex),'Labels',{training.labels(1:splitIndex)});
ValidationHOGset = struct('Features',cell(splitIndex,V(1,1)),'labels',{training.labels(splitIndex:end)});

parfor i=1:splitIndex
    feature = extractHOGFeatures(reshapeTrainingSetimages(:,:,:,i),CellSize=[4,4],NumBins=11);
    TrainingHOGset(i).Features = feature;
end

parfor i=splitIndex:V(1,1)
    feature = extractHOGFeatures(reshapeTrainingSetimages(:,:,:,i),CellSize=[4,4],NumBins=11);
    ValidationHOGset(i).Features = feature;
end

%test μορφής
size(TrainingHOGset(:,1).Features)
size(TrainingHOGset(1).Features)

%% 

%2.1.3

epoch =4;   %εποχές
b =20;  %minibatchsize
epochsize=T(1,1)/b;
inputSize =[28 28 1];    %σύμφωνα με τα χαρακτηριστικά των εικόνων mnist
classes = numel(unique(training.labels));   %10 κλάσεις


%ορισμός επιπέδων του δικτύου , γνωρίζω ότι δεν αναφέρονται ρητά τα softmax
%και classification επίπεδα παρόλα αυτά χωρίς την ποαρουσία τους το δίκτυο
%δεν μαθαίνει τίποτα ,έχω και σχετικό παράδειγμα στην αναφορά

layers = [
    featureInputLayer(1) 
    fullyConnectedLayer(classes) 
    softmaxLayer
   ];

options = trainingOptions("sgdm", ...
    MiniBatchSize=b, ...
    MaxEpochs=epoch, ...
    Metrics=["accuracy","fscore","rmse"], ...
    Verbose=true, ...
    VerboseFrequency=20,...
    ValidationData={ValidationHOGset.Features, categorical(validationSet.labels)}, ...
    ValidationFrequency=b, ...
    OutputNetwork="best-validation", ...
    ExecutionEnvironment="cpu",...
    Plots="training-progress", ...
    CheckpointPath="E:\Ioannis~Kazixis\CEID\Η-Εξάμηνο\Ψηφιακή Επεξεργασία και Ανάλυση Εικόνας\ΜέροςΒ\featureextract", ...
    CheckPointFrequency=1 ...
    );

%το έφτιαξε το categorical στο trainingSet.labels αλλιώς buggαρε

[diktyo,info] = trainnet(TrainingHOGset.Features,categorical(trainingSet.labels),layers,'crossentropy',options);

show(info)

%% 

%δείχνω τις τιμές των μετρικών στο τέλος κάθε εποχής
for i=1:4
    blabla=["metrics from epoch",i];
    disp(blabla)
    TrainingHistory=info.TrainingHistory(i*epochsize,:)
    ValidationHistory=info.ValidationHistory(i*epochsize/20 +1,:)
end
    
%info.TrainingHistory
%info.ValidationHistory
BestNetworkIterration = info.OutputNetworkIteration

%% 

%2.1.4

reshapeTestSetImages = reshape(test.images, 28, 28, 1, []); %το testSet μου Μέγεθoυς: [28, 28, 1, 10000] 
TestSize = size(test.labels)

TestHOGset = struct('Features',cell(1,TestSize(1,1)));

parfor i=1:TestSize(1,1)
    feature = extractHOGFeatures(reshapeTestSetImages(:,:,:,i));
    TrainingHOGset(i).Features = feature;
end

% diktyoepoch4 = importdata();
% diktyoepoch3 = importdata();
% diktyoepoch2 = importdata();
% diktyoepoch1 = importdata();

%δεν θα δουλέψει καθώς δεν υπάρχει αρκετός χώρος στη ram για να εκπαιδευτεί
%το δίκτυο
testbest = testnet(diktyo,reshapeTestSetImages,categorical(test.labels),["accuracy","rmse","fscore","crossentropy"],MiniBatchSize=b)
% testepoch4 = testnet(diktyoepoch4,reshapeTestSetImages,categorical(test.labels),["accuracy","rmse","fscore","crossentropy"],MiniBatchSize=b)
% testepoch3 = testnet(diktyoepoch3,reshapeTestSetImages,categorical(test.labels),["accuracy","rmse","fscore","crossentropy"],MiniBatchSize=b)
% testepoch2 = testnet(diktyoepoch2,reshapeTestSetImages,categorical(test.labels),["accuracy","rmse","fscore","crossentropy"],MiniBatchSize=b)
% testepoch1 = testnet(diktyoepoch1,reshapeTestSetImages,categorical(test.labels),["accuracy","rmse","fscore","crossentropy"],MiniBatchSize=b)
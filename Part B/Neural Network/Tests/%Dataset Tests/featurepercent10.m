%2.1.5
%Tα παρακάτω βήματα είναι τα βήματα 2-4 χρησιμοποιόντας το 10% του συνόλου

%2.1.2
clear
load("mnist.mat");

percent = 10/100;
wholeSize = 60000;
newSize = wholeSize*percent
splitIndex = newSize*0.8; % σημείο διαίρεσης του struct που κρατάει τα training data

% τα δυο νέα structs
trainingSet = struct('images',{training.images(:,:,1:splitIndex)},'labels',{training.labels(1:splitIndex)});    %48.000 εικόνες για το trainingset
validationSet = struct('images',{training.images(:,:,splitIndex:newSize)},'labels',{training.labels(splitIndex:newSize)});  %12.000 εικόνες για validationset

%Μεγέθη του Training και Validation Set
T = size(trainingSet.labels)
V = size(validationSet.labels)
%% 
%μετατροπή τους ετσί ώστε να φορτώνονται σωστά στην trainnet ,
% ουσιαστικά απλά δηλώνω ότι έχουνε βάθος=1 δηλαδή είναι greyscale και όχι rgb
%(βάθος=3)
reshapeTrainingSetimages= reshape(trainingSet.images,28,28,1,[]);  % Μέγεθος: [28, 28, 1, T(1,1)]
reshapeValidationSetimages = reshape(validationSet.images, 28, 28, 1, []);  % Μέγεθος: [28, 28, 1, V(1,1)]

%Επικύρωση ακεραιότητας
size(reshapeTrainingSetimages)
size(reshapeValidationSetimages)



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
    imageInputLayer(inputSize) 
    fullyConnectedLayer(classes) 
    softmaxLayer
   ];

options = trainingOptions("sgdm", ...
    MiniBatchSize=b, ...
    MaxEpochs=epoch, ...
    Metrics=["accuracy","fscore","rmse"], ...
    Verbose=true, ...
    VerboseFrequency=20,...
    ValidationData={reshapeValidationSetimages, categorical(validationSet.labels)}, ...
    ValidationFrequency=b, ...
    OutputNetwork="best-validation", ...
    ExecutionEnvironment="cpu",...
    Plots="training-progress", ...
    CheckpointPath="E:\Ioannis~Kazixis\CEID\Η-Εξάμηνο\Ψηφιακή Επεξεργασία και Ανάλυση Εικόνας\ΜέροςΒ", ...
    CheckPointFrequency=1 ...
    );

%το έφτιαξε το categorical στο trainingSet.labels αλλιώς buggαρε

[diktyo,info] = trainnet(reshapeTrainingSetimages,categorical(trainingSet.labels),layers,'crossentropy',options);

show(info)


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


%2.1.4

reshapeTestSetImages = reshape(test.images, 28, 28, 1, []); %το testSet μου Μέγεθoυς: [28, 28, 1, 10000]

testbest = testnet(diktyo,reshapeTestSetImages,categorical(test.labels),["accuracy","rmse","fscore","crossentropy"],MiniBatchSize=b)

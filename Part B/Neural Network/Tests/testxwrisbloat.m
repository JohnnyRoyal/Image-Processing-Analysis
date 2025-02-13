%2.1.3
clear
load("mnist.mat");

%trainning data χωρισμένο σε training set και validation όπου το validation
%set δείχνει το λάθος στο νευρονικό δίκτυο
%μετά έχω το test set δεδομένα που δεν έχει ξαναδεί το δίκτυο για να
%παρατηρήσω την πραγματική του απόδοση σε γενικές περιπτώσεις δεδομένων
%εισόδου
%επομένος χωρίζω το training data σε 80-20% training-validation και έχω και το test set μου


splitIndex = 60000*0.8; % σημείο διαίρεσης του struct που κρατάει τα training data

% τα δυο νέα structs
trainingSet = struct('images',{training.images(:,:,1:splitIndex)},'labels',{training.labels(1:splitIndex)});    %48.000 εικόνες για το trainingset
validationSet = struct('images',{training.images(:,:,splitIndex:end)},'labels',{training.labels(splitIndex:end)});  %12.000 εικόνες για validationset

%μετατροπή τους ετσί ώστε να φορτώνονται σωστά στην trainnet ,
% ουσιαστικά απλά δηλώνω ότι έχουνε βάθος=1 δηλαδή είναι greyscale και όχι rgb
%(βάθος=3)

reshapeTrainingSetimages= reshape(trainingSet.images,28,28,1,48000);  % Μέγεθος: [28, 28, 1, 48000]
reshapeValidationSetimages = reshape(validationSet.images, 28, 28, 1, []);  % Μέγεθος: [28, 28, 1, 12000]

%τεστ μετατροπής των δεδομένων μου για την είσοδο

imagestart= size(trainingSet.images)
imagereshaped= size(reshapeTrainingSetimages)
imagelabels= size(trainingSet.labels)

% x=2;
% 
% figure
%     image (rescale(training.images(:,:,x),0,255));
%     colormap("gray");
%     colorbar
%     axis square equal
%     title(training.labels(x))
% 
% figure
%     image (rescale(trainingSet.images(:,:,x),0,255));
%     colormap("gray");
%     colorbar
%     axis square equal
%     title(trainingSet.labels(x))




epoch =10;   %εποχές
b =20;  %minibatchsize
epochsize=48000/b;
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
for i=1:10
    blabla=["metrics from epoch",i];
    disp(blabla)
    TrainingHistory=info.TrainingHistory(i*epochsize,:)
    ValidationHistory=info.ValidationHistory(i*epochsize/20 +1,:)
end
    
%info.TrainingHistory
%info.ValidationHistory
info.OutputNetworkIteration


%2.1.4

reshapeTestSetImages = reshape(test.images, 28, 28, 1, []); %το testSet μου Μέγεθoυς: [28, 28, 1, 10000]
diktyoepoch4 = importdata("E:\Ioannis~Kazixis\CEID\Η-Εξάμηνο\Ψηφιακή Επεξεργασία και Ανάλυση Εικόνας\ΜέροςΒ\net_checkpoint__9600__2024_09_18__15_02_06.mat");
diktyoepoch3 = importdata("E:\Ioannis~Kazixis\CEID\Η-Εξάμηνο\Ψηφιακή Επεξεργασία και Ανάλυση Εικόνας\ΜέροςΒ\net_checkpoint__7200__2024_09_18__14_59_56.mat");
diktyoepoch2 = importdata("E:\Ioannis~Kazixis\CEID\Η-Εξάμηνο\Ψηφιακή Επεξεργασία και Ανάλυση Εικόνας\ΜέροςΒ\net_checkpoint__4800__2024_09_18__14_57_45.mat");
diktyoepoch1 = importdata("E:\Ioannis~Kazixis\CEID\Η-Εξάμηνο\Ψηφιακή Επεξεργασία και Ανάλυση Εικόνας\ΜέροςΒ\net_checkpoint__2400__2024_09_18__14_55_39.mat");

testbest = testnet(diktyo,reshapeTestSetImages,categorical(test.labels),["accuracy","rmse","fscore","crossentropy"],MiniBatchSize=b)
testepoch4 = testnet(diktyoepoch4,reshapeTestSetImages,categorical(test.labels),["accuracy","rmse","fscore","crossentropy"],MiniBatchSize=b)
testepoch3 = testnet(diktyoepoch3,reshapeTestSetImages,categorical(test.labels),["accuracy","rmse","fscore","crossentropy"],MiniBatchSize=b)
testepoch2 = testnet(diktyoepoch2,reshapeTestSetImages,categorical(test.labels),["accuracy","rmse","fscore","crossentropy"],MiniBatchSize=b)
testepoch1 = testnet(diktyoepoch1,reshapeTestSetImages,categorical(test.labels),["accuracy","rmse","fscore","crossentropy"],MiniBatchSize=b)


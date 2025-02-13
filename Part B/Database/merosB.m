% Θέμα 1
% από http://yann.lecun.com/exdb/mnist/ δεν μπόρεσα να τα κατεβάσω καθώς
% έλεγε ότι δεν κατέχω την άδεια.
%βρήκα από αλλού το ίδιο αρχείο
load("mnist.mat");
who

%Θέμα 1 Ταξινόμηση Εικόνων
%2.1.1

index=ones(1,10).*10; %αρχικοποίηση έτσι ώστε να μην ταιριάζει σε κανένα αριθμό
duplicate=false; %αρχικοποίηση έτσι ώστε η ο πρώτος αριθμός να τυπώνεται


for i=1:30
index(i)=training.labels(i);    %αποθηκεύει τους αριθμούς που διαπεράσαμε
compare= (index(1:i-1)==training.labels(i));    %τηρεί αν ο νέος αριθμός είναι ίδιος με τα πορηγούμενα
duplicate= ismember(1,compare); %τηρεί το αποτέλεσμα της ισότητας

if duplicate==false
    %παρουσιάση δειγμάτων
    figure
    image (rescale(training.images(:,:,i),0,255));
    colormap("gray");
    colorbar
    axis square equal
    title(training.labels(i))
    

end

end

%μεταβλητές χρησιμοποιήθηκαν για να ελέγχω το πρόγραμμα πειραματικά διότι
%είχα προβλήματα με την παρουσιάση διπλότυπων αριθμών
index
compare
duplicate
training.labels(i)



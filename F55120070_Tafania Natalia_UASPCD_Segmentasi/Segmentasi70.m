%=================> UAS PCD <===================
%==========> Tafania Natalia Kasaedja <=========
%================> F55120070 <==================

clc;
clear;
close all;
warning off all;

%Membaca file Citra Rgb
image = imread('Eiffel.jpeg');

%Konversi Citra rgb menjadi Citra CIELAB
Lab =rgb2lab(image);

%Ekstrak komponen a dan b dari citra CIELAB
ab = double(Lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2); 
ab = reshape(ab,nrows*ncols,2);

%Segmentasi citra menggunakan Algoritma K-Means Clustering
numberOfClasses = 2;
indexes = kmeans(ab,numberOfClasses);
classImage = reshape(indexes,nrows,ncols);

%Hitung area tiap cluster (a dan b)
area = zeros(numberOfClasses,1);
for n = 1:numberOfClasses
    area(n) = sum(sum(classImage==n));
end

 %Mencari cluster dengan area terkecil
 [~,min_area] = min(area);
 bw = classImage==min_area;

 %Mengekstrak kompnen rgb dari citra rgb
 R = image(:,:,1);
 G = image(:,:,2);
 B = image(:,:,3);
 
 %Tahap thresholding terhdap komponen blue
 bw2 = ~imbinarize(B);

 %Operasi pengurangan (substaksi)
 bw3 = imsubtract(bw2,bw);

 %Operasi morfologi untuk menyempurnakan hasil segmentasi(mengurangi noise)
 bw4 = bwareaopen(bw3,300);

 %Menampilkan citra hasil metode segmnetasi
 R(~bw4) = 0;
 G(~bw4) = 0;
 B(~bw4) = 0;
 RGB = cat(3,R,G,B);
 
figure
subplot (2,4,1),imshow(image);title('Citra Asli');
subplot (2,4,2),imshow(Lab);title('Konversi RGB to CIELAB');
subplot (2,4,3),imshow(classImage,[]);title('Segmentasi K-Means');
subplot (2,4,4),imshow(bw);title('Cluster Area Terkecil');
subplot (2,4,5),imshow(bw2);title('Thresholding');
subplot (2,4,6),imshow(bw3);title('Substraksi');
subplot (2,4,7),imshow(bw4);title('Morfologi');
subplot (2,4,8),imshow(RGB);title('Hasil Segmentasi');

clc,clear
addpath('evaluation');
I = load_images( 'C:\Users\Home\Dropbox\Research Work\Proposed Method\sourceimages\door',1); 
%I = imresize(I,.5);
F = GFF(I);
%figure,imshow(F);

Folder = 'C:\Users\Home\Dropbox\Research Work\Proposed Method - GoL';
File   = 'DoorProposed11,5.jpg';
imwrite(F, fullfile(Folder, File));
count =1;
% % Evaluation Matrix 
 A=I(:,:,:,1);
 B=I(:,:,:,2);
 C=I(:,:,:,3);
%  D=I(:,:,:,4);
%  
 Qmi1=QualityMetrics(A,B,F);
 Qg1=metricXydeas(A,B,F);
 Qy1=QY(A,B,F);
 Qcb1=metricChenBlum(A,B,F);
 
%For Three Images Only
    Qmi2=QualityMetrics(A,C,F);
    Qg2=metricXydeas(A,C,F);
    Qy2=QY(A,C,F);
    Qcb2=metricChenBlum(A,C,F);
    
    Qmi3=QualityMetrics(B,C,F);
    Qg3=metricXydeas(B,C,F);
    Qy3=QY(B,C,F);
    Qcb3=metricChenBlum(B,C,F);

% % % %For Four Images
%     Qmi4=QualityMetrics(A,D,F);
%     Qg4=metricXydeas(A,D,F);
%     Qy4=QY(A,D,F);
%     Qcb4=metricChenBlum(A,D,F);
%     
%     Qmi5=QualityMetrics(B,D,F);
%     Qg5=metricXydeas(B,D,F);
%     Qy5=QY(B,D,F);
%     Qcb5=metricChenBlum(B,D,F);
%     
%     Qmi6=QualityMetrics(C,D,F);
%     Qg6=metricXydeas(C,D,F);
%     Qy6=QY(C,D,F);
%     Qcb6=metricChenBlum(C,D,F);
%     
%     %For 2 Images
    FusionScore(count,1)=Qmi1;
    FusionScore(count,2)=Qg1;
    FusionScore(count,3)=Qy1;
    FusionScore(count,4)=Qcb1;
    
%     %For 3 Images
    FusionScore(count,5)=Qmi2;
    FusionScore(count,6)=Qg2;
    FusionScore(count,7)=Qy2;
    FusionScore(count,8)=Qcb2;
    
    FusionScore(count,9)=Qmi3;
    FusionScore(count,10)=Qg3;
    FusionScore(count,11)=Qy3;
    FusionScore(count,12)=Qcb3;
%     
% %     %For 4 Images
%     FusionScore(count,13)=Qmi4;
%     FusionScore(count,14)=Qg4;
%     FusionScore(count,15)=Qy4;
%     FusionScore(count,16)=Qcb4;
%     
%     FusionScore(count,17)=Qmi5;
%     FusionScore(count,18)=Qg5;
%     FusionScore(count,18)=Qy5;
%     FusionScore(count,20)=Qcb5;
%     
%     FusionScore(count,21)=Qmi6;
%     FusionScore(count,22)=Qg6;
%     FusionScore(count,23)=Qy6;
%     FusionScore(count,24)=Qcb6;
% %   For 3 Images
    QmiTotal=FusionScore(count,1)+FusionScore(count,5)+FusionScore(count,9);
    QgTotal=FusionScore(count,2)+FusionScore(count,6)+FusionScore(count,10);
    QyTotal=FusionScore(count,3)+FusionScore(count,7)+FusionScore(count,11);
    QcbTotal=FusionScore(count,4)+FusionScore(count,8)+FusionScore(count,12);
    Result(1,1) = QmiTotal/3;
    Result(1,2) = QgTotal/3;
    Result(1,3) = QyTotal/3;
    Result(1,4) = QcbTotal/3;
% %For 4 Images
%     QmiTotal=FusionScore(count,1)+FusionScore(count,5)+FusionScore(count,9)+FusionScore(count,13)+FusionScore(count,17)+FusionScore(count,21);
%     QgTotal=FusionScore(count,2)+FusionScore(count,6)+FusionScore(count,10)+FusionScore(count,14)+FusionScore(count,18)+FusionScore(count,22);
%     QyTotal=FusionScore(count,3)+FusionScore(count,7)+FusionScore(count,11)+FusionScore(count,15)+FusionScore(count,19)+FusionScore(count,23);
%     QcbTotal=FusionScore(count,4)+FusionScore(count,8)+FusionScore(count,12)+FusionScore(count,16)+FusionScore(count,20)+FusionScore(count,24);
%     Result(1,1) = QmiTotal/6;
%     Result(1,2) = QgTotal/6;
%     Result(1,3) = QyTotal/6;
%     Result(1,4) = QcbTotal/6;
    Result
%  
%   FusionScore 
function [F] = GFF(I,r1,eps1,r2,eps2)
%   - local window radius: r
%   - regularization parameter: eps
if ~exist('r1')
    r1 = 45; eps1 = 0.3; r2 = 7; eps2 = 10^-6;
else
end
if size(I,3)==3 && size(I,4)~=1
G=rgb2gray_n(I);
else
G=I;
end
% Laplician Filtering
H = LapFilter(G);

% Gaussian Filtering and saliency  map
S = GauSaliency(H);

% Initial Weight Construction
P = IWconstruct(S);

% Color Dissimilarity Feature (only for dynamic fusion)

%  imgs=double(I)/255;
%  I_eq=Heq(double(imgs));
%  med_map=median(I_eq,4);
%  cost2=distance_map(I_eq,med_map,1,3,30); 
% 
%  P = P.*cost2;
%  
% Weight Optimization with Guided Filtering
W_B = GuidOptimize(G,P,r1,eps1);
W_D = GuidOptimize(G,P,r2,eps2);

% Two Scale Decomposition and Fusion
F = GuidFuse(I,W_B,W_D);

% Image Format Transformation
F = uint8(F*255);

%imwrite(F,'fused_gff.tif')


function [G] = rgb2gray_n( I )
N=size(I,4);
G=zeros(size(I,1),size(I,2),N);
for i=1:N
    G(:,:,i)=rgb2gray(I(:,:,:,i));
end

function [ H ] = LapFilter( G )
%Conduct Laplacian filtering on each source image
L = [0 1 0; 1 -4 1; 0 1 0]; % The 3*3 laplacian filter
N = size(G,3); % to get number of Images
G = double(G)/255; %Converting to double
H = zeros(size(G,1),size(G,2),N); % Assign memory
for i = 1:N
    H(:,:,i) = abs(imfilter(G(:,:,i),L,'replicate'));
end

function [ S ] = GauSaliency( H )
% Using the local average of the absolute value of H to construct the 
% saliency maps
N = size(H,3);
S = zeros(size(H,1),size(H,2),N);
for i=1:N
se = fspecial('gaussian',11,5); % window size 5 sigma 11
S(:,:,i) = imfilter(H(:,:,i),se,'replicate');
end
S = S + 1e-12; %avoids division by zero
S = S./repmat(sum(S,3),[1 1 N]);%Normalize the saliences in to [0-1]

function [P] = IWconstruct( S )
% construct the initial weight maps
[r c N] = size(S);
[X Labels] = max(S,[],3); % find the labels of the maximum
clear X
for i = 1:N
    mono = zeros(r,c);
    mono(Labels==i) = 1;
    P(:,:,i) = mono;
end

function [W] = GuidOptimize( I, P, r, eps)
N = size(I,3);
I = double(I)/255;
for i=1:N
P(:,:,i) = double(P(:,:,i));
W(:,:,i) = guidedfilter(I(:,:,i), P(:,:,i), r, eps);
end
W = uint8(W.*255); % Remove values which are not in the [0-1] range
W = double(W)/255; 
W = W + 1e-12; %Normalization
W = W./repmat(sum(W,3),[1 1 N]);

function [F] = GuidFuse(I, W_B, W_D)
I = double(I)/255;
se = fspecial('average', [31 31]);
if size(I,3)==3 && size(I,4)~=1
[r,c,M,N]=size(I);
F_B = zeros(r,c,M);
F_D = zeros(r,c,M);
for n=1:N
w_B = W_B(:,:,n);
w_D = W_D(:,:,n);
G = I(:,:,:,n);
B = imfilter(G,se,'replicate'); %equation number 13 in paper
D = G-B;                        % equation number 14
%subplot(6,3,n*3-2);imshow(G);subplot(6,3,n*3-1);imshow(B);subplot(6,3,n*3);imshow(D);
F_B = F_B+B.*repmat(w_B,[1 1 3]);
F_D = F_D+D.*repmat(w_D,[1 1 3]);
end
else
[r,c,N] = size(I);
F_B = zeros(r,c);
F_D = zeros(r,c);
for n=1:N
w_B = W_B(:,:,n);
w_D = W_D(:,:,n);
B = imfilter(I(:,:,n),se,'replicate');  % Getting Base Layer in two scale decomposition
D = I(:,:,n)-B;
F_B = F_B+B.*w_B;
F_D = F_D+D.*w_D;
end
end
F = F_B+F_D;






% ============================================================== % 
% Autores: Antonio Galvão Martins Neto; Gustavo Ruiz de Queiroz  %
% Data: 11/06/2026                                               %
%                                                                %
% Projeto OMR para automação de avaliações de uma ou mais folhas %
% de respostas com base ao um gabarito reservado.                %
%                                                                %
% ============================================================== %

img = imread('prova01.jpg');

grayImg = rgb2gray(img);

T = adaptthresh(grayImg,0.4);
BW = imbinarize(grayImg,T);

BW = ~BW;

BW = bwareaopen(BW,50);

se = strel('disk',2);
BW = imclose(BW,se);

CC = bwconncomp(BW);

stats = regionprops(CC,...
    'Area',...
    'BoundingBox',...
    'Centroid');


tform = fitgeotform2d(...
    pts_img,...
    pts_ref,...
    'projective');

corrigida = imwarp(img,tform);

q = 1:50;
alt = 1:5;

ROI(q,alt).x
ROI(q,alt).y
ROI(q,alt).w
ROI(q,alt).h

sub = BW(y:y+h,x:x+w);

indice = sum(sub(:))/numel(sub);

densidades = [dA dB dC dD dE];

[val,pos] = max(densidades);

letra = 'ABCDE';
resposta = letra(pos);

if sum(densidades > 0.35) > 1
    resposta = 'X';
else 
    resposta = '-';
    
end
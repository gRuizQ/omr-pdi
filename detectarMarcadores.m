% Autores: Antonio Galvão Martins Neto; Gustavo Ruiz de Queiroz  %
% Data: 11/06/2026                                               %
% UTFPR - Processamento Digital de Imagens                       %

function marcadores = detectarMarcadores(img)

% Saída:
% marcadores =
% [xTL yTL
%  xTR yTR
%  xBL yBL
%  xBR yBR]

gray = rgb2gray(img);

figure;
imshow(gray);
title('Cinza');

% binariza e plota a imagem
BW = gray < 80;
figure;
imshow(BW);
title('Imagem binarizada');

% remove ruidos pequenos pela area proporcional
BW = bwareaopen(BW, 500);
CC = bwconncomp(BW);

stats = regionprops(CC,...
    'Area',...
    'BoundingBox',...
    'Centroid');

if isempty(stats)
    error('Nenhum componente encontrado.');
end

% detecta objetos que sao quase quadrados
areas = [];
centers = [];

for i = 1:length(stats)
    bb = stats(i).BoundingBox;

    largura = bb(3);
    altura  = bb(4);
    aspecto = largura/altura;

    % quadrado - aspecto 1
    if aspecto > 0.7 && aspecto < 1.3
        areas(end+1) = stats(i).Area;
        centers(end+1,:) = stats(i).Centroid;
    end
end

if length(areas) < 4
    fprintf('Quantidade de componentes: %d\n', length(stats));
    error('Menos de 4 marcadores encontrados.');
end

% seleciona os 4 maiores quadrados
[~,idx] = sort(areas,'descend');
centers = centers(idx(1:4),:);

% ordenacao dos campos
% separa topo e base
[~,ordY] = sort(centers(:,2));

topo = centers(ordY(1:2),:);
base = centers(ordY(3:4),:);

% esquerda-direita no topo
[~,ordX] = sort(topo(:,1));

TL = topo(ordX(1),:);
TR = topo(ordX(2),:);

% esquerda-direita na base
[~,ordX] = sort(base(:,1));

BL = base(ordX(1),:);
BR = base(ordX(2),:);

marcadores = [
    TL
    TR
    BL
    BR
];

% plot
figure;
imshow(img);
hold on;

plot(marcadores(:,1),...
     marcadores(:,2),...
     'r*',...
     'MarkerSize',12);

text(marcadores(1,1),marcadores(1,2),' TL',...
    'Color','yellow','FontWeight','bold');
text(marcadores(2,1),marcadores(2,2),' TR',...
    'Color','yellow','FontWeight','bold');
text(marcadores(3,1),marcadores(3,2),' BL',...
    'Color','yellow','FontWeight','bold');
text(marcadores(4,1),marcadores(4,2),' BR',...
    'Color','yellow','FontWeight','bold');
title('Marcadores Detectados');

end
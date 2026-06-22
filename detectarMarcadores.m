% ============================================================== % 
% Autores: Antonio Galvão Martins Neto; Gustavo Ruiz de Queiroz  %
% Data: 11/06/2026                                               %
%                                                                %
% UTFPR - Processamento Digital de Imagens                       %
%                                                                %
% Projeto OMR para automação de avaliações de uma ou mais folhas %
% de respostas com base ao um gabarito reservado.                %
%                                                                %
% ============================================================== %

function marcadores = detectarMarcadores(img)

% DETECTARMARCADORES
% Detecta os 4 marcadores fiduciais da folha de respostas.
%
% Saída:
% marcadores =
% [xTL yTL
%  xTR yTR
%  xBL yBL
%  xBR yBR]

%% Converter para cinza

gray = rgb2gray(img);

figure;
imshow(gray);
title('Cinza');


%% Binarização
BW = gray < 80;

figure;
imshow(BW);
title('Imagem binarizada');

%% Remover ruídos pequenos
areaMin = 100; % ajustado para tolerar fotos de longe
BW = bwareaopen(BW, areaMin);

%% Encontrar componentes
CC = bwconncomp(BW);

stats = regionprops(CC,...
    'Area',...
    'BoundingBox',...
    'Centroid');

if isempty(stats)
    error('Nenhum componente encontrado.');
end

%% Procurar objetos aproximadamente quadrados
areas = [];
centers = [];

for i = 1:length(stats)
    bb = stats(i).BoundingBox;

    largura = bb(3);
    altura  = bb(4);

    aspecto = largura/altura;

    % quadrado ≈ aspecto 1 (tolerância aumentada)
    if aspecto > 0.5 && aspecto < 2.0
        areas(end+1) = stats(i).Area;
        centers(end+1,:) = stats(i).Centroid;
    end
end

fprintf('Componentes quadrados encontrados: %d\n', length(areas));
if ~isempty(areas)
    fprintf('Areas: ');
    fprintf('%.0f ', sort(areas, 'descend'));
    fprintf('\n');
end

if length(areas) < 4
    fprintf('Quantidade de componentes quadrados: %d\n', length(areas));
    error('Menos de 4 marcadores encontrados. Tente aproximar a camera ou melhorar a iluminacao.');
end

%% Selecionar os 4 maiores quadrados
[~,idx] = sort(areas,'descend');

centers = centers(idx(1:4),:);

%% Ordenação dos cantos
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

%% Visualização (debug)
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
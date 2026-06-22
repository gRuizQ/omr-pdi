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

function imgCorrigida = corrigirPerspectiva(img, marcadores)

% CORRIGIRPERSPECTIVA
%
% Entrada:
%   img         -> imagem original
%   marcadores  -> [TL; TR; BL; BR]
%
% Saída:
%   imgCorrigida

%% Pontos detectados na imagem

pts_img = marcadores;

%% Pontos de referência da folha gerada

largura = 210;
altura  = 297;

load('layoutFR.mat','fiduciais');

pts_ref = [
    fiduciais(1,1)+5  altura - (fiduciais(1,2)+5)
    fiduciais(2,1)+5  altura - (fiduciais(2,2)+5)
    fiduciais(3,1)+5  altura - (fiduciais(3,2)+5)
    fiduciais(4,1)+5  altura - (fiduciais(4,2)+5)
];

%% Estimar transformação projetiva

disp('pts_img');
disp(pts_img);

disp('pts_ref');
disp(pts_ref);

tform = fitgeotform2d( ...
    pts_img, ...
    pts_ref, ...
    "projective");

%% Definir tamanho da imagem de saída

ref = imref2d([2970 2100], ...
              [0 largura], ...
              [0 altura]);

%% Aplicar transformação

imgCorrigida = imwarp( ...
    img, ...
    tform, ...
    'OutputView', ref);

%% Visualização para debug

figure;
imshow(imgCorrigida);
title('Folha Corrigida');

end
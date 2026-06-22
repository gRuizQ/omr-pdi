% Autores: Antonio Galvão Martins Neto; Gustavo Ruiz de Queiroz  %
% Data: 11/06/2026                                               %
% UTFPR - Processamento Digital de Imagens                       %

function imgCorrigida = corrigirPerspectiva(img, marcadores)

% Entrada:
%   img         -> imagem original
%   marcadores  -> [TL; TR; BL; BR]
%
% Saída:
%   imgCorrigida

pts_img = marcadores;
largura = 210;
altura  = 297;

load('layoutFR.mat','fiduciais');

pts_ref = [
    fiduciais(1,1)+5  altura - (fiduciais(1,2)+5)
    fiduciais(2,1)+5  altura - (fiduciais(2,2)+5)
    fiduciais(3,1)+5  altura - (fiduciais(3,2)+5)
    fiduciais(4,1)+5  altura - (fiduciais(4,2)+5)
];

% estima a transformacao
disp('pts_img');
disp(pts_img);
disp('pts_ref');
disp(pts_ref);

tform = fitgeotform2d( ...
    pts_img, ...
    pts_ref, ...
    "projective");

%% define tamanho da imagem
ref = imref2d([2970 2100], ...
              [0 largura], ...
              [0 altura]);

% aplica a transformacao
imgCorrigida = imwarp( ...
    img, ...
    tform, ...
    'OutputView', ref);

% visualizacao
figure;
imshow(imgCorrigida);
title('Folha Corrigida');

end
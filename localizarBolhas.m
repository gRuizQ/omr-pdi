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

function ROIs = localizarBolhas(imgCorrigida)

% LOCALIZARBOLHAS
%
% Ajusta as ROIs para o tamanho da imagem corrigida.
load('layoutFR.mat','ROI');

[h,w,~] = size(imgCorrigida);

%% Dimensões utilizadas na correção
larguraRef = 2100;
alturaRef  = 2970;

sx = w/larguraRef;
sy = h/alturaRef;

ROIs = ROI;

for q = 1:50
    for alt = 1:5
        ROIs(q,alt).x = round(ROI(q,alt).x * sx * 10);
        ROIs(q,alt).y = round((297 - ROI(q,alt).y) * sy * 10) - 50;
        ROIs(q,alt).w = round(ROI(q,alt).w * sx * 10);
        ROIs(q,alt).h = round(ROI(q,alt).h * sy * 10);
    end
end

fprintf('250 bolhas ajustadas para a imagem.\n');

figure;
imshow(imgCorrigida);
hold on;

for q = 1:50
    for alt = 1:5
        rectangle( ...
            'Position',...
            [ROIs(q,alt).x,...
             ROIs(q,alt).y,...
             ROIs(q,alt).w,...
             ROIs(q,alt).h],...
            'EdgeColor','r');
    end
end

title('ROIs das Bolhas');
end
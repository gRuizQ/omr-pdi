function gerarFR()

close all;
clc;

%% Configurações da folha

largura = 210;   % A4 (mm)
altura  = 297;

figure( ...
    'Color','white',...
    'Units','centimeters',...
    'Position',[1 1 21 29.7]);

axis([0 largura 0 altura]);
axis equal;
axis off;
hold on;

%% --------------------------------------------------
% Marcadores fiduciais
% --------------------------------------------------

fidSize = 10; % mm

fiduciais = [
    10, altura-20;
    largura-20, altura-20;
    10, 10;
    largura-20, 10
];

for k = 1:4

    rectangle( ...
        'Position',...
        [fiduciais(k,1),fiduciais(k,2),fidSize,fidSize],...
        'FaceColor','black');

end

%% --------------------------------------------------
% Tipo de Prova (A, B, C, D)
% --------------------------------------------------

tipoLabels = ['A','B','C','D'];
bolha = 5;
tipoROI = struct();

xBaseTipo = 80;
yTipo = 275;

for alt = 1:4
    x = xBaseTipo + (alt-1)*15;
    rectangle( ...
        'Position',[x,yTipo,bolha,bolha],...
        'EdgeColor','black',...
        'FaceColor','white');

    text(x+6.5,...
         yTipo+0.5,...
         tipoLabels(alt),...
         'FontSize',8,...
         'Color','black');

    tipoROI(alt).x = x;
    tipoROI(alt).y = yTipo;
    tipoROI(alt).w = bolha;
    tipoROI(alt).h = bolha;
end

text(30, yTipo+3, 'TIPO DE PROVA:', 'FontSize',10, 'FontWeight','bold','Color','black');

%% --------------------------------------------------
% Título
% --------------------------------------------------

text(60,260,...
    'FOLHA DE RESPOSTAS',...
    'FontSize',16,...
    'FontWeight','bold',...
    'Color','black');

%% --------------------------------------------------
% Questões
% --------------------------------------------------

alternativas = ['A','B','C','D','E'];
ROI = struct();
q = 1;

for coluna = 1:2
    if coluna == 1
        xBase = 25;
        qIni = 1;
        qFim = 25;
    else
        xBase = 115;
        qIni = 26;
        qFim = 50;
    end

    for questao = qIni:qFim
        linha = questao - qIni;
        y = 230 - linha*8;

        text(xBase-15,...
             y+1,...
             sprintf('%02d',questao),...
             'FontSize',8,...
             'Color','black');

        for alt = 1:5
            x = xBase + (alt-1)*12;
            rectangle( ...
                'Position',[x,y,bolha,bolha],...
                'EdgeColor','black',...
                'FaceColor','white');

            text(x+6.5,...
                 y+0.5,...
                 alternativas(alt),...
                 'FontSize',8,...
                 'Color','black');

            ROI(questao,alt).x = x;
            ROI(questao,alt).y = y;
            ROI(questao,alt).w = bolha;
            ROI(questao,alt).h = bolha;
        end
        q = q + 1;
    end
end

%% --------------------------------------------------
% Salvar PDF
% --------------------------------------------------

exportgraphics(gcf,...
    'FolhaResposta.pdf',...
    'ContentType','vector');

%% --------------------------------------------------
% Salvar coordenadas
% --------------------------------------------------

save( ...
    'layoutFR.mat',...
    'ROI',...
    'tipoROI',...
    'fiduciais');

fprintf('FolhaResposta.pdf gerada com sucesso.\n');
fprintf('layoutFR.mat salvo com sucesso.\n');

end

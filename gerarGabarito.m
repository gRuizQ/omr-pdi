clc;

% gabarito original
gabarito = [ ...
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'
'A'
'B'
'C'
'D'
'E'];

pesos = ones(50,1);
alternativas = ['A','B','C','D','E'];

% shift nas alternaltivas pros outros gabaritos
shiftAlt = @(c, n) alternativas(mod(find(alternativas == c) - 1 + n, 5) + 1);

% gabaritos
gabarito_A = gabarito;
save('gabarito/gabarito_A.mat', 'gabarito_A', 'pesos');
gabarito_B = arrayfun(@(c) shiftAlt(c, 1), gabarito);
save('gabarito/gabarito_B.mat', 'gabarito_B', 'pesos');
gabarito_C = arrayfun(@(c) shiftAlt(c, 2), gabarito);
save('gabarito/gabarito_C.mat', 'gabarito_C', 'pesos');
gabarito_D = arrayfun(@(c) shiftAlt(c, 3), gabarito);
save('gabarito/gabarito_D.mat', 'gabarito_D', 'pesos');

fprintf('Gabaritos gerados com sucesso!\n');
fprintf('  - gabarito_A.mat (original)\n');
fprintf('  - gabarito_B.mat (shift +1)\n');
fprintf('  - gabarito_C.mat (shift +2)\n');
fprintf('  - gabarito_D.mat (shift +3)\n');
clear all;
close all;
%% Partie 1

path = 'football/gray/';

% Lire et afficher deux images consecutives I1 et I2 de la sequence
% football

img_I1 = double(imread(strcat(path,'football010.ras')));
img_I2 = double(imread(strcat(path,'football011.ras')));


% Ecrire une fonction qui estime le mouvement de I1 vers I2 par Block
% Matching

window = 15;
bloc = 8;
win_size = fix(15/2);

[bloc_y_M, bloc_x_M] = size(img_I2);     % [Lignes, Colonnes]
bloc_y_M = bloc_y_M/8;
bloc_x_M = bloc_x_M/8;

R = nan(bloc_y_M, bloc_x_M);
vect = cell(bloc_y_M, bloc_x_M);

figure(1);
imshow(img_I1/255);
figure(2);
imshow(img_I2/255);


%% Calculation (~3s)
for k=1:bloc_y_M % lignes
    fprintf('Traitement de la ligne %d sur %d\n', k, bloc_y_M);
    for l=1:bloc_x_M % colonnes
        I = k;      % ligne
        J = l;      % colonne
        R = nan(bloc_y_M, bloc_x_M);
        bloc_n = img_I2( ((I-1)*bloc+1):(I*bloc), ((J-1)*bloc+1):(J*bloc) );

        for i=max(1, I - win_size):1:min(bloc_y_M, I + win_size)    % lignes
            for j=max(1, J - win_size):1:min(bloc_x_M, J + win_size) % colonnes
                bloc_n_1 = img_I1(((i-1)*bloc+1):(i*bloc), ((j-1)*bloc+1):(j*bloc));
                R(i,j) = sum(sum(abs(bloc_n-bloc_n_1)));
            end
        end
        [R, m] = min(R);
        [z, n] = min(R);
        
        vect{k, l} = [m(n) n];
   end
end

%% Results - Warning : it takes some time (>30s) due to quiver
figure;
imshow(img_I2/255);
hold on;

for k=1:bloc_y_M
    fprintf('Traitement de la ligne %d sur %d\n', k, bloc_y_M);
    for l=1:bloc_x_M
    quiver(l*bloc - bloc/2, k*bloc - bloc/2, (vect{k,l}(2)-l)*bloc, (vect{k,l}(1)-k)*bloc);
   end
end

% Lorsqu'il n'y a pas de fleche, c'est qu'elle pointe sur elle meme.

%% Partie 2

% Difference simple I2 - I1
figure;
diff_simple = img_I2 - img_I1;
diff_show = (diff_simple - min(min(diff_simple)))/(max(max(diff_simple)-min(min(diff_simple))));
imshow(diff_show);

%% Image I1C

dim = size(img_I2);
img_I1C = zeros(dim);

for k=1:dim(1) % lignes
    for l=1:dim(2) % colonnes
        nk = fix((k-1)/8)+1;
        nl = fix((l-1)/8)+1;
        img_I1C(k,l) = img_I2(((vect{nk,nl}(1)-1)*bloc)+1 + mod(k-1,8), ((vect{nk,nl}(2)-1)*bloc)+1 + mod(l-1,8));
   end
end
figure;
imshow(img_I1C/255);

%% Difference entre I2 et I1C
figure;
diff_simple2 = double(img_I2 - img_I1C);
diff_show2 = (diff_simple2 - min(min(diff_simple2)))/max(max(diff_simple2)-min(min(diff_simple2)));
imshow(diff_show2);

%% Entropies

% I1
fprintf('Entropie de I1: %d \n', my_entropy(img_I1));
% I2
fprintf('Entropie de I2: %d \n', my_entropy(img_I2));
% I2 - I1
fprintf('Entropie de I2-I1: %d \n', my_entropy(img_I2-img_I1));
% I2 - I1C
fprintf('Entropie de I2-I1C: %d \n', my_entropy(img_I2-img_I1C));

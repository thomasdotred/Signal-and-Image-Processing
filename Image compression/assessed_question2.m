% Edicted by Toby Thomas, 2017
%% Lab 6 Assessed question: Compressing biological data
%% (a) Load and show data
clear

% change directory to current file
% make sure your current working directory contains the "data" folder and 
% the provided functions. "data" contains "DNA.dat"        
        
try
    editor_service = com.mathworks.mlservices.MLEditorServices;
    editor_app = editor_service.getEditorApplication;
    active_editor = editor_app.getActiveEditor;
    storage_location = active_editor.getStorageLocation;
    file = char(storage_location.getFile);
    path = fileparts(file);
    cd(path);
catch e
    error('change manually into the folder where this file is located');
end

% load data
basepairs = load_dna();

disp('The below excerpt of the data shows')
disp('100 samples from each of the aligned DNA samples printed as text:')
disp(char(basepairs(:,1:100)))

% we convert the character encoded data to data in the range [1:4] for ease
% of use. 1 stands for A, 2 for C and so on.
alphabet = 'ACGT' ;
for i=1:numel(alphabet)
    basepairs(basepairs==int8(alphabet(i)))=i;
end

%% (b) Naive encoding vs Huffman coding
% We have four bases which can be represented in four symbols with two
% elements.
% Fixed length code must be at least 3 bits per codeword , so this is not a
% valid huffman code.
DNA_huff = huffman([0.25 0.25 0.25 0.25]);

%% (c) The genome of plasmodium falciparum
figure;
hold on
for PAT = 0.05:0.05:0.45
    PCG = 0.5 - PAT;
    %
    huff_b = huffman([PAT PAT PCG PCG]);
    %
    entr = Entropy([1 2 3 4]);
    bits_per_sym = BitsPerSymbol(huff_b, [PAT, PAT, PCG, PCG]');
    plot(PAT, bits_per_sym, 'kx');
    xlabel('Probability')
    ylabel('Average Code Length')
    
end

PAT = 0.403;
PCG = 0.5 - PAT;
huff_b = huffman([PAT, PAT, PCG, PCG]);
entr = Entropy([1 2 3 4]); 
bits_per_sym = BitsPerSymbol(huff_b, [PAT, PAT, PCG, PCG]');
fprintf('Entropy = %f\nBits per symbol = %f\n', entr,bits_per_sym);

%% (d) Investigate the base pair bias
figure(2); clf(2)
h = [];

% full DNA dataset (including all bases of all 10 samples)
basepairs_subset = basepairs;
nsamples = size(basepairs_subset,1);
symbols = unique(basepairs(:));
nsymbols = numel(symbols);

p = ProbabilityMass(basepairs_subset);
h(end+1) = subplot(3,1,1); bar(symbols, p);
H = Entropy(basepairs_subset);
title(['full dataset H: ' num2str(H)])
ylabel('probability mass'); xlabel('symbol')

% dataset split into roughly 4 parts along the length of the 10 DNA samples
for istart=1:4'
    N = 10000;
    start=(istart-1)*350000 + 1;
    stop = start+N-1;
    basepairs_subset=basepairs(:,start:stop);

    nsamples = size(basepairs_subset,1);
    symbols = unique(basepairs(:));
    nsymbols = numel(symbols);

    p = ProbabilityMass(basepairs_subset);
    h(end+1) = subplot(3,2,istart+2); bar(symbols, p);
    H = Entropy(basepairs_subset);
    ylabel('probability mass'); xlabel('symbol')
    title(sprintf('from %d to %d, H: %0.5f',start,stop,H))
end
linkaxes(h,'y')

% If we look at subsets, we can get below the entropy of the entire code.

%% (e) Huffman encode the last subset of the DNA (basepairs_subset)

S_message = numel(basepairs_subset) * 8.0; % bit
Sub_huff = huffman(p);
% 

S_Huff = 100000*2+4*8; 
fprintf('size of huffman encoded meddage in bit is %f\n', S_Huff);

%% (f) Calculate the consensus and "deviation" across samples

basepairs_subset_cons = median(basepairs_subset,1); % consensus in the same shape as each sample

% signed difference to consensus
Delta = basepairs_subset - repmat(basepairs_subset_cons,10,1);

% plot probability mass function
p=ProbabilityMass(Delta);
close all; bar(unique(Delta(:)),p)
xlabel('Difference to consensus')

%% (g) Consistency across samples
consistency = 1 - sum(Delta~=0,1) / nsamples;
imagesc(reshape(consistency,100,100)); title('consistency as image (column major)'); colorbar

%% (h) Huffman compressed size of consensus aligned data

consaligned = [basepairs_subset_cons;Delta];
[m n] = size(consaligned);
prob_mass_consaligned = ProbabilityMass(consaligned);
subset_huff = huffman(prob_mass_consaligned);
bps = BitsPerSymbol(subset_huff, prob_mass_consaligned);

S_diff_Huff = (m*n) * bps + 8;
fprintf('Total size of coaligned when huffnam encoded is %f', S_diff_Huff)
%% (i) RLE of orignal message (S_RLE), then Huffman on output of RLE (S_RLE_Huff)

RLE_dna = RLE(basepairs_subset);
RLE_coali = RLE(consaligned);
S_RLE = numel(RLE_dna)*8;  %33858
S_diff_RLE = numel(RLE(consaligned))*8;  %59158
p1 = ProbabilityMass(RLE_dna);
p2 = ProbabilityMass(RLE_coali);

Subset_RLE_Huff = huffman(p1);
bps1 = BitsPerSymbol(Subset_RLE_Huff, p1);  %2.9805
S_RLE_Huff = 33858*2.9805+8;  %100920
Subset_diff_RLE_Huff = huffman(p2);
bps2 = BitsPerSymbol(Subset_diff_RLE_Huff, p2);  %2.8219
S_diff_RLE_Huff = 59158*2.8219+8;  %166950



%% (j) Results, Why is 6. worse than 4.?
data = {'1. original sequence (8bit/symbol)';
    '2. Huffman of original';
    '3. Huffman of consensus aligned';
    '4. RLE of original';
    '5. RLE of original -> Huffman';
    '6. RLE of consensus aligned';
    '7. RLE of consensus algined -> Huffman'};
total_size_bits = [S_message;
    S_Huff;
    S_diff_Huff;
    S_RLE;
    S_RLE_Huff;
    S_diff_RLE;
    S_diff_RLE_Huff];
compression_fold = S_message ./ total_size_bits;

format long
disp(table(total_size_bits,compression_fold,'RowNames',data));


%% (k) How could one improve on the compression achieved with the method 5.?

% The array size of the RLE consensus alligned has 8 values
% The array size of the RLE of the original has 4 values so it performs
% better thann the RLE concensus alligned. This is because four values,
% there is a higher probabillity that there will be repeated groups of the
% same number which makes the RLE more efficient.

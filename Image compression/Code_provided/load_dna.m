function [DNA] = load_dna()
fid = fopen('data/DNA.dat', 'rb');
dna_8 = fread(fid, '*int8')';
fclose(fid);

n_samples = sum(dna_8==10);
DNA = reshape(dna_8, numel(dna_8) / n_samples, n_samples)';
DNA = DNA(:,1:end-1);
end

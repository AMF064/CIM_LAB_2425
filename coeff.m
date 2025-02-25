nums = [0.0007 -0.0070 0.0368 -0.1376 0.6071 0.6071 -0.1376 0.0368 -0.0070 0.0007];
k = floor(log2(127/max(nums)))
coeffs = 2^k * nums';
round_coeffs = round(coeffs)
assert(round_coeffs < 2^8);
constant = 2^k

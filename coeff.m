nums = [-0.0558 0.0001 0.0893 0.2101 0.2971 0.2971 0.2101 0.0893 0.0001 -0.0558];
k = floor(log2(127/max(nums)))
coeffs = 2^k * nums';
round_coeffs = round(coeffs)
assert(round_coeffs < 2^7 - 1);
constant = 2^k

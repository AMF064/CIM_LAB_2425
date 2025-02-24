nums = [ -0.0021 -0.0243 -0.0191 0.1496 0.3958 0.3958 0.1496 -0.0191 -0.0243 -0.0021];
constant = 127 / max(nums);
coeffs = constant * nums';
disp(round(coeffs));
disp(constant);

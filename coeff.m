nums = [0.0007 -0.0070 0.0368 -0.1376 0.6071 0.6071 -0.1376 0.0368 -0.0070 0.0007];
constant = 127 / max(nums);
coeffs = constant * nums';
disp(round(coeffs));
disp(["Constant: " num2str(constant)]);

t = linspace(0, 1, 17);
f = 127 * sin(2 * pi * t);
stem(t, f);
dec2bin(floor(f(1:16)))

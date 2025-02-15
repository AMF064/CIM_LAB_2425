library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GenSen is
    port (Clk, Reset : in std_logic;
          per : in std_logic_vector(1 downto 0);
          led : out signed(7 downto 0);
          dac : out unsigned(7 downto 0));
end GenSen;

-- Grupo 20:
--     00 :  600
--     01 : 1000
--     10 : 2200
--     11 : 3900

architecture behaviour of GenSen is
begin
end architecture;

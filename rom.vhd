library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (address : in natural range 0 to 15;
          data_out : out signed(7 downto 0));
end rom;

architecture behaviour of rom is
    type rom_t is array(0 to 15) of signed(7 downto 0);
    constant memory : rom_t := (
    to_signed(   0, 8),
    to_signed(  48, 8),
    to_signed(  89, 8),
    to_signed( 117, 8),
    to_signed( 127, 8),
    to_signed( 117, 8),
    to_signed(  89, 8),
    to_signed(  48, 8),
    to_signed(   0, 8),
    to_signed( -49, 8),
    to_signed( -90, 8),
    to_signed(-118, 8),
    to_signed(-127, 8),
    to_signed(-118, 8),
    to_signed( -90, 8),
    to_signed( -49, 8));
begin
    data_out <= memory(address);
end architecture;

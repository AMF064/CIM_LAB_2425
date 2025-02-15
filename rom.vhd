library ieee;
use ieee.std_logic_1164.all;

entity rom is
    port (address : in natural range 0 to 255;
          data_out : out std_logic_vector(7 downto 0));
end rom;

architecture behaviour of rom is
    type rom_t is array(0 to 255) of std_logic_vector(7 downto 0);
    constant memory : rom_t := (others => (others => '0'));
begin
    data_out <= memory(address);
end architecture;

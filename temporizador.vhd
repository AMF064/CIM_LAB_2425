library ieee;
use ieee.std_logic_1164.all;

entity temporizador is
    generic ( MaxCount : natural );
    port (clk, reset : in std_logic; eoc : out std_logic);
end temporizador;

architecture behaviour of temporizador is
    signal count : natural range 0 to MaxCount;
begin
    eoc <= '1' when count = MaxCount else '0';

    process(clk, reset)
    begin
        if reset = '0' then
            count <= 0;
        elsif rising_edge(clk) then
            if count = MaxCount then
                count <= 0;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
end architecture;

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

    component rom is
        port (address : in natural range 0 to 15;
              data_out : out std_logic_vector(7 downto 0));
    end component;

    signal max_count_s, timer_s : natural range 0 to 3900;
    signal ptr_s : natural range 0 to 15;
    signal data_s : std_logic_vector(7 downto 0);
    signal eoc_s : std_logic;
begin

    led <= signed(data_s);
    dac <= signed(data_s) + 128;

    eoc_s <= '1' when timer_s = max_count_s, else '0';

    with per select
        max_count_s <=  600 when "00",
                       1000 when "01",
                       2200 when "10",
                       3900 when others;

    sine_rom: rom
    port map (
        address => ptr_s,
        data_out => data_s);

    timer: process(Clk, Reset)
    begin
        if Reset = '0' then
            timer_s <= 0;
        elsif rising_edge(Clk) then
            if timer_s = max_count_s then
                timer_s <= 0;
            else
                timer_s <= timer_s + 1;
    end process;

    pointer: process(Clk, Reset)
    begin
        if Reset = '0' then
            ptr_s <= 0;
        elsif rising_edge(Clk) then
            if eoc_s = '1' then
                if ptr_s = 15 then
                    ptr_s <= 0;
                else
                    ptr_s <= ptr_s + 1;
                end if;
            end if;
        end if;
    end process;
end architecture;

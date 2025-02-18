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
--     00 :  600 Hz
--     01 : 1000 Hz
--     10 : 2200 Hz
--     11 : 3900 Hz
-- Calculos para hallar los numeros que hay que poner:
--
--
--
--
--            o
--         o  |  o
--      o  |  |  |  o
--   o  |  |  |  |  |  o
--o--|--|--|--|--|--|--|--o--|--|--|--|--|--|--|--|--o--------------
--   <-->                    o  |  |  |  |  |  |  o
--Tclk x N                      o  |  |  |  |  o
--                                 o  |  |  o
--                                    o  o
--
-- Periodo completo: T = 16 * N * Tclk, donde N es el numero al que cuenta el temporizador.
--  Para sacar una frecuencia concreta:
--              f = 1/T = 1 / 16 / N / Tclk; N = fclk / 16 / f
--
--   f = 600 Hz : N ~ 10417
--   f = 1 KHz  : N = 6250
--   f = 2.2KHz : N ~ 2841
--   f = 3.9KHz : N ~ 1603

architecture behaviour of GenSen is

    component rom is
        port (address : in natural range 0 to 15;
              data_out : out signed(7 downto 0));
    end component;

    signal max_count_s, timer_s : natural range 0 to 10420;
    signal ptr_s : natural range 0 to 15;
    signal data_s : signed(7 downto 0);
    signal eoc_s : std_logic;
begin

    led <= data_s;
    dac <= unsigned(data_s) + to_unsigned(128, 8);
    eoc_s <= '1' when timer_s >= max_count_s else '0';

    with per select
        max_count_s <=  10417 when "00",
                         6250 when "01",
                         2841 when "10",
                         1603 when others;

    timer: process(Clk, Reset)
    begin
        if Reset = '0' then
            timer_s <= 0;
        elsif rising_edge(Clk) then
            if timer_s >= max_count_s then
                timer_s <= 0;
            else
                timer_s <= timer_s + 1;
            end if;
        end if;
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

    sine_rom: rom
    port map (address => ptr_s,
              data_out => data_s);
end architecture;

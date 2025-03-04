library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FIR is
    generic (a0 : integer range -128 to 127;
             a1 : integer range -128 to 127;
             a2 : integer range -128 to 127;
             a3 : integer range -128 to 127;
             a4 : integer range -128 to 127;
             a5 : integer range -128 to 127;
             a6 : integer range -128 to 127;
             a7 : integer range -128 to 127;
             a8 : integer range -128 to 127;
             a9 : integer range -128 to 127);
    port (Clk, Reset, Enable : in std_logic;
          DataIn : in signed(7 downto 0);
          DataOut : out signed(7 downto 0));
end FIR;

-- Store the samples of the signal in a shift buffer, then
--  multiply and add just in the output.
architecture parallel of FIR is
    type buffer_t is array(integer range 0 to 9) of signed(7 downto 0);
    signal sample_buffer : buffer_t;
    signal out_s : signed(25 downto 0);
begin

    DataOut <= out_s(16 downto 9);
    out_s <= resize(a0 * sample_buffer(0), out_s'length) +
             resize(a1 * sample_buffer(1), out_s'length) +
             resize(a2 * sample_buffer(2), out_s'length) +
             resize(a3 * sample_buffer(3), out_s'length) +
             resize(a4 * sample_buffer(4), out_s'length) +
             resize(a5 * sample_buffer(5), out_s'length) +
             resize(a6 * sample_buffer(6), out_s'length) +
             resize(a7 * sample_buffer(7), out_s'length) +
             resize(a8 * sample_buffer(8), out_s'length) +
             resize(a9 * sample_buffer(9), out_s'length) when Reset = '1' else (others => '0');

    calculation: process (Clk, Reset)
    begin
        if Reset = '0' then
            out_s <= (others => '0');
            sample_buffer <= (others => (others => '0'));
        elsif rising_edge(Clk) then
            if Enable = '1' then
                sample_buffer <= DataIn & sample_buffer(0 to 8);
            end if;
        end if;
    end process;
end architecture;

-- architecture pipelined of FIR is
--     type buffer_t is array(integer range 0 to 10) of signed(7 downto 0);
--     type inter_buf_t is array(integer range 0 to 2) of signed(24 downto 0);
--     signal sample_buffer : buffer_t;
--     signal intermed_buffer : inter_buf_t;
--     signal out_s : signed(25 downto 0);
-- begin
--
--     DataOut <= out_s(16 downto 9);
--
--     process (Clk, Reset)
--     begin
--         if Reset = '0' then
--             out_s <= (others => '0');
--             sample_buffer <= (others => (others => '0'));
--             intermed_buffer <= (others => (others => '0'));
--         elsif rising_edge(Clk) then
--             if Enable = '1' then
--                 sample_buffer <= DataIn & sample_buffer(0 to (sample_buffer'right - 1));
--                 intermed_buffer(0) <= resize(a0 * DataIn, intermed_buffer(0)'length);
--                 -- Se incrementa el indice que se lee una vez mas por cada registro que se pone
--                 intermed_buffer(1) <= intermed_buffer(0) + resize(a1 * sample_buffer(0 + 1), intermed_buffer(0)'length);
--                 intermed_buffer(2) <= intermed_buffer(1) + resize(a2 * sample_buffer(1 + 1 + 1), intermed_buffer(0)'length) +
--                                       resize(a3 * sample_buffer(2 + 1 + 1), intermed_buffer(0)'length) +
--                                       resize(a4 * sample_buffer(3 + 1 + 1), intermed_buffer(0)'length) +
--                                       resize(a5 * sample_buffer(4 + 1 + 1), intermed_buffer(0)'length) +
--                                       resize(a6 * sample_buffer(5 + 1 + 1), intermed_buffer(0)'length) +
--                                       resize(a7 * sample_buffer(6 + 1 + 1), intermed_buffer(0)'length) +
--                                       resize(a8 * sample_buffer(7 + 1 + 1), intermed_buffer(0)'length);
--                 out_s <= intermed_buffer(2) + resize(a9 * sample_buffer(10), out_s'length);
--             end if;
--         end if;
--     end process;
-- end architecture;

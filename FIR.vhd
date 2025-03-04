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
    type buffer_t is array(integer range 0 to 8) of signed(7 downto 0);
    signal sample_buffer : buffer_t;
    signal out_s : signed(25 downto 0);
begin

    DataOut <= out_s(16 downto 9);

    calculation: process (Clk, Reset)
    begin
        if Reset = '0' then
            out_s <= (others => '0');
            sample_buffer <= (others => (others => '0'));
        elsif rising_edge(Clk) then
            if Enable = '1' then
                sample_buffer <= DataIn & sample_buffer(0 to sample_buffer'right - 1);
                out_s <= resize(a0 * DataIn, out_s'length) +
                         resize(a1 * sample_buffer(0), out_s'length) +
                         resize(a2 * sample_buffer(1), out_s'length) +
                         resize(a3 * sample_buffer(2), out_s'length) +
                         resize(a4 * sample_buffer(3), out_s'length) +
                         resize(a5 * sample_buffer(4), out_s'length) +
                         resize(a6 * sample_buffer(5), out_s'length) +
                         resize(a7 * sample_buffer(6), out_s'length) +
                         resize(a8 * sample_buffer(7), out_s'length) +
                         resize(a9 * sample_buffer(8), out_s'length);
            end if;
        end if;
    end process;
end architecture;

architecture pipelined of FIR is
    type buffer_t is array(integer range 0 to 9) of signed(7 downto 0);
    signal sample_buffer : buffer_t;
    signal out_s : signed(25 downto 0);
    signal intermed_0 : signed(15 downto 0);
    signal intermed_1 : signed(16 downto 0);
    signal intermed_2 : signed(17 downto 0);
    signal intermed_3 : signed(18 downto 0);
    signal intermed_4 : signed(19 downto 0);
    signal intermed_5 : signed(20 downto 0);
    signal intermed_6 : signed(21 downto 0);
    signal intermed_7 : signed(22 downto 0);
    signal intermed_8 : signed(23 downto 0);
begin

    DataOut <= out_s(16 downto 9);

    process (Clk, Reset)
    begin
        if Reset = '0' then
            out_s <= (others => '0');
            sample_buffer <= (others => (others => '0'));
        elsif rising_edge(Clk) then
            if Enable = '1' then
                sample_buffer <= DataIn & sample_buffer(0 to 8);
                intermed_0 <= resize(a0 * sample_buffer(0), intermed_0'length);
                intermed_1 <= resize(intermed_0, intermed_1'length) + resize(a1 * sample_buffer(1), intermed_1'length);
                intermed_2 <= resize(intermed_1, intermed_2'length) + resize(a2 * sample_buffer(2), intermed_2'length);
                intermed_3 <= resize(intermed_2, intermed_3'length) + resize(a3 * sample_buffer(3), intermed_3'length);
                intermed_4 <= resize(intermed_3, intermed_4'length) + resize(a4 * sample_buffer(4), intermed_4'length);
                intermed_5 <= resize(intermed_4, intermed_5'length) + resize(a5 * sample_buffer(5), intermed_5'length);
                intermed_6 <= resize(intermed_5, intermed_6'length) + resize(a6 * sample_buffer(6), intermed_6'length);
                intermed_7 <= resize(intermed_6, intermed_7'length) + resize(a7 * sample_buffer(7), intermed_7'length);
                intermed_8 <= resize(intermed_7, intermed_8'length) + resize(a8 * sample_buffer(8), intermed_8'length);
                out_s      <= resize(intermed_8, out_s'length) + resize(a9 * sample_buffer(9), out_s'length);
            end if;
        end if;
    end process;
end architecture;

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
    constant constants : buffer_t := (
    to_signed(a0, 8),
    to_signed(a1, 8),
    to_signed(a2, 8),
    to_signed(a3, 8),
    to_signed(a4, 8),
    to_signed(a5, 8),
    to_signed(a6, 8),
    to_signed(a7, 8),
    to_signed(a8, 8),
    to_signed(a9, 8));
    type aux_mult_t is array(integer range 0 to 9) of signed(15 downto 0);
    signal aux_mult : aux_mult_t;
    signal out_s : signed(25 downto 0);
begin
    calculation: process (Clk, Reset)
    begin
        if Reset = '0' then
            out_s <= (others => '0');
            sample_buffer <= (others => (others => '0'));
        elsif rising_edge(Clk) then
            if Enable = '1' then
                sample_buffer <= DataIn & sample_buffer(0 to 8);
                for i in 0 to 9 loop
                    aux_mult(i) <= constants(i) * sample_buffer(i);
                end loop;
                out_s <= resize(aux_mult(0), out_s'length) +
                         resize(aux_mult(1), out_s'length) +
                         resize(aux_mult(2), out_s'length) +
                         resize(aux_mult(3), out_s'length) +
                         resize(aux_mult(4), out_s'length) +
                         resize(aux_mult(5), out_s'length) +
                         resize(aux_mult(6), out_s'length) +
                         resize(aux_mult(7), out_s'length) +
                         resize(aux_mult(8), out_s'length) +
                         resize(aux_mult(9), out_s'length);
            end if;
        end if;
    end process;

    register_out: process(Clk, Reset)
    begin
        if Reset = '0' then
            DataOut <= (others => '0');
        elsif rising_edge(Clk) then
            if Enable = '1' then
                DataOut <= out_s(16 downto 9);
            end if;
        end if;
    end process;
end architecture;

-- architecture pipelined of FIR is
--     type buffer_t is array(integer range 0 to 9) of signed(7 downto 0);
--     type pipe_buffer_t is array(integer range 0 to 8) of signed(7 downto 0);
--     signal intermed_buffer : pipe_buffer_t;
--     signal sample_buffer : buffer_t;
-- begin
--     process (Clk, Reset)
--     begin
--         if Reset = '0' then
--             DataOut <= (others => '0');
--             intermed_buffer <= (others => (others => '0'));
--         elsif rising_edge(Clk) then
--             if Enable = '1' then
--                 sample_buffer <= DataIn & sample_buffer(1 to 8);
--                 intermed_buffer(0) <= a0 * sample_buffer(0);
--                 intermed_buffer(1) <= intermed_buffer(0) + a1 * sample_buffer(1);
--                 intermed_buffer(2) <= intermed_buffer(1) + a2 * sample_buffer(2);
--                 intermed_buffer(3) <= intermed_buffer(2) + a3 * sample_buffer(3);
--                 intermed_buffer(4) <= intermed_buffer(3) + a4 * sample_buffer(4);
--                 intermed_buffer(5) <= intermed_buffer(4) + a5 * sample_buffer(5);
--                 intermed_buffer(6) <= intermed_buffer(5) + a6 * sample_buffer(6);
--                 intermed_buffer(7) <= intermed_buffer(6) + a7 * sample_buffer(7);
--                 intermed_buffer(8) <= intermed_buffer(7) + a8 * sample_buffer(8);
--                 DataOut <= intermed_buffer(8) + a9 * sample_buffer(9);
--             else
--                 DataOut <= (others => '0');
--             end if;
--         end if;
--     end process;
-- end architecture;

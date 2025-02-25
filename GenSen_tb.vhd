library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GenSen_tb is
begin
end GenSen_tb;

architecture sim of GenSen_tb is

    component GenSen is
        port (Clk, Reset : in std_logic;
              per : in std_logic_vector(1 downto 0);
              led : out signed(7 downto 0);
              dac : out unsigned(7 downto 0));
    end component;

    signal clk_s, reset_s : std_logic;
    signal per_s : std_logic_vector(1 downto 0);
    signal led_s : signed(7 downto 0);
    signal dac_s : unsigned(7 downto 0);

    constant PERIOD : time := 10 ns; -- 100 MHz
    constant TEST_DURATION : time := 20 ms;
begin
    clock: process
    begin
        clk_s <= '1';
        wait for PERIOD / 2;
        clk_s <= '0';
        wait for PERIOD / 2;
    end process;

    rst: process
    begin
        reset_s <= '0';
        wait for 2 ns;
        reset_s <= '1';
        wait;
    end process;

    periods: process
    begin
        per_s <= "00";
        wait for TEST_DURATION/5;
        per_s <= "01";
        wait for TEST_DURATION/5;
        per_s <= "00";
        wait for TEST_DURATION/5;
        per_s <= "10";
        wait for TEST_DURATION/5;
        per_s <= "11";
        wait for TEST_DURATION/5;
    end process;

    end_test: process
    begin
        wait for TEST_DURATION;
        assert False
        report "OK" severity failure;
    end process;

    UUT: GenSen
    port map (Clk => clk_s,
              Reset => reset_s,
              per => per_s,
              dac => dac_s,
              led => led_s);
end architecture;

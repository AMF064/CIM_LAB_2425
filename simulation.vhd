library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simulation is
end simulation;

architecture Behavioral of simulation is
    signal clock : std_logic := '0';  
    signal reset_signal : std_logic := '1';  
    signal period : std_logic_vector(1 downto 0) := "11";  
    signal leds : signed(7 downto 0);  
    signal dacs : unsigned(7 downto 0);  

    constant clock_period : time := 10 ns;  
begin
    -- Instantiate the GenSen design
    UUT: entity work.GenSen
        port map (
            clk => clock,
            reset => reset_signal,
            per => period,
            led => leds,
            dac => dacs
        );

    -- Process to generate the clock
    clock_process: process
    begin
        while now < 1000 ms loop  
            clock <= not clock;  
            wait for clock_period / 2;  
        end loop;
        wait;
    end process;

    -- Process to generate the reset signal
    reset_process: process
    begin
        reset_signal <= '1';  
        wait for clock_period;  
        reset_signal <= '0';  
        wait;
    end process;

    -- Process to change the period signal for simulation
    change_period_process: process
    begin
        period <= "00";
        wait for 8 ms;
        period <= "01";
        wait for 8 ms;
        period <= "10";
        wait for 8 ms;
        period <= "11";
        wait for 8 ms;
        wait;
    end process;
end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GenSen is
    port (
        clk : in std_logic;
        reset : in std_logic;
        per : in std_logic_vector(1 downto 0);
        led : out signed(7 downto 0);
        dac : out unsigned(7 downto 0)
    );
end GenSen;

architecture Behavioral of GenSen is
    -- Instance of the ROM
    component sine_rom
        port (
            address : in integer range 0 to 15;
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;
        
    -- Signal declarations
    -- Timer
    signal timer_count : integer range 0 to 20833 := 0;
    -- Maximum count for the timer
    signal max_count : integer := 20833;
    -- Counter
    signal rom_count : integer range 0 to 15 := 0;
    signal rom_data : std_logic_vector(7 downto 0);
    signal rom_address : integer range 0 to 15;
       
begin
    ROM_map: sine_rom port map (address => rom_address, data_out => rom_data);
    
    Process(per)
    begin
        case per is
            when "00" => max_count <= 20833; -- Frequency of 300Hz
            when "01" => max_count <= 10417;  -- Frequency of 600Hz
            when "10" => max_count <= 3472;  -- Frequency of 1800Hz
            when others => max_count <= 1732; -- Frequency of 3600Hz
        end case;
    end process;
    
    -- Timer and Counter utilization
    Process(clk, reset)
    begin
        -- Reset
        if reset = '1' then
            timer_count <= 0;
            rom_count <= 0;
        elsif rising_edge(clk) then
            if timer_count >= max_count then
                timer_count <= 0;
                if rom_count >= 15 then
                    rom_count <= 0;
                else
                    rom_count <= rom_count + 1;
                end if;
            else
                timer_count <= timer_count + 1;
            end if;      
        end if;
    end process;
    
    rom_address <= rom_count;
    led <= signed(rom_data);
    dac <= 128 + unsigned(rom_data);

end Behavioral;
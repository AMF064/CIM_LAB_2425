library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rom_sine is
    port (
        address : in integer range 0 to 15;
        data_out : out std_logic_vector(7 downto 0)
    );
end rom_sine;

architecture Behavioral of rom_sine is
    -- Definition of ROM memory consisting of 16 addresses and 8-bit data
    type rom_t is array (0 to 15) of std_logic_vector(7 downto 0);
    -- Assign hexadecimal values to the addresses of our ROM memory
    signal rom : rom_t := (
        x"00", -- Address = 0, Value = 0
        x"31", -- Address = 1, Value = 49
        x"5A", -- Address = 2, Value = 90
        x"75", -- Address = 3, Value = 117
        x"7F", -- Address = 4, Value = 127
        x"75", -- Address = 5, Value = 117
        x"5A", -- Address = 6, Value = 90
        x"31", -- Address = 7, Value = 49
        x"00", -- Address = 8, Value = 0
        x"CF", -- Address = 9, Value = -49
        x"A6", -- Address = A, Value = -90
        x"8B", -- Address = B, Value = -117
        x"81", -- Address = C, Value = -127
        x"8B", -- Address = D, Value = -117
        x"A6", -- Address = E, Value = -90
        x"CF"  -- Address = F, Value = -49
    );
begin
    data_out <= rom(address);
end Behavioral;
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.11.2023 17:10:57
-- Design Name: 
-- Module Name: data_memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_memory is
    Port ( 
        din : in STD_LOGIC_VECTOR(15 downto 0); 
        clk : in std_logic;
        dout : out STD_LOGIC_VECTOR (15 downto 0);
        addr : in STD_LOGIC_VECTOR (8 downto 0);
        WR : in STD_LOGIC);
end data_memory;

architecture Behavioral of data_memory is

type ram_mem is array (0 to 1023 ) of std_logic_vector (7 downto 0);
signal data_mem: ram_mem :=(
     x"06",
     x"00",
     
     x"01",
     x"00",
          
     x"02",
     x"00",
     
     x"03",
     x"00",
     
     x"04",
     x"00",
     
     x"05",
     x"00",
     
     x"07",
     x"00",      
    others => x"FF"
   ); 

signal computed_addr:std_logic_vector(9 downto 0);
begin

computed_addr <= addr & '0';

RAM_PROCESS:process(clk)
begin
    if rising_edge(clk) then 
        if WR = '1' then 
            data_mem(to_integer(unsigned(computed_addr))) <= din(7 downto 0);
            data_mem(to_integer(unsigned(computed_addr) + 1)) <= din(15 downto 8);
        end if ;
    end if;
end process;

dout(7 downto 0) <= data_mem(to_integer(unsigned(computed_addr))); 
dout(15 downto 8) <= data_mem(to_integer(unsigned(computed_addr) + 1)); 

end Behavioral;

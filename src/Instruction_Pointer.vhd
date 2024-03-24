----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2023 19:27:53
-- Design Name: 
-- Module Name: Instruction_Pointer - Behavioral
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
use IEEE.numeric_std.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruction_Pointer is
    Port ( ADDR_IN : in STD_LOGIC_VECTOR (15 downto 0);
           ADDR_OUT : out STD_LOGIC_VECTOR (8 downto 0);
           CLK: in STD_LOGIC;
           RD : in STD_LOGIC;
           INC : in STD_LOGIC);
end Instruction_Pointer;

architecture Behavioral of Instruction_Pointer is
signal intern_count: STD_LOGIC_VECTOR(8 downto 0):= "000000000";
begin

ADDR_OUT <= intern_count;
IP:process(CLK)
begin
    if rising_edge(CLK) then
        if INC = '1' then
            intern_count <=std_logic_vector(unsigned(intern_count) + 1);
        else 
            if RD = '1' then 
                intern_count <= ADDR_IN(8 downto 0);
            end if;
        end if;
    end if;
end process;


end Behavioral;

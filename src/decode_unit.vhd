----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.11.2023 18:32:04
-- Design Name: 
-- Module Name: decode_unit - Behavioral
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

entity decode_unit is
    Port ( B1       : in STD_LOGIC_VECTOR (7 downto 0);
           B2       : in STD_LOGIC_VECTOR (7 downto 0);
           B3       : in STD_LOGIC_VECTOR (7 downto 0);
           OPCODE   : out STD_LOGIC_VECTOR(4 downto 0);
           D        : out std_logic;
           W        : out std_logic;
           MODE     : out std_logic_vector (1 downto 0);
           REG      : out std_logic_vector (2 downto 0);
           RM       : out std_logic_vector (2 downto 0);
           IMD_ADDR : out std_logic_vector (15 downto 0)   
           );
end decode_unit;

architecture Behavioral of decode_unit is

signal OPCODE_inter:std_logic_vector (4 downto 0);
signal reg_inter:std_logic_vector(2 downto 0);
begin
OPCODE_inter <= B1(7 downto 3);
OPCODE <= OPCODE_inter;

process(OPCODE_inter,B1,B2,B3)
begin 
    -- Register Addressing
    if unsigned(OPCODE_INTER) < 2 then
        D <= '0';
        W <= '0';
        MODE <= "00";
        REG  <= B1 (2 downto 0);
        RM   <= B1 (2 downto 0);
        IMD_ADDR <= x"0000";  
        
    -- Register to/from Memory / Reg to Reg
    elsif unsigned(OPCODE_INTER) < 9 then 
        D <= B1(1);
        W <= B1(0);
        MODE <= B2(7 downto 6);
        REG  <= B2(5 downto 3);
        RM   <= B2(2 downto 0);
        IMD_ADDR <= x"0000";
        
    -- Jump
    elsif unsigned(OPCODE_INTER) < 12 then 
        D <= '0';
        W <= '0';
        MODE <= "00";
        REG  <= "000";
        RM   <= "000";
        IMD_ADDR <= B2 & B3; 
    
    -- Immediate Operand to Register
    elsif unsigned(OPCODE_INTER) < 20 then 
        D <= '0';
        W <= '0';
        MODE <= "00";
        REG  <= B1 (2 downto 0);
        RM   <= "000";
        IMD_ADDR <= B2 & B3;
    end if;
end process;

end Behavioral;

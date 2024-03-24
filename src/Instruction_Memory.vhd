----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2023 19:44:59
-- Design Name: 
-- Module Name: Instruction_Memory - Behavioral
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

entity Instruction_Memory is
    Port ( ADDR : in STD_LOGIC_VECTOR (8 downto 0);
           B1 : out STD_LOGIC_VECTOR (7 downto 0);
           B2 : out STD_LOGIC_VECTOR (7 downto 0);
           B3 : out STD_LOGIC_VECTOR (7 downto 0));
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

type rom_mem is array (0 to 511) of std_logic_vector(23 downto 0);
constant instr_mem : rom_mem := (
		"011100100000000000000000", -- (mov R2, 0000h) (0000h array lenght)
		"011100010000000000000001", -- (mov R1, 0001h) (0000h array location)
		--LOOP
		"000100000000000100000000", -- (mov R0, [R1])
		"100110000000000000000001", -- (test R0, 0001h)
		"010100000000000000001001", -- (jnz INC_COUNT(9))
		"000010100000000000000000", -- (dec R2)
		"010010000000000000001110", -- (jz END_PROGRAM(14)) 
		"000000010000000000000000", -- (inc R1)
		"010110000000000000000010", -- (jmp LOOP(2))
		-- INC_COUNT
		"000000110000000000000000", -- (inc R3) 
		"000010100000000000000000", -- (dec R2)
		"010010000000000000001110", -- (jz END_PROGRAM(14)) 
		"000000010000000000000000", -- (inc R1)
		"010110000000000000000010", -- (jmp LOOP(2))
		-- END_PROGRAM
		"000100001110001100000000", -- (mov R4, R3)
		"011101110000000000000000", -- (mov R7, [0000h])
		others => x"ffffff"
	);
begin

INST_MEM:process(ADDR)
begin
        B3 <= instr_mem(to_integer(unsigned(ADDR)))(7 downto 0);
        B2 <= instr_mem(to_integer(unsigned(ADDR)))(15 downto 8);
        B1 <= instr_mem(to_integer(unsigned(ADDR)))(23 downto 16);
end process;

end Behavioral;

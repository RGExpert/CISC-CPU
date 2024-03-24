----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2023 16:38:39
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
     Port (
            A       : in std_logic_vector(15 downto 0);
            B       : in std_logic_vector(15 downto 0);
            ALUop   : in std_logic_vector(2 downto 0);
            zero    : out std_logic;
            rez     : out std_logic_vector(15 downto 0));
end ALU;

architecture Behavioral of ALU is

signal inter: std_logic_vector(15 downto 0);

begin

zero <= '1' when inter = x"0000" else '0';
rez <= inter;
process(A,B,ALUop)
begin 
    case (ALUop) is 
    when "000" => -- inc 
            inter <=std_logic_vector(unsigned(A) + 1);
    when "001" => -- dec
            inter <= std_logic_vector(unsigned(A) - 1);
    when "010" => -- add 
            inter <= std_logic_vector(unsigned(A) + unsigned(B));
    when "011" => -- sub 
            inter <= std_logic_vector(unsigned(A) - unsigned(B));
    when "100" => -- and
            inter <= A and B;
    when "101" => -- or   
            inter <= A or B;
    when "110" => -- xor
            inter <= A xor B;
    when "111" => --pass A
            inter <= A;
    when others => null;
    end case;
end process;



end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2023 17:36:10
-- Design Name: 
-- Module Name: register_file - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_file is
    Port ( 
        clk : in Std_logic;
        din : in std_logic_vector (15 downto 0);
        dout1: out std_logic_vector (15 downto 0);
        dout2: out std_logic_vector (15 downto 0);
        RDaddr1: in std_logic_vector (2 downto 0 );
        RDaddr2: in std_logic_vector (2 downto 0);
        WRaddr : in std_logic_vector (2 downto 0);
        en:  in std_logic; 
        RD : in std_logic;
        WR : in std_logic_vector (1 downto 0);  
        dir : in std_logic
    );
end reg_file;

architecture Behavioral of reg_file is

type registerFile is array(0 to 7) of std_logic_vector(15 downto 0);
signal registers : registerFile:=(others => (others => '0')) ;

begin

REG_FILE_WR:process(clk)
begin
    if rising_edge(clk) then 
        if en = '1' then 
            case WR is 
                when "10" => -- write word
                    registers(to_integer(unsigned(WRaddr))) <= din;
                
                when "11" => --write byte
                    if dir = '0' then   -- Low Byte
                        registers(to_integer(unsigned(WRaddr)))(7 downto 0) <= din(7 downto 0);
                    else                -- High Byte
                        registers(to_integer(unsigned(WRaddr)))(15 downto 8) <= din(7 downto 0);
                    end if;
                    
                when others => null;
            end case ;
        end if;
    end if;
end process;

REG_FILE_READ: process(RD,RDaddr1,RDaddr2,en,registers)
begin 
    if en = '1' then 
        case RD is 
            when '0' => -- read word
                dout1 <= registers(to_integer(unsigned(RDaddr1)));
                dout2 <= registers(to_integer(unsigned(RDaddr2)));    
                        
            when '1' => -- read byte 
                if dir = '0' then   -- Low Byte
                    dout1 <= x"00" & registers(to_integer(unsigned(RDaddr1)))(7 downto 0);
                    dout2 <= x"00" & registers(to_integer(unsigned(RDaddr2)))(7 downto 0);
                else                -- High Byte
                    dout1 <= x"00" & registers(to_integer(unsigned(RDaddr1)))(15 downto 8);
                    dout2 <= x"00" & registers(to_integer(unsigned(RDaddr2)))(15 downto 8);
                end if;
            when others => null;
       end case;
   end if;
end process;

end Behavioral;

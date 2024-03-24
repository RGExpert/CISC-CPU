----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2023 20:54:22
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
    Port ( opcode : in STD_LOGIC_VECTOR (4 downto 0);
           clk: in std_logic;
           rst: in std_logic;
           mode : in STD_LOGIC_VECTOR (1 downto 0);
           D: in STD_LOGIC;
           zero: in STD_LOGIC;
           jmp : out STD_LOGIC;
           PCWr : out STD_LOGIC;
           IP_INC : out STD_LOGIC;
           MemR_W : out STD_LOGIC;
           RFDate : out STD_LOGIC;
           RegRD : out STD_LOGIC;
           RegWR : out STD_LOGIC_VECTOR(1 downto 0);
           ASrc : out STD_LOGIC;
           BSrc : out STD_LOGIC;
           AluOP : out STD_LOGIC_VECTOR(2 downto 0);
           bus_ctr: out STD_LOGIC_VECTOR(3 downto 0);
           AddrWr: out STD_LOGIC;
           flagWR:out STD_LOGIC
           );
end control_unit;

architecture Behavioral of control_unit is

type microprogram is array (0 to 31) of std_logic_vector (23 downto 0);
signal microcode: microprogram :=(
     0  => "111100000000010000000001",    -- INC
     1  => "111100000000010001000001",    -- DEC 
     2  => "111100000000010111000000",    -- MOV REG, REG / MOV REG,[REG]
     3  => "111100000000001010000101",    -- ADD REG,REG  
     4  => "111100000000001011000101",    -- SUB REG,REG
     5  => "111100000000001100000101",    -- AND REG,REG x
     6  => "111100000000001101000101",    -- OR REG, REG x
     7  => "111100000000001110000101",    -- XOR REG, REG x
     8  => "111110000000001100000101",    -- TEST REG, REG x
     9 =>  "111110000000000000000000",    -- JZ
     10 =>  "111110000000000000000000",   -- JNZ
     11 => "110010000000000000010110",    -- JUMP IMD
     12 => "111100000000001010000001",    -- ADD REG, IMD
     13 => "111100000000010111010100",    -- MOV REG, IMD
     14 => "111010000000000000010110",    -- MOV REG, [IMD]
     15 => "111100000000001011000101",    -- SUB REG, IMD
     16 => "111100000000001100000101",    -- AND REG, IMD x
     17 => "111100000000001101000101",    -- OR REG, IMD x
     18 => "111100000000001110000101",    -- XOR REG, IMD x
     19 => "111110000000001100000101",    -- TEST REG, IMD x
     24 => "111110000000010000010100",    -- GET_OPEERAND_A_IMD
     25 => "111111100000000000000000",    -- JUMP 
     26 => "111110000000010000100100",    -- GET_OPEERAND_A
     27 => "111010000000000000000110",    -- MOV REG, [REG]
     28 => "111110001000000000000000",    -- DATA_MEMORY_WR
     29 => "111110000001000000011100",    -- REG_FILE_WR_DM
     30 => "111110000001000000001100",    -- REG_FILE_WR_ALU
     31 => "100000110000000000011100",    -- IF
     others => "100000110000000000011100"
     --others => "10000_0110000000000"
   );

signal next_addr: std_logic_vector(4 downto 0);
signal state : integer range 0 to 31 := 31;
begin


next_addr <= microcode(state)(23 downto 19);
jmp     <= microcode(state)(18);
PCWr    <= microcode(state)(17);
IP_INC  <= microcode(state)(16);
MemR_W  <= microcode(state)(15);
RFDate  <= microcode(state)(14);
RegRD   <= microcode(state)(13);
RegWR   <= microcode(state)(12 downto 11);
ASrc    <= microcode(state)(10);
BSrc    <= microcode(state)(9);
ALUop   <= microcode(state)(8 downto 6);
bus_ctr <= microcode(state)(5 downto 2); 
AddrWr <= microcode(state)(1);
flagWr <= microcode(state)(0);

process(clk)
begin
    if rst ='1' then 
        state <= 31; -- IF
    elsif rising_edge(clk) then 
        if state = 31 
        and (to_integer(unsigned(opcode))<=2 
        or to_integer(unsigned(opcode)) = 11
        or to_integer(unsigned(opcode)) = 13
        or to_integer(unsigned(opcode)) = 14
        or to_integer(unsigned(opcode)) = 31)
        
        then     
            state <=to_integer(unsigned(opcode));
        else
            case to_integer(unsigned(opcode))is            
                when 2 => -- When MOV instruction
                    if mode = "11" then
                        state <= to_integer(unsigned(next_addr)); --MOV reg, reg
                    else 
                      
                        if state = 28 or state = 29 then 
                            state <= to_integer(unsigned(next_addr)); -- take next instruction
                        elsif state = 27 then 
                            if D ='1' then 
                                state <= 28; --data memory destination
                            else 
                                state <=29;  -- reg file destination
                            end if;
                        else 
                            state <= 27; 
                        end if;
                    end if;
                
                when 9 => -- jump zero
                    -- state 11 -> prepare jump
                    -- state 25 -> jump 
                    if state = 25 or state = 11 then 
                        state <= to_integer(unsigned(next_addr)); 
                    elsif state = 9 then
                        if zero ='1' then 
                            state <= 11;
                        else 
                            state <=31;
                        end if; 
                    else 
                        state <=9;
                    end if;
                
                when 10 => -- jump not zero
                    -- state 11 -> prepare jump
                    -- state 25 -> jump 
                    if state = 25 or state = 11 then 
                        state <= to_integer(unsigned(next_addr)); 
                    elsif state = 10 then
                        if zero ='0' then 
                            state <= 11;
                        else 
                            state <=31;
                        end if; 
                    else 
                        state <=10;
                    end if;  
             
                when others => --When other instructions
                    -- if reg to reg instruction
                   if to_integer(unsigned(opcode)) < 9 and to_integer(unsigned(opcode))>2 then 
                        if state = 26 then 
                            state <= to_integer(unsigned(opcode));
                        elsif state /= to_integer(unsigned(opcode)) and state /= 30  then 
                            state <= 26;
                        else 
                            state <= to_integer(unsigned(next_addr));
                        end if;      
                  -- if immediate to reg instruction
                   elsif to_integer(unsigned(opcode))=12 or (to_integer(unsigned(opcode)) < 20 and to_integer(unsigned(opcode))>14) then  
                        if state = 24 then 
                            state <= to_integer(unsigned(opcode));
                        elsif state /= to_integer(unsigned(opcode)) and state /= 30  then 
                            state <= 24;
                        else 
                            state <= to_integer(unsigned(next_addr));
                        end if; 
                   else 
                        state <= to_integer(unsigned(next_addr));
                   end if;  
            end case; 
        end if;
    end if;
end process;

end Behavioral;

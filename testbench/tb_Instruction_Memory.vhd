library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_Instruction_Memory is
end tb_Instruction_Memory;

architecture Behavioral of tb_Instruction_Memory is

    signal CLK : std_logic := '0';
    signal ADDR : std_logic_vector (8 downto 0) := (others => '0');
    signal B1, B2, B3 : std_logic_vector (7 downto 0);

    component Instruction_Memory is
        Port ( 
            ADDR : in STD_LOGIC_VECTOR (8 downto 0);
            CLK : in STD_LOGIC;
            B1 : out STD_LOGIC_VECTOR (7 downto 0);
            B2 : out STD_LOGIC_VECTOR (7 downto 0);
            B3 : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

begin

    uut: Instruction_Memory
        port map (
            ADDR => ADDR,
            CLK => CLK,
            B1 => B1,
            B2 => B2,
            B3 => B3
        );

    CLK_PROCESS: process
    begin
        while now < 100 ns loop
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    STIMULI_PROCESS: process
    begin
        ADDR <= "000000000";
        wait for 10 ns;
        ADDR <= "000000001";
        wait for 10 ns;
        ADDR <= "000000010";
        wait for 10 ns;
        ADDR <= "100000010";
        wait for 10 ns;
        
        wait;
    end process;

end Behavioral;

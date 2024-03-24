library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_Instruction_Pointer is
end tb_Instruction_Pointer;

architecture Behavioral of tb_Instruction_Pointer is

    signal CLK : std_logic := '0';
    signal ADDR_IN : std_logic_vector (15 downto 0) := (others => '0');
    signal RD, INC : std_logic := '0';
    signal ADDR_OUT : std_logic_vector (8 downto 0);

    component Instruction_Pointer is
        Port ( 
            ADDR_IN : in STD_LOGIC_VECTOR (15 downto 0);
            ADDR_OUT : out STD_LOGIC_VECTOR (8 downto 0);
            CLK: in STD_LOGIC;
            RD : in STD_LOGIC;
            INC : in STD_LOGIC
        );
    end component;

begin

    uut: Instruction_Pointer
        port map (
            ADDR_IN => ADDR_IN,
            ADDR_OUT => ADDR_OUT,
            CLK => CLK,
            RD => RD,
            INC => INC
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
        ADDR_IN <= x"00cd";
        inc <='1';
        wait for 10 ns;
        inc <='0';
        RD <= '1';
        wait;
    end process;

end Behavioral;

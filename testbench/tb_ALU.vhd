library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ALU is
end tb_ALU;

architecture testbench of tb_ALU is
    signal A, B, rez : std_logic_vector(15 downto 0);
    signal ALUop : std_logic_vector(2 downto 0);
    signal zero : std_logic;

    component ALU
        Port (
            A      : in std_logic_vector(15 downto 0);
            B      : in std_logic_vector(15 downto 0);
            ALUop  : in std_logic_vector(2 downto 0);
            zero   : out std_logic;
            rez    : out std_logic_vector(15 downto 0)
        );
    end component;

begin

    UUT: ALU 
        port map (
            A      => A,
            B      => B,
            ALUop  => ALUop,
            zero   => zero,
            rez    => rez
        );

    stimulus_process: process
    begin
        -- Test case 1
        A <= x"0002";
        B <= x"0001";
        ALUop <= "000";
        wait for 10 ns;

        -- Test case 2
        ALUop <= "001";
        wait for 10 ns;
        
        ALUop <= "010";
        wait for 10 ns;
        
        ALUop <= "011";
        wait for 10 ns;
        
        ALUop <= "100";
        wait for 10 ns;

        ALUop <= "101";
        wait for 10 ns;
        
        ALUop <= "110";
        wait for 10 ns;
        -- Add more test cases as needed

        wait;
    end process stimulus_process;

    -- Add assertions or print statements to check the results

end testbench;

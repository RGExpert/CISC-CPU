library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_test_env is
end entity tb_test_env;

architecture testbench of tb_test_env is
    -- Constants
    constant CLOCK_PERIOD : time := 10 ns;

    -- Signals
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal jmp : std_logic;
    signal IRWr : std_logic;
    signal IP_INC : std_logic;
    signal MemR_W : std_logic;
    signal RFDate : std_logic;
    signal RegRD : std_logic;
    signal RegWR : std_logic_vector(1 downto 0);
    signal ASrc : std_logic;
    signal BSrc : std_logic;
    signal AluOP : std_logic_vector(2 downto 0);

begin

    -- Instantiate the design under test (DUT)
    uut: entity work.test_env
        port map (
            clk => clk,
            rst => rst,
            jmp => jmp,
            IRWr => IRWr,
            IP_INC => IP_INC,
            MemR_W => MemR_W,
            RFDate => RFDate,
            RegRD => RegRD,
            RegWR => RegWR,
            ASrc => ASrc,
            BSrc => BSrc,
            AluOP => AluOP
        );

    -- Clock process
    clk_process: process
    begin
            clk <= '0';
            wait for CLOCK_PERIOD / 2;
            clk <= '1';
            wait for CLOCK_PERIOD / 2;
       
    end process clk_process;

    -- Stimulus process
    stimulus_process: process
    begin

        -- Add more stimulus if needed

        wait;
    end process stimulus_process;

end architecture testbench;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_reg_16bit is
end tb_reg_16bit;

architecture SIM of tb_reg_16bit is
    signal din_tb      : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal rst_tb      : STD_LOGIC := '0';
    signal wr_tb       : STD_LOGIC := '0';
    signal clk_tb      : STD_LOGIC := '0';
    signal dout_tb     : STD_LOGIC_VECTOR(15 downto 0);

    constant CLOCK_PERIOD : time := 10 ns; -- Adjust the clock period as needed

    component reg_16bit
        Port ( din : in STD_LOGIC_VECTOR (15 downto 0);
               rst : in STD_LOGIC;
               wr  : in STD_LOGIC;
               clk : in STD_LOGIC;
               dout : out STD_LOGIC_VECTOR (15 downto 0));
    end component;

begin

    -- Instantiate the reg_16bit module
    UUT: reg_16bit port map (
        din => din_tb,
        rst => rst_tb,
        wr  => wr_tb,
        clk => clk_tb,
        dout => dout_tb
    );

    -- Clock process
    clk_process: process
    begin
        clk_tb <= '0';
        wait for CLOCK_PERIOD / 2;
        clk_tb <= '1';
        wait for CLOCK_PERIOD / 2;
    end process;

    -- Stimulus process
    stim_process: process
    begin
        -- Initialize signals
        din_tb <= (others => '0');
        rst_tb <= '1';
        wr_tb <= '0';

        wait for CLOCK_PERIOD * 2;

        -- Deassert reset
        rst_tb <= '0';

        
        din_tb <= x"ABCD"; 
        wr_tb <= '1';
        wait for CLOCK_PERIOD * 2;
        
        wr_tb <= '0';
        din_tb <= x"1234";
        wait for CLOCK_PERIOD * 2;
        wr_tb <= '1';
        

        -- Add more test scenarios as needed

        wait;

    end process;

end SIM;

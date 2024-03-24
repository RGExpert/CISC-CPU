library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_data_memory is
end tb_data_memory;

architecture testbench of tb_data_memory is
    signal din_tb       : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal clk_tb       : std_logic := '0';
    signal dout_tb      : STD_LOGIC_VECTOR(15 downto 0);
    signal addr_tb      : STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
    signal R_W_tb       : STD_LOGIC := '0';
    
    constant clk_period : time := 10 ns;  -- Adjust as needed

    component data_memory
        Port ( 
            din : in STD_LOGIC_VECTOR(15 downto 0); 
            clk : in std_logic;
            dout : out STD_LOGIC_VECTOR (15 downto 0);
            addr : in STD_LOGIC_VECTOR (8 downto 0);
            R_W : in STD_LOGIC
        );
    end component;

begin
    -- Instantiate the data_memory module
    uut : data_memory
        port map (
            din => din_tb,
            clk => clk_tb,
            dout => dout_tb,
            addr => addr_tb,
            R_W => R_W_tb
        );

    -- Stimulus process
    stimulus_process: process
    begin
        -- Initialize inputs
        din_tb <= (others => '0');
        addr_tb <= (others => '0');
        R_W_tb <= '0';

        -- Write to memory
        R_W_tb <= '1';
        din_tb <= x"1234";  -- Example data
        addr_tb <= "000000001";      -- Example address
        wait for 20 ns;
        
        -- Read from memory
        R_W_tb <= '0';
        wait for 10 ns;
        
        wait;
    end process;

    -- Clock generation
    clk_process: process
    begin
        clk_tb <= not clk_tb;
        wait for clk_period / 2;
    end process;

end testbench;

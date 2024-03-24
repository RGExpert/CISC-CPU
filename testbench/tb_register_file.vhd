library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_register_file is
end tb_register_file;

architecture testbench of tb_register_file is

    signal clk : std_logic := '0';
    signal en : std_logic := '0';
    signal din : std_logic_vector(15 downto 0) := (others => '0');
    signal dout: std_logic_vector(15 downto 0);
    signal addr: std_logic_vector(2 downto 0) := "000";
    signal R_W : std_logic_vector(1 downto 0) := "00";
   
    signal dir : std_logic := '0';  -- Modify the initial value as needed

    -- Instantiate the register_file component
    component register_file is
    Port ( 
        clk : in Std_logic;
        din : in std_logic_vector (15 downto 0);
        dout: out std_logic_vector (15 downto 0);
        addr: in std_logic_vector (2 downto 0 );
        en:  in std_logic; 
        R_W : in std_logic_vector (1 downto 0);
        dir : in std_logic
    );
end component;

begin

    -- Instantiate the register_file component
    uut: register_file
        port map (
            clk => clk,
            din => din,
            en => en,
            dout => dout,
            addr => addr,
            R_W => R_W,
            dir => dir
        );

    -- Clock process
    clk_process: process
    begin
        while now < 1000 ns loop
            clk <= not clk;
            wait for 5 ns;
        end loop;
        wait;
    end process clk_process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Your test scenarios go here
        en <='1';
        wait for 10 ns;
        
        -- Example: Write operation
       
        din <= "1111000011110000";
        addr <= "001";
        R_W <= "10";  -- Write word
        dir <= '0';   -- Low byte
        wait for 10 ns;

        -- Example: Read operation
        addr <= "001";
        R_W <= "00";  -- Read word
        wait for 10 ns;
        
        R_W <= "11";
        dir <='0'; --Low Byte
        din <= x"00" & x"01";
        wait for 10 ns;
        
        
        R_W <= "00";
        wait for 10 ns;
        
        -- Add more test scenarios as needed

        wait;
    end process stimulus_process;

end testbench;

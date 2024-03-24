library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_decode_unit is
end tb_decode_unit;

architecture testbench of tb_decode_unit is
    signal B1_tb, B2_tb, B3_tb : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal OPCODE_tb : STD_LOGIC_VECTOR(4 downto 0);
    signal D_tb, W_tb : std_logic;
    signal MODE_tb : STD_LOGIC_VECTOR(1 downto 0);
    signal REG_tb, RM_tb : STD_LOGIC_VECTOR(2 downto 0);
    signal IMD_ADDR_tb : STD_LOGIC_VECTOR(15 downto 0);

    constant clk_period : time := 10 ns;  -- Adjust as needed

    component decode_unit
        Port ( 
            B1       : in STD_LOGIC_VECTOR (7 downto 0);
            B2       : in STD_LOGIC_VECTOR (7 downto 0);
            B3       : in STD_LOGIC_VECTOR (7 downto 0);
            OPCODE   : out STD_LOGIC_VECTOR(4 downto 0);
            D        : out std_logic;
            W        : out std_logic;
            MODE     : out std_logic_vector (1 downto 0);
            REG      : out std_logic_vector (2 downto 0);
            RM       : out std_logic_vector (2 downto 0);
            IMD_ADDR : out std_logic_vector (15 downto 0)   
        );
    end component;

    constant stimuli_duration : time := 20 ns;

begin
    -- Instantiate the decode_unit module
    uut : decode_unit
        port map (
            B1 => B1_tb,
            B2 => B2_tb,
            B3 => B3_tb,
            OPCODE => OPCODE_tb,
            D => D_tb,
            W => W_tb,
            MODE => MODE_tb,
            REG => REG_tb,
            RM => RM_tb,
            IMD_ADDR => IMD_ADDR_tb
        );

    -- Stimulus process
    stimulus_process: process
    begin
        -- Test case 1
        --reg addressing 
        B1_tb <= x"01";
        B2_tb <= x"FF";
        B3_tb <= x"FF";
        wait for stimuli_duration;
        
        --reg to/from mem / reg to reg
        B1_tb <= "01010001";
        B2_tb <= "00000001";
        B3_tb <= "10000000";
        wait for stimuli_duration;
        
        --jump
        B1_tb <= "01110011";
        B2_tb <= "00010001";
        B3_tb <= "10000001";
        wait for stimuli_duration;
        
        -- imd opperand
        B1_tb <= "10100011";
        B2_tb <= "00010001";
        B3_tb <= "10000001";
        wait for stimuli_duration;

        
        wait;
    end process;


end testbench;

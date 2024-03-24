-- testbench for control_unit

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_control_unit is
end tb_control_unit;

architecture TB_ARCH of tb_control_unit is

    signal opcode_tb : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal clk_tb    : STD_LOGIC := '0';
    signal rst_tb    : STD_LOGIC := '0';
    signal mode_tb   : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal jmp_tb    : STD_LOGIC;
    signal PCWr_tb   : STD_LOGIC;
    signal IP_INC_tb : STD_LOGIC;
    signal MemR_W_tb : STD_LOGIC;
    signal RFDate_tb : STD_LOGIC;
    signal RegRD_tb  : STD_LOGIC;
    signal RegWR_tb  : STD_LOGIC_VECTOR(1 downto 0);
    signal ASrc_tb   : STD_LOGIC;
    signal BSrc_tb   : STD_LOGIC;
    signal AluOP_tb  : STD_LOGIC_VECTOR(2 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- Adjust as needed

    component control_unit
        Port ( 
            opcode : in STD_LOGIC_VECTOR (4 downto 0);
            clk    : in STD_LOGIC;
            rst    : in STD_LOGIC;
            mode   : in STD_LOGIC_VECTOR (1 downto 0);
            jmp    : out STD_LOGIC;
            PCWr   : out STD_LOGIC;
            IP_INC : out STD_LOGIC;
            MemR_W : out STD_LOGIC;
            RFDate : out STD_LOGIC;
            RegRD  : out STD_LOGIC;
            RegWR  : out STD_LOGIC_VECTOR(1 downto 0);
            ASrc   : out STD_LOGIC;
            BSrc   : out STD_LOGIC;
            AluOP  : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    begin
    UUT: control_unit port map (
        opcode => opcode_tb,
        clk    => clk_tb,
        rst    => rst_tb,
        mode   => mode_tb,
        jmp    => jmp_tb,
        PCWr   => PCWr_tb,
        IP_INC => IP_INC_tb,
        MemR_W => MemR_W_tb,
        RFDate => RFDate_tb,
        RegRD  => RegRD_tb,
        RegWR  => RegWR_tb,
        ASrc   => ASrc_tb,
        BSrc   => BSrc_tb,
        AluOP  => AluOP_tb
    );

    CLK_PROCESS: process
    begin
        while now < 1000 ns loop
            clk_tb <= not clk_tb;
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    STIMULUS_PROCESS: process
    begin
        
        opcode_tb <= "00000";
        mode_tb   <= "00";
        wait for CLK_PERIOD * 5; 

 

        

        wait;
    end process;

end TB_ARCH;

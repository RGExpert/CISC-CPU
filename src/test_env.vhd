----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2023 20:32:47
-- Design Name: 
-- Module Name: test_env - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
        Port (  
            clk : in std_logic;
            rst: in std_logic;
            jmp : out STD_LOGIC;
            IRWr : out STD_LOGIC;
            IP_INC : out STD_LOGIC;
            MemR_W : out STD_LOGIC;
            RFDate : out STD_LOGIC;
            RegRD : out STD_LOGIC;
            RegWR : out STD_LOGIC_VECTOR(1 downto 0);
            ASrc : out STD_LOGIC;
            BSrc : out STD_LOGIC;
            AluOP : out STD_LOGIC_VECTOR(2 downto 0);
            bus_ctr:out STD_LOGIC_VECTOR(3 downto 0);
            AddrWr:out STD_LOGIC;
            flagWR:out STD_LOGIC
            );
end test_env;

architecture Behavioral of test_env is

component Instruction_Memory is
    Port ( ADDR : in STD_LOGIC_VECTOR (8 downto 0);
           B1   : out STD_LOGIC_VECTOR (7 downto 0);
           B2   : out STD_LOGIC_VECTOR (7 downto 0);
           B3   : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component Instruction_Pointer is
    Port ( ADDR_IN  : in STD_LOGIC_VECTOR (15 downto 0);
           ADDR_OUT : out STD_LOGIC_VECTOR (8 downto 0);
           CLK      : in STD_LOGIC;
           RD       : in STD_LOGIC;
           INC      : in STD_LOGIC);
end component;

component reg_generic is
    generic (
        DATA_WIDTH : integer := 8
    );
    Port (
        din  : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        rst  : in STD_LOGIC;
        wr   : in std_logic;
        clk  : in STD_LOGIC;
        dout : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end component;

component decode_unit is
    Port ( B1       : in STD_LOGIC_VECTOR (7 downto 0);
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

component control_unit is
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
end component;

component reg_file is
    Port ( 
        clk : in Std_logic;
        din : in std_logic_vector (15 downto 0);
        dout1: out std_logic_vector (15 downto 0);
        dout2: out std_logic_vector (15 downto 0);
        RDaddr1: in std_logic_vector (2 downto 0 );
        RDaddr2: in std_logic_vector (2 downto 0);
        WRaddr : in std_logic_vector (2 downto 0);
        en:  in std_logic; 
        RD : in std_logic;
        WR : in std_logic_vector (1 downto 0);  
        dir : in std_logic
    );
end component;

component ALU is
     Port (
            A       : in std_logic_vector(15 downto 0);
            B       : in std_logic_vector(15 downto 0);
            ALUop   : in std_logic_vector(2 downto 0);
            zero    : out std_logic;
            rez     : out std_logic_vector(15 downto 0));
end component;

component data_memory is
    Port ( 
        din : in STD_LOGIC_VECTOR(15 downto 0); 
        clk : in std_logic;
        dout : out STD_LOGIC_VECTOR (15 downto 0);
        addr : in STD_LOGIC_VECTOR (8 downto 0);
        WR : in STD_LOGIC);
end component;

---------- IP signals ------------------------
signal ADDR_IN  : STD_LOGIC_VECTOR (15 downto 0):=(others => '0');
signal ADDR_OUT : STD_LOGIC_VECTOR (8 downto 0);
----------- PC signals ------------------------
signal instruction_reg : STD_LOGIC_VECTOR (23 downto 0);
----------- IM signals ------------------------
signal B1 : std_logic_vector(7 downto 0);
signal B2 : std_logic_vector(7 downto 0);
signal B3 : std_logic_vector(7 downto 0);
----------- Decode unit signals ---------------
signal OPCODE   : STD_LOGIC_VECTOR(4 downto 0);
signal D        : std_logic;
signal W        : std_logic;
signal MODE     : std_logic_vector (1 downto 0);
signal REG      : std_logic_vector (2 downto 0);
signal RM       : std_logic_vector (2 downto 0);
signal IMD_ADDR : std_logic_vector (15 downto 0); 

signal B1_inter : std_logic_vector (7 downto 0);
signal B2_inter : std_logic_vector (7 downto 0);
signal B3_inter : std_logic_vector (7 downto 0);

----------- Reg file signals -------------------
signal RF_DIN : std_logic_vector (15 downto 0);
signal RF_DOUT1 : std_logic_vector (15 downto 0);
signal RF_DOUT2 : std_logic_vector (15 downto 0);
signal RF_WR_ADDR : std_logic_vector (2 downto 0);
signal RF_RD_ADDR1 : std_logic_vector (2 downto 0);
signal RF_RD_ADDR2 : std_logic_vector (2 downto 0);

----------- Alu signals ------------------------
signal aluREZ: std_logic_vector(15 downto 0);
signal aluREZ_reg: std_logic_vector(15 downto 0);
signal aluA: std_logic_vector(15 downto 0);
signal aluB: std_logic_vector(15 downto 0);
signal zero: std_logic;
signal A_reg: std_logic_vector(15 downto 0);
signal B_reg: std_logic_vector(15 downto 0);

----------- Data Memory signals ---------------
signal DM_dout: std_logic_vector(15 downto 0);

----------- CU signals ------------------------
signal not_clk      : STD_LOGIC;
signal jmp_inter    : STD_LOGIC;
signal IRWr_inter   : STD_LOGIC;
signal IP_INC_inter : STD_LOGIC;
signal MemR_W_inter : STD_LOGIC;
signal RFDate_inter : STD_LOGIC;
signal RegRD_inter  : STD_LOGIC;
signal RegWR_inter  : STD_LOGIC_VECTOR(1 downto 0);
signal ASrc_inter   : STD_LOGIC;
signal BSrc_inter   : STD_LOGIC;
signal AluOP_inter  : STD_LOGIC_VECTOR(2 downto 0);
signal bus_ctr_inter  : STD_LOGIC_VECTOR(3 downto 0);
signal AddrWr_inter   : STD_LOGIC;
signal flagWR_inter : STD_LOGIC;

--------------- MSC -----------------------------
signal instruction: STD_LOGIC_VECTOR(23 downto 0);
signal aux: std_logic_vector(2 downto 0);
signal D_ext:std_logic_vector(3 downto 0):="0000";
--------------- BUS -----------------------------
signal address_bus: STD_LOGIC_VECTOR(15 downto 0);
signal data_bus: STD_LOGIC_VECTOR(15 downto 0);
signal bus_sel: STD_LOGIC_VECTOR(3 downto 0);
signal zero_flag: STD_LOGIC;

begin

not_clk<=not clk;

D_ext <= "000" &  (not D);
bus_sel <= bus_ctr_inter OR D_ext;

BUS_CONTROL:process(bus_sel,RF_DOUT1,RF_DOUT2,DM_dout,ALUrez,IMD_ADDR)
begin
    case bus_sel is 
        when "0000" => data_bus <= RF_DOUT1;
        when "0001" => data_bus <= RF_DOUT2;
        when "1001" => data_bus <= RF_DOUT1;
        when "0111" => data_bus <= DM_dout;
        when "0011" => data_bus <= ALUrez_reg;
        when "0101" => data_bus <= IMD_ADDR;
        when others => data_bus <= x"FFFF";
    end case; 
end process;

IP:Instruction_Pointer 
    port map (
        clk => clk,
        ADDR_IN => ADDR_IN,
        RD => jmp_inter,
        INC => IP_INC_inter,
        ADDR_OUT => ADDR_OUT
    );
                 
    
IM: instruction_memory
    port map (
        ADDR => ADDR_OUT,
        B1 => B1,
        B2 => B2,
        B3 => B3    
    );

instruction <= B1 & B2 & B3;

IR:reg_generic 
    generic map (
        DATA_WIDTH => 24
    )
    port map (
        clk => clk,
        din => instruction,
        rst => rst,
        wr => IRWr_inter,
        dout => instruction_reg
    );

B1_inter <= instruction_reg(23 downto 16);
B2_inter <= instruction_reg(15 downto 8);
B3_inter <= instruction_reg(7 downto 0);
DU: decode_unit 
    port map(
        B1 => B1_inter,
        B2 => B2_inter,
        B3 => B3_inter,
        OPCODE => OPCODE,
        D => D,
        W => W,
        MODE => MODE,
        REG => reg,
        RM => RM,
        IMD_ADDR => IMD_ADDR
    );

RF: reg_file
    port map(
        clk => clk,
        din => rf_din,
        dout1 => rf_dout1,
        dout2 => rf_dout2,
        RDaddr1 => REG,
        RDaddr2 => RM,
        WRaddr  => rf_wr_addr,
        en => '1',
        rd => RegRD_inter,
        wr => RegWR_inter,
        dir => W
    );       
RF_DATA_IN: rf_din <= Data_bus;
RF_WR_ADDRESS: rf_wr_addr <= Reg when D = '0' else RM;

ALUI: ALU 
    port map (
        A => aluA,
        B => aluB,
        AluOP => AluOP_inter,
        zero => zero,
        rez => AluRez
    );

FLAG_REG:process(not_clk,zero,flagWR_inter)
begin
    if rising_edge(not_clk) then
        if flagWR_inter = '1' then  
            zero_flag <= zero;
        end if;
    end if;
end process;

REG_AluRez:reg_generic 
    generic map (
        DATA_WIDTH => 16
    )
    port map (
        clk => not_clk,
        din => AluREz,
        rst => rst,
        wr => '1',
        dout => aluREZ_reg
    );

REG_A:reg_generic 
    generic map (
        DATA_WIDTH => 16
    )
    port map (
        clk => clk,
        din => Data_bus,
        rst => rst,
        wr => ASrc_inter,
        dout => A_reg
    );

REG_B:reg_generic 
    generic map (
        DATA_WIDTH => 16
    )
    port map (
        clk => clk,
        din => Data_bus,
        rst => rst,
        wr => BSrc_inter,
        dout => B_reg
    );
     
ALU_A_INPUT: aluA <= A_reg;
ALU_B_INPUT: aluB <= B_reg;

ADDR_REG:reg_generic 
    generic map (
        DATA_WIDTH => 16
    )
    port map (
        clk => clk,
        din => data_bus,
        rst => rst,
        wr => AddrWr_inter,
        dout => ADDR_IN
    );
    
DM:data_memory
    port map(
        din => data_bus,
        clk => clk,
        dout => DM_dout,
        addr => ADDR_IN(8 downto 0),
        WR => MemR_W_inter
    );

    
CU: control_unit 
    port map(
        OPCODE => OPCODE,
        MODE => MODE,
        clk => not_clk,
        rst => rst,
        D => D,
        zero => zero_flag,
        jmp => jmp_inter,
        PCWr => IRWr_inter,
        IP_INC => IP_INC_inter,
        MemR_W => MemR_W_inter,
        RFDate => RFDate_inter,
        RegRD => RegRD_inter,
        RegWR => RegWR_inter,
        ASrc => ASrc_inter,
        BSrc => BSrc_inter,
        AluOp => AluOP_inter,
        bus_ctr => bus_ctr_inter,
        AddrWr => AddrWr_inter,
        flagWR => flagWR_inter
    );

jmp <= jmp_inter;
IRWr <= IRWr_inter;
IP_INC <= IP_INC_inter;
MemR_W <= MemR_W_inter;
RFDate <= RFDate_inter;
RegRD <= RegRD_inter;
RegWR <= RegWR_inter;
ASrc <= ASrc_inter;
BSrc <= BSrc_inter;
AluOp <= ALuOP_inter;
bus_ctr <= bus_ctr_inter;
AddrWr <= AddrWr_inter;
flagWR <= flagWR_inter;

end Behavioral;

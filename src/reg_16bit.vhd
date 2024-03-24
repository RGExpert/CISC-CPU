library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_generic is
    generic (
        DATA_WIDTH : integer := 16
    );
    Port (
        din  : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        rst  : in STD_LOGIC;
        wr   : in std_logic;
        clk  : in STD_LOGIC;
        dout : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end reg_generic;

architecture Behavioral of reg_generic is
    signal inter : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
begin
    dout <= inter;

    process(clk, rst)
    begin
        if rst = '1' then
            inter <= (others => '0');
        elsif rising_edge(clk) then
            if wr = '1' then
                inter <= din;
            end if;
        end if;
    end process;

end Behavioral;

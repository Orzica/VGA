library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Clock_Domain is
--  Generic ( );
--  Port ( );
    port(
        clk_in  : in  std_logic;
        clk_out : out std_logic
    );
end Clock_Domain;

architecture rtl of Clock_Domain is

    -- Declarative zone of VHDL
    
    -- Component IP instantiation
    component Clk_Divider
        port(
            clk_in  : in  std_logic;
            clk_out : out std_logic        
        );
    end component;

begin

    MMCM : Clk_Divider
        port map(
            clk_in  => clk_in,
            clk_out => clk_out
        );

end rtl;

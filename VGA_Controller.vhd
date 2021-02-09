library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_Controller is
--  Generic ( );
--  Port ( );
    port(
        -- Inputs
        clk   : in std_logic;
        -- Outputs       
        rgb   : out std_logic_vector(11 downto 0);
        HSync : out std_logic;
        VSync : out std_logic
    );
end VGA_Controller;

architecture rtl of VGA_Controller is

    -- Declarative zone of VHDL
    signal clock : std_logic := '0';  -- Wire between modules
    
    -- Component declaration
    component Clock_Domain is
        port(
            clk_in  : in  std_logic;
            clk_out : out std_logic
        );
    end component;
    
    component VGA_Sync is
        --  Generic ( );
        generic(
            Total_Cols  : integer := 800;
            Total_Rows  : integer := 525;
            Active_Cols : integer := 640;
            Active_Rows : integer := 480
        );
        --  Port ( );
        port(
            -- Inputs
            clk   : in std_logic;
            -- Outputs
            rgb   : out std_logic_vector(11 downto 0);
            HSync : out std_logic;
            VSync : out std_logic
            
        );    
    end component;

begin

    VGA_Clock : Clock_Domain
    port map(
        clk_in => clk,
        clk_out => clock
    );
    
    VGA_Ctrl : VGA_Sync
        generic map(
            Total_Cols  => 800,
            Total_Rows  => 525,
            Active_Cols => 640,
            Active_Rows => 480
        )
        port map(
            clk => clock,
            rgb   => rgb,
            HSync => HSync,
            VSync => VSync
        );

end rtl;

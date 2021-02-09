library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.ALL;

--                       General timing
--          Screen refresh rate |   60 Hz
--          Vertical refresh    |   31.46875 kHz
--          Pixel freq          |   25.175 MHz

--                  Horizontal timing (line)
--          Scanline part |	Pixels | Time [µs]
--          Visible area  |  640   |  25.422045680238
--          Front porch	  |   16   |  0.63555114200596
--          Sync pulse	  |   96   |  3.8133068520357
--          Back porch	  |   48   |  1.9066534260179
--          Whole line	  |  800   |  31.777557100298

--                  Vertical timing (frame)
--          Scanline part |	Pixels | Time [µs]
--          Visible area  |  480   |  15.253227408143
--          Front porch	  |   10   |  0.31777557100298
--          Sync pulse	  |   2    |  0.063555114200596
--          Back porch	  |   33   |  1.0486593843098
--          Whole line	  |  525   |  16.683217477656

entity VGA_Sync is
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
end VGA_Sync;

-- Bit    7  6  5  4  3  2  1  0
-- Data   R  R  R  G  G  G  B  B

architecture rtl of VGA_Sync is

    -- Declarative zone of VHDL
    signal Rows_counter : integer range 0 to Total_Rows - 1 := 0;
    signal Cols_counter : integer range 0 to Total_Cols - 1 := 0;
    
    signal Row_index : std_logic_vector(9 downto 0) := (others => '0');
    signal Col_index : std_logic_vector(9 downto 0) := (others => '0');
    
    -- Horizontal
    constant Front_HPorch : integer := 16;
    constant Back_HPorch  : integer := 48;
    
    -- Vertical
    constant Front_VPorch : integer := 10;
    constant Back_Vporch  : integer := 33;
    
begin
    
    rgb(11 downto 0) <= "111100000000" when  Cols_counter >= 0   and Cols_counter <= 319  and Rows_counter >= 0   and Rows_counter <= 239 else -- red
                        "000011110000" when  Cols_counter >= 0   and Cols_counter <= 319  and Rows_counter >= 240  and Rows_counter < 480 else -- green
                        "000000001111" when  Cols_counter >= 320  and Cols_counter < 660  and Rows_counter >= 0   and Rows_counter <= 239 else -- blue
                        "111100001111" when  Cols_counter >= 320  and Cols_counter < 660  and Rows_counter >= 240  and Rows_counter < 480 else -- purple
                        (others => '1');
   
   -- Out signal assigment
   HSync <= '1' when Cols_counter < Active_Cols + Front_HPorch or Cols_counter > Total_Cols - Back_HPorch - 1  else '0'; -- Add Front and Back porch for image to be centered
   VSync <= '1' when Rows_counter < Active_Rows + Front_VPorch or Rows_counter > Total_Rows - Back_Vporch - 1  else '0'; -- Add Front and Back porch for image to be centered

   Sync_proc : process(clk) is
   begin
    if rising_edge(clk) then
        if Cols_counter = Total_Cols - 1 then
            if Rows_counter = Total_Rows - 1 then
                Rows_counter <= 0;
            else
                Rows_counter <= Rows_counter + 1;
            end if;
            Cols_counter <= 0;
        else
            Cols_counter <= Cols_counter + 1;
        end if;
    end if;
   end process Sync_proc;
   
   Row_index <= std_logic_vector(TO_UNSIGNED(Rows_counter, Row_index'length));
   Col_index <= std_logic_vector(TO_UNSIGNED(Cols_counter, Col_index'length));


end rtl;

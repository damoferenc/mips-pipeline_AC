----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2021 11:37:49 AM
-- Design Name: 
-- Module Name: id - Behavioral
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

entity id is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           writeAddr : in STD_LOGIC_VECTOR(2 downto 0);
           nextAddr : in STD_LOGIC_VECTOR(15 downto 0);
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC;
           jumpAddr : out STD_LOGIC_VECTOR);
end id;

architecture Behavioral of id is

component RF is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           reg_write : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;


begin

c1: RF port map(clk, en, RegWrite,Instr(12 downto 10), Instr(9 downto 7), writeAddr, WD, RD1, RD2);



extension_unit: process(ExtOp)
begin
    if ExtOp = '0' or Instr(6) = '0' then
        Ext_Imm <= "000000000" & Instr(6 downto 0);
    else
        Ext_imm <= "111111111" & Instr(6 downto 0);
    end if;
end process;

func <= Instr(2 downto 0);
sa <= Instr(3);

jumpAddr <= nextAddr(15 downto 13) & Instr(12 downto 0);

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2021 06:01:27 PM
-- Design Name: 
-- Module Name: wb - Behavioral
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

entity wb is
    Port ( MemtoReg : in STD_LOGIC;
           ALUResOut : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : in STD_LOGIC_VECTOR (15 downto 0);
           SLTIU : in STD_LOGIC;
           greaterOrEqual : in STD_LOGIC;
           WD : out STD_LOGIC_VECTOR (15 downto 0));
end wb;

architecture Behavioral of wb is

signal inter : STD_LOGIC_VECTOR(15 downto 0);

begin



process(MemtoReg)
begin
    if MemtoReg = '0' then
        inter <= ALUResOut;
    else 
        inter <= MemData;
    end if;
end process;

process(SLTIU, greaterOrEqual)
begin
    if SLTIU = '0' then
        WD <= inter;
    elsif greaterOrEqual = '0' then
        WD <= x"0001";
    else
        WD <= x"0000";
    end if;
end process;


end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2021 10:40:36 AM
-- Design Name: 
-- Module Name: mpg - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mpg is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end mpg;

architecture Behavioral of mpg is

signal q0,q1,q2,en : STD_LOGIC;
signal semnal : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000"; 

begin

process(clk)
    begin
        if rising_edge(clk) then
            semnal <= semnal + 1;
        end if;
end process;

process(semnal)
    begin
        if semnal = "1111111111111111" then
            en <= '1';
        else
            en <= '0';
        end if;
end process;

process(en, clk)
    begin
    if rising_edge(clk) then
        if en = '1' then
            q0 <= btn;
        end if;
    end if;
end process;

process(clk)
    begin
    if rising_edge(clk) then
        q1 <= q0;
        q2 <= q1;
    end if;
end process;

enable <= q1 and not q2;

end Behavioral;
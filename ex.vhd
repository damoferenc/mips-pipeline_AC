----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2021 11:22:18 AM
-- Design Name: 
-- Module Name: ex - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ex is
    Port ( nextAddress : in STD_LOGIC_VECTOR(15 downto 0);
           rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           Instr : in STD_LOGIC_VECTOR(15 downto 0);
           RegDst : in STD_LOGIC;
           Zero : out STD_LOGIC;
           greaterOrEqual : out STD_LOGIC;
           less : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           branchAddress : out STD_LOGIC_VECTOR(15 downto 0);
           wa : out STD_LOGIC_VECTOR(2 downto 0));
end ex;

architecture Behavioral of ex is

signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0);

signal inter : STD_LOGIC_VECTOR(15 downto 0);
signal result : STD_LOGIC_VECTOR(15 downto 0);
signal multiple : STD_LOGIC_VECTOR(31 downto 0);


begin

process(ALUOp)
begin
    case ALUOp is
         when "00" => ALUCtrl <= func;
         when "01" => ALUCtrl <= "000"; --addition
         when "10" => ALUCtrl <= "001"; --substraction
         when others => ALUCtrl <= "000";
    end case;
end process;
    
process(ALUCtrl)
begin
    case ALUCtrl is
        when "000" =>
            result <= rd1 + inter;
        when "001" =>
            result <= rd1 - inter;
        when "010" =>
            result <= rd1(14 downto 0) & '0';
        when "011" =>
            result <= '0' & rd1(15 downto 1);
        when "100" =>
            result <= rd1 and inter;
        when "101" =>
            result <= rd1 or inter;
        when "110" =>
            result <= rd1 xor inter;
        when "111" =>
            multiple <= rd1 * inter;
            result <= multiple(15 downto 0);
    end case;
end process;
        
mux: process(ALUSrc) 
begin
    if ALUSrc = '0' then
        inter <= rd2;
    else 
        inter <= Ext_Imm;
    end if;
end process;

ALURes <= result;

process(result)
begin
    if result = x"0000" then
        zero <= '1';
    else
        zero <= '0';
    end if;
    if result(15) = '1' then
        less <= '1';
        greaterOrEqual <= '0';
    else
        less <= '0';
        greaterOrEqual <= '1';
    end if;
end process;

branchAddress <= nextAddress + Ext_Imm;
    
    
mux2: process(RegDst)
begin
    if RegDst = '1' then 
        wa <= Instr(6 downto 4);
    else
        wa <= Instr(9 downto 7);
    end if;
end process;

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2021 11:02:32 PM
-- Design Name: 
-- Module Name: uc - Behavioral
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

entity uc is
    Port ( opcode : in STD_LOGIC_VECTOR (2 downto 0);
       RegDst : out STD_LOGIC;
       ExtOp : out STD_LOGIC;
       ALUSrc : out STD_LOGIC;
       BranchOnEqual : out STD_LOGIC;
       BranchOnGreaterOrEqualToZero : out STD_LOGIC;
       Jump : out STD_LOGIC;
       ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
       MemWrite : out STD_LOGIC;
       MemtoReg : out STD_LOGIC;
       SLTIU : out STD_LOGIC;
       RegWrite : out STD_LOGIC);
end uc;

architecture Behavioral of uc is

begin

uc: process(opcode)
begin
           RegDst <= '0';
           ExtOp <= '0';
           ALUSrc <= '0';
           BranchOnEqual <= '0';
           BranchOnGreaterOrEqualToZero <= '0';
           Jump <= '0';
           ALUOp <= "00";
           MemWrite <= '0';
           MemtoReg <= '0';
           RegWrite <= '0';
           SLTIU <= '0';
case opcode is
    when "000" => -- R
        RegDst <= '1';
        RegWrite <= '1';
    when "001" => --addi
        RegWrite <= '1';
        ALUSrc <= '1';
        ExtOp <= '1';
        ALUOp <= "01";
    when "010" => --lw
        RegWrite <= '1';
        ALUSrc <= '1';
        ExtOp <= '1';
        ALUOp <= "01";
        MemtoReg <= '1';
    when "011" => --sw
        ALUSrc <= '1';
        ExtOp <= '1';
        ALUOp <= "01";
        MemWrite <= '1';
    when "100" => --beq
        ExtOp <= '1';
        BranchOnEqual <= '1';
        ALUOp <= "10";
    when "101" => --bgez
        ExtOp <= '1';
        BranchOnGreaterOrEqualToZero <= '1';
        ALUOp <= "10";
    when "110" => --sltiu
        RegWrite <= '1';
        ALUSrc <= '1';
        ExtOp <= '1';
        SLTIU <= '1';
        ALUOp <= "10";
    when others => --j
        Jump <= '1';
end case;
end process;



end Behavioral;

library IEEE;
use IEEE.std_logic_1164.all;

entity barrelShifter is
generic(
			DATA_WIDTH:	integer:=32;
			SEL_WIDTH:	integer:=5
		);
port(
		input:	in std_logic_vector(DATA_WIDTH-1 downto 0);
		arith:	in std_logic;
		rightShift: in std_logic;
		output:	out std_logic_vector(DATA_WIDTH-1 downto 0);
		sel:	in std_logic_vector(SEL_WIDTH-1 downto 0)
	);

end barrelShifter;

architecture behavorial of barrelShifter is

signal lvl0:	std_logic_vector(DATA_WIDTH-1 downto 0);
signal lvl1:	std_logic_vector(DATA_WIDTH-1 downto 0);
signal lvl2:	std_logic_vector(DATA_WIDTH-1 downto 0);
signal lvl3:	std_logic_vector(DATA_WIDTH-1 downto 0);
signal lvl4:	std_logic_vector(DATA_WIDTH-1 downto 0);

begin

process(input, sel, rightShift, arith)

begin
if(rightShift='0') then
		if(sel(0)='0') then
			lvl0	<=	input;
		else
			lvl0(0) <= '0';
			for i in 1 to input'HIGH LOOP
				lvl0(i)	<=	input(i-1);
			end loop;
		end if;
else
	if(sel(0)='0') then
		lvl0	<=	input;
	else
		lvl0(31) <= arith and input(31);
		for i in 1 to input'HIGH LOOP
			lvl0(i-1)	<=	input(i);
		end loop;
	end if;
end if;

end process;

process(lvl0, sel, rightShift, arith)

begin
if(rightShift='0') then
		if(sel(1)='0') then
			lvl1	<=	lvl0;
		else
			lvl1(0) <= '0';
			lvl1(1)	<= '0';
		for i in 2 to lvl0'HIGH LOOP
			lvl1(i)	<=	lvl0(i-2);
		end loop;
		end if;
else
	if(sel(1)='0') then
		lvl1	<=	lvl0;
	else
		lvl1(31) <= arith and lvl0(31);
		lvl1(30) <= arith and lvl0(31);
		for i in 2 to input'HIGH LOOP
			lvl1(i-2)	<=	lvl0(i);
		end loop;
	end if;
end if;
end process;

process(lvl1, sel, rightShift, arith)

begin
if(rightShift='0') then
		if(sel(2)='0') then
			lvl2	<=	lvl1;
		else
			lvl2(0) <= '0';
			lvl2(1)	<= '0';
			lvl2(2) <= '0';
			lvl2(3)	<= '0';
		for i in 4 to lvl1'HIGH LOOP
			lvl2(i)	<=	lvl1(i-4);
		end loop;
		end if;
else
	if(sel(2)='0') then
		lvl2	<=	lvl1;
	else
		lvl2(31) <= arith and lvl1(31);
		lvl2(30) <= arith and lvl1(31);
		lvl2(29) <= arith and lvl1(31);
		lvl2(28) <= arith and lvl1(31);
		for i in 4 to lvl1'HIGH LOOP
			lvl2(i-4)	<=	lvl1(i);
		end loop;
	end if;
end if;
end process;

process(lvl2, sel, rightShift, arith)

begin
if(rightShift='0') then
	if(sel(3)='0') then
		lvl3	<=	lvl2;
	else
		lvl3(0) <= '0';
		lvl3(1)	<= '0';
		lvl3(2) <= '0';
		lvl3(3)	<= '0';
		lvl3(4) <= '0';
		lvl3(5)	<= '0';
		lvl3(6) <= '0';
		lvl3(7)	<= '0';
		for i in 8 to lvl2'HIGH LOOP
			lvl3(i)	<=	lvl2(i-8);
		end loop;
	end if;
else
	if(sel(3)='0') then
		lvl3	<=	lvl2;
	else
		lvl3(31) <= arith and lvl2(31);
		lvl3(30) <= arith and lvl2(31);
		lvl3(29) <= arith and lvl2(31);
		lvl3(28) <= arith and lvl2(31);
		lvl3(27) <= arith and lvl2(31);
		lvl3(26) <= arith and lvl2(31);
		lvl3(25) <= arith and lvl2(31);
		lvl3(24) <= arith and lvl2(31);
		for i in 8 to lvl2'HIGH LOOP
			lvl3(i-8)	<=	lvl2(i);
		end loop;
	end if;
end if;
end process;

process(lvl3, sel, rightShift, arith)

begin
if(rightShift='0') then
	if(sel(4)='0') then
		lvl4	<=	lvl3;
	else
		lvl4(0) <= '0';
		lvl4(1)	<= '0';
		lvl4(2) <= '0';
		lvl4(3)	<= '0';
		lvl4(4) <= '0';
		lvl4(5)	<= '0';
		lvl4(6) <= '0';
		lvl4(7)	<= '0';
		lvl4(8) <= '0';
		lvl4(9)	<= '0';
		lvl4(10) <= '0';
		lvl4(11)	<= '0';
		lvl4(12) <= '0';
		lvl4(13)	<= '0';
		lvl4(14) <= '0';
		lvl4(15)	<= '0';
	for i in 16 to lvl3'HIGH LOOP
		lvl4(i)	<=	lvl3(i-16);
	end loop;
	end if;
else
	if(sel(4)='0') then
		lvl4	<=	lvl3;
	else
		lvl4(31) <= arith and lvl3(31);
		lvl4(30) <= arith and lvl3(31);
		lvl4(29) <= arith and lvl3(31);
		lvl4(28) <= arith and lvl3(31);
		lvl4(27) <= arith and lvl3(31);
		lvl4(26) <= arith and lvl3(31);
		lvl4(25) <= arith and lvl3(31);
		lvl4(24) <= arith and lvl3(31);
		lvl4(23) <= arith and lvl3(31);
		lvl4(22) <= arith and lvl3(31);
		lvl4(21) <= arith and lvl3(31);
		lvl4(20) <= arith and lvl3(31);
		lvl4(19) <= arith and lvl3(31);
		lvl4(18) <= arith and lvl3(31);
		lvl4(17) <= arith and lvl3(31);
		lvl4(16) <= arith and lvl3(31);
		for i in 16 to lvl3'HIGH LOOP
			lvl4(i-16)	<=	lvl3(i);
		end loop;
	end if;
end if;
end process;
output	<=	lvl4;
end behavorial;

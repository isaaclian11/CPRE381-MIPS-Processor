LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY barrelShifter IS
	GENERIC (
		DATA_WIDTH : INTEGER := 32;
		SEL_WIDTH : INTEGER := 5
	);
	PORT (
		input : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
		arith : IN std_logic;
		rightShift : IN std_logic;
		output : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
		sel : IN std_logic_vector(SEL_WIDTH - 1 DOWNTO 0)
	);

END barrelShifter;

ARCHITECTURE behavorial OF barrelShifter IS

	SIGNAL lvl0 : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
	SIGNAL lvl1 : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
	SIGNAL lvl2 : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
	SIGNAL lvl3 : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
	SIGNAL lvl4 : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);

BEGIN

	PROCESS (input, sel, rightShift, arith)

	BEGIN
		IF (rightShift = '0') THEN
			IF (sel(0) = '0') THEN
				lvl0 <= input;
			ELSE
				lvl0(0) <= '0';
				FOR i IN 1 TO input'HIGH LOOP
					lvl0(i) <= input(i - 1);
				END LOOP;
			END IF;
		ELSE
			IF (sel(0) = '0') THEN
				lvl0 <= input;
			ELSE
				lvl0(31) <= arith AND input(31);
				FOR i IN 1 TO input'HIGH LOOP
					lvl0(i - 1) <= input(i);
				END LOOP;
			END IF;
		END IF;

	END PROCESS;

	PROCESS (lvl0, sel, rightShift, arith)

	BEGIN
		IF (rightShift = '0') THEN
			IF (sel(1) = '0') THEN
				lvl1 <= lvl0;
			ELSE
				lvl1(0) <= '0';
				lvl1(1) <= '0';
				FOR i IN 2 TO lvl0'HIGH LOOP
					lvl1(i) <= lvl0(i - 2);
				END LOOP;
			END IF;
		ELSE
			IF (sel(1) = '0') THEN
				lvl1 <= lvl0;
			ELSE
				lvl1(31) <= arith AND lvl0(31);
				lvl1(30) <= arith AND lvl0(31);
				FOR i IN 2 TO input'HIGH LOOP
					lvl1(i - 2) <= lvl0(i);
				END LOOP;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (lvl1, sel, rightShift, arith)

	BEGIN
		IF (rightShift = '0') THEN
			IF (sel(2) = '0') THEN
				lvl2 <= lvl1;
			ELSE
				lvl2(0) <= '0';
				lvl2(1) <= '0';
				lvl2(2) <= '0';
				lvl2(3) <= '0';
				FOR i IN 4 TO lvl1'HIGH LOOP
					lvl2(i) <= lvl1(i - 4);
				END LOOP;
			END IF;
		ELSE
			IF (sel(2) = '0') THEN
				lvl2 <= lvl1;
			ELSE
				lvl2(31) <= arith AND lvl1(31);
				lvl2(30) <= arith AND lvl1(31);
				lvl2(29) <= arith AND lvl1(31);
				lvl2(28) <= arith AND lvl1(31);
				FOR i IN 4 TO lvl1'HIGH LOOP
					lvl2(i - 4) <= lvl1(i);
				END LOOP;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (lvl2, sel, rightShift, arith)

	BEGIN
		IF (rightShift = '0') THEN
			IF (sel(3) = '0') THEN
				lvl3 <= lvl2;
			ELSE
				lvl3(0) <= '0';
				lvl3(1) <= '0';
				lvl3(2) <= '0';
				lvl3(3) <= '0';
				lvl3(4) <= '0';
				lvl3(5) <= '0';
				lvl3(6) <= '0';
				lvl3(7) <= '0';
				FOR i IN 8 TO lvl2'HIGH LOOP
					lvl3(i) <= lvl2(i - 8);
				END LOOP;
			END IF;
		ELSE
			IF (sel(3) = '0') THEN
				lvl3 <= lvl2;
			ELSE
				lvl3(31) <= arith AND lvl2(31);
				lvl3(30) <= arith AND lvl2(31);
				lvl3(29) <= arith AND lvl2(31);
				lvl3(28) <= arith AND lvl2(31);
				lvl3(27) <= arith AND lvl2(31);
				lvl3(26) <= arith AND lvl2(31);
				lvl3(25) <= arith AND lvl2(31);
				lvl3(24) <= arith AND lvl2(31);
				FOR i IN 8 TO lvl2'HIGH LOOP
					lvl3(i - 8) <= lvl2(i);
				END LOOP;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (lvl3, sel, rightShift, arith)

	BEGIN
		IF (rightShift = '0') THEN
			IF (sel(4) = '0') THEN
				lvl4 <= lvl3;
			ELSE
				lvl4(0) <= '0';
				lvl4(1) <= '0';
				lvl4(2) <= '0';
				lvl4(3) <= '0';
				lvl4(4) <= '0';
				lvl4(5) <= '0';
				lvl4(6) <= '0';
				lvl4(7) <= '0';
				lvl4(8) <= '0';
				lvl4(9) <= '0';
				lvl4(10) <= '0';
				lvl4(11) <= '0';
				lvl4(12) <= '0';
				lvl4(13) <= '0';
				lvl4(14) <= '0';
				lvl4(15) <= '0';
				FOR i IN 16 TO lvl3'HIGH LOOP
					lvl4(i) <= lvl3(i - 16);
				END LOOP;
			END IF;
		ELSE
			IF (sel(4) = '0') THEN
				lvl4 <= lvl3;
			ELSE
				lvl4(31) <= arith AND lvl3(31);
				lvl4(30) <= arith AND lvl3(31);
				lvl4(29) <= arith AND lvl3(31);
				lvl4(28) <= arith AND lvl3(31);
				lvl4(27) <= arith AND lvl3(31);
				lvl4(26) <= arith AND lvl3(31);
				lvl4(25) <= arith AND lvl3(31);
				lvl4(24) <= arith AND lvl3(31);
				lvl4(23) <= arith AND lvl3(31);
				lvl4(22) <= arith AND lvl3(31);
				lvl4(21) <= arith AND lvl3(31);
				lvl4(20) <= arith AND lvl3(31);
				lvl4(19) <= arith AND lvl3(31);
				lvl4(18) <= arith AND lvl3(31);
				lvl4(17) <= arith AND lvl3(31);
				lvl4(16) <= arith AND lvl3(31);
				FOR i IN 16 TO lvl3'HIGH LOOP
					lvl4(i - 16) <= lvl3(i);
				END LOOP;
			END IF;
		END IF;
	END PROCESS;
	output <= lvl4;
END behavorial;
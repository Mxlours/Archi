--------------------------------------------------------------------------------
-- Description:
--
-- Banc de test de la partie opérative
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_PO is
end tb_PO;

architecture behavior of tb_PO is

    component PO
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        getA  : in  std_logic;
        getB  : in  std_logic;
        subBA : in  std_logic;
        ldA   : in  std_logic;
        ldB   : in  std_logic;
        A0    : in  unsigned(7 downto 0);
        B0    : in  unsigned(7 downto 0);
        LT    : out  std_logic;
        EQ    : out  std_logic;
        Res   : out  unsigned(7 downto 0)
    );
    end component;

    --inputs
    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    signal getA  : std_logic := '0';
    signal getB  : std_logic := '0';
    signal subBA : std_logic := '0';
    signal ldA   : std_logic := '0';
    signal ldB   : std_logic := '0';
    signal A0    : unsigned(7 downto 0) := X"30";
    signal B0    : unsigned(7 downto 0) := X"20";

 	--outputs
    signal LT  : std_logic;
    signal EQ  : std_logic;
    signal Res : unsigned(7 downto 0);

    -- Clock period definitions
    constant clk_period : time := 8 ns;

begin

	-- instantiate the Unit Under Test (UUT)
    uut: PO port map (
        clk   => clk,
        reset => reset,
        getA  => getA,
        getB  => getB,
        subBA => subBA,
        ldA   => ldA,
        ldB   => ldB,
        A0    => A0,
        B0    => B0,
        LT    => LT,
        EQ    => EQ,
        Res   => Res
    );

   -- Clock process definitions
    process
    begin
        clk <= not clk;
        wait for clk_period/2 ;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
		reset <= '0';
		wait for clk_period/4;
		-- chargement du registre A
		lda <= '1';
		geta <= '1';

		-- ici A=0, B =0
		assert ( EQ = '1') report "==== ERREUR : Sortie EQ fausse" severity error;
		assert ( LT = '0') report "==== ERREUR : Sortie LT fausse" severity error;
		assert ( RES = X"00" ) report "==== ERREUR : Sortie RES fausse" severity error;

		wait for clk_period;
		-- chargement du registre B
		lda <= '0';
		geta <= '0';
		ldb <= '1';
		getb <= '1';

		-- ici A=x30, B =0
		assert ( EQ = '0') report "==== ERREUR : Sortie EQ fausse" severity error;
		assert ( LT = '0') report "==== ERREUR : Sortie LT fausse" severity error;
		assert ( RES = X"00" ) report "==== ERREUR : Sortie RES fausse" severity error;

		wait for clk_period;
		-- MAJ du registre A
		lda <= '1';
		ldb <= '0';
		getb <= '0';

		-- ici A=x30, B = x20
		assert ( EQ = '0') report "==== ERREUR : Sortie EQ fausse" severity error;
		assert ( LT = '0') report "==== ERREUR : Sortie LT fausse" severity error;
		assert ( RES = X"20" ) report "==== ERREUR : Sortie RES fausse" severity error;

		wait for clk_period;
		-- MAJ du registre B
		lda <= '0';
		ldb <= '1';
		subba <= '1';

		-- ici A=x10, B = x20
		assert ( EQ = '0') report "==== ERREUR : Sortie EQ fausse" severity error;
		assert ( LT = '1') report "==== ERREUR : Sortie LT fausse" severity error;
		assert ( RES = X"20" ) report "==== ERREUR : Sortie RES fausse" severity error;

		wait for clk_period;
		-- MAJ du registre B
          -- ici A=x10, B = x10
          subba <= '0';
		assert ( EQ = '1') report "==== ERREUR : Sortie EQ fausse" severity error;
		assert ( LT = '0') report "==== ERREUR : Sortie LT fausse" severity error;
		assert ( RES = X"10" ) report "==== ERREUR : Sortie RES fausse" severity error;

		wait for clk_period;
		-- Tests finaux
		ldb <= '0';
		-- ici A=x10, B = x0
		assert ( EQ = '0') report "==== ERREUR : Sortie EQ fausse" severity error;
		assert ( LT = '0') report "==== ERREUR : Sortie LT fausse" severity error;
		assert ( RES = X"00" ) report "==== ERREUR : Sortie RES fausse" severity error;

		wait for clk_period;
		report "Simulation terminée" severity failure;

    end process;

end;

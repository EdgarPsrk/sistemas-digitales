-- Definición de la entidad vga_initials
entity vga_initials is
    port(
        vidon: in std_logic;               -- Señal de video activada
        hc: in std_logic_vector (9 downto 0);  -- Contador horizontal
        vc: in std_logic_vector (9 downto 0);  -- Contador vertical
        M: in std_logic_vector (0 to 31);     -- Datos de la memoria ROM
        sw: in std_logic_Vector (7 downto 0);  -- Interruptores (switches)
        rom_addr4: out std_logic_vector (3 downto 0);  -- Dirección de la memoria ROM de 4 bits
        red: out std_logic_vector (3 downto 0);       -- Componente de color rojo
        green: out std_logic_vector (3 downto 0);     -- Componente de color verde
        blue: out std_logic_vector (3 downto 0)       -- Componente de color azul
    );
end vga_initials;

-- Implementación de la arquitectura Behavioral de vga_initials
architecture Behavioral of vga_initials is
    -- Constantes para la sincronización vertical y horizontal
    constant hbp: std_logic_vector (9 downto 0) := "0010010000"; -- HBP = SP + BP = 128 + 16 = 144
    constant vbp: std_logic_vector (9 downto 0) := "0000011111"; -- VBP = SP + BP = 2 + 29 = 31

    -- Constantes para las dimensiones iniciales de posición
    constant w: integer := 32; -- Ancho
    constant h: integer := 16; -- Alto

    -- Señales para la posición superior-izquierda (Columna, Renglon)
    signal C1, R1: std_logic_vector (10 downto 0);

    -- Señales adicionales
    signal rom_addr, rom_pix: std_logic_vector (10 downto 0); -- Renglón-Columna del bit en la pantalla
    signal spriteon: std_logic; -- Determina si está en la región 16x32
    signal r, g, b: std_logic;

begin
    -- Lógica para la posición superior-izquierda (Columna, Renglon) con los interruptores
    C1 <= "00" & sw(3 downto 0) & "00001";
    R1 <= "00" & sw(7 downto 4) & "00001";
    rom_addr <= vc - vbp - R1;
    rom_pix <= hc - hbp - C1;
    rom_addr4 <= rom_addr (3 downto 0);

    -- Lógica para determinar si está en el área de la imagen
    spriteon <= '1' when (((hc >= C1 + hbp) and (hc < C1 + hbp + w)) and ((vc >= R1 + vbp) and (vc < R1 + vbp + h))) else '0';

    -- Proceso para actualizar los componentes de color
    process (spriteon, vidon, rom_pix, M, r, g, b)
        variable j: integer;
    begin
        red <= "0000";
        green <= "0000";
        blue <= "0000";

        if (spriteon = '1' and vidon = '1') then
            j := conv_integer(rom_pix);
            r <= M(j);
            g <= M(j);
            b <= M(j);
            red <= r & r & r & r;
            green <= g & g & g & g;
            blue <= b & b & b & b;
        end if;
    end process;

end Behavioral;

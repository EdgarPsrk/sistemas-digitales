-- Definición de la entidad vga_640x480
entity vga_640x480 is
    Port (
        clk, clr : in STD_LOGIC;
        hsync : out STD_LOGIC;
        vsync : out STD_LOGIC;
        hc : out STD_LOGIC_VECTOR(9 downto 0);
        vc : out STD_LOGIC_VECTOR(9 downto 0);
        vidon : out STD_LOGIC
    );
end vga_640x480;

-- Implementación de la arquitectura Behavioral de la entidad vga_640x480
architecture Behavioral of vga_640x480 is
    -- Parámetros de temporización horizontal
    constant hbp: std_logic_vector(9 downto 0) := "0010010000"; -- HBP = SP+BP = 96+48 = 144
    constant hfp: std_logic_vector(9 downto 0) := "1100010000"; -- HFP = HBP+HV = 144+640 = 784
    constant hpixels: std_logic_vector(9 downto 0) := "1100100000"; -- Cantidad de píxeles en una línea horizontal = SP+BP+HV+FP = 96+48+640+16 = 800

    -- Parámetros de temporización vertical
    constant vbp: std_logic_vector(9 downto 0) := "0000100011"; -- VBP = SP+BP = 2+33 = 35
    constant vfp: std_logic_vector(9 downto 0) := "1000000011"; -- VFP = VBP+VV = 35+480 = 515
    constant vlines: std_logic_vector(9 downto 0) := "1000001101"; -- Cantidad de líneas verticales en la pantalla = SP+BP+VV+FP = 2+33+480+10 = 521

    -- Declaración de señales internas
    signal hcount, vcount: std_logic_vector(9 downto 0);

    -- Proceso principal
    begin
        process(clk, clr)
        begin
            if clr = '1' then
                -- Restablecer valores cuando la señal de reinicio (clr) es alta
                hcount <= (others => '0');
                vcount <= (others => '0');
                hsync <= '0';
                vsync <= '0';
                hc <= (others => '0');
                vc <= (others => '0');
                vidon <= '0';
            elsif rising_edge(clk) then
                -- Incrementar contadores en el flanco de subida del reloj
                hcount <= hcount + 1;
                vcount <= vcount + 1;

                -- Lógica de temporización horizontal
                if hcount < hbp or hcount >= hpixels then
                    hsync <= '1';
                else
                    hsync <= '0';
                end if;

                -- Lógica de temporización vertical
                if vcount < vbp or vcount >= vlines then
                    vsync <= '1';
                else
                    vsync <= '0';
                end if;

                -- Salida de contadores y señal de video activada
                hc <= hcount;
                vc <= vcount;
                vidon <= '1';
            end if;
        end process;
    end Behavioral;

module testbench();
  logic        clk, reset, memwrite;
  logic [31:0] pc, instr;
  logic [31:0] writedata, addr, readdata;

  wire [31:0] MEM_readdata, IO_readdata;
  wire [9:0] trng_out, cripto_out;
  reg [9:0] key;
  reg [9:0] ciphertext;
  wire trng_ready;
  reg [9:0] plaintext;

  reg [9:0] LEDR;
  reg [3:0] KEY;
  reg [9:0] SW;
  reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  
  assign reset = ~KEY[0];

  // memory-mapped i/o
  wire isIO  = addr[8]; // 0x0000_0100
  wire isCRPT = addr[9]; // 0x0000_0200
  wire isRAM = !isIO && !isCRPT;

  localparam IO_LEDS_bit = 2; // 0x0000_0104
  localparam IO_HEX_bit  = 3; // 0x0000_0108
  localparam IO_KEY_bit  = 4; // 0x0000_0110 
  localparam IO_SW_bit   = 5; // 0x0000_0120
  localparam CRPT_TRNG = 1; // 0x0000_0202
  localparam CRPT_SETPT = 2; // 0x0000_0204
  localparam CRPT_GET_CIPHER = 3; // 0x0000_0208
  reg [23:0] hex_digits; // memory-mapped I/O register for HEX
  dec7seg hex0(hex_digits[ 3: 0], HEX0);
  dec7seg hex1(hex_digits[ 7: 4], HEX1);
  dec7seg hex2(hex_digits[11: 8], HEX2);
  dec7seg hex3(hex_digits[15:12], HEX3);
  dec7seg hex4(hex_digits[19:16], HEX4);
  dec7seg hex5(hex_digits[23:20], HEX5);
  always @(posedge clk) begin

	  if (reset) begin
		  LEDR <= 0;
		  hex_digits <= 0;
	  end
    if (memwrite & isIO) begin // memory-mapped I/O
      if (addr[IO_LEDS_bit])
        LEDR <= writedata;
      if (addr[IO_HEX_bit])
        hex_digits <= writedata;
    end

    if (memwrite & isCRPT & addr[CRPT_SETPT]) begin
      plaintext <= writedata;
    end

    if (trng_ready) begin
      LEDR <= 10'b1111111111;
      key <= trng_out;
    end
end
    
  // microprocessor
  riscvpipeline cpu(clk, reset, pc, instr, addr, writedata, memwrite, readdata);

  // instructions memory 
  mem #("text.hex") instr_mem(.clk(clk), .a(pc), .rd(instr));

  // data memory 
  mem #("data.hex") data_mem(clk, memwrite & isRAM, addr, writedata, MEM_readdata);

  //TRNG
  trng generator(clk, reset, trng_out, trng_ready);

  //Cripto module
  cripto enc(clk, reset, plaintext, key, ciphertext);

  assign IO_readdata = addr[     IO_KEY_bit] ? {28'b0, KEY} :
                       addr[      IO_SW_bit] ? {22'b0,  SW} :
                       addr[      CRPT_TRNG] ? {22'b0, key} :
                       addr[CRPT_GET_CIPHER] ? {22'b0, ciphertext} :
                                                32'b0       ;
  assign readdata = (isIO || (isCRPT && addr[CRPT_TRNG]) || (isCRPT && addr[CRPT_GET_CIPHER])) ? IO_readdata : MEM_readdata; 
  
  // initialize test
  initial begin
    $dumpfile("dump.vcd"); $dumpvars(0);
    $monitor(
      "%3t | %b | pt=%b | aout=%b (%b) [%b] || key_ready=%b", 
      $time, LEDR, plaintext, ciphertext, enc.keys[0], enc.rkeys[0], trng_ready
    );
    #10000;
    $writememh("regs.out", cpu.RegisterBank);
    $finish;
  end
  
  initial begin
    KEY[0] = 1;
    #10 KEY[0] = 0;
    #20 KEY[0] = 1;
    #25 SW = 10'b1111111111;
    #5000 SW = 10'b1010101010;
  end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end
endmodule
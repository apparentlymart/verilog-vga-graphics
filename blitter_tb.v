module test_ram(
    input        clk,
    input        enable,
    input [27:1] addr,
    inout [15:0] data,
    input        write,
    input        uds,
    input        lds,
    input        loadmem,
    input        dumpmem
);

   reg [15:0]    data_out;
   assign data = (enable & ~write) ? {
       uds ? data_out[15:8] : 8'bz,
       lds ? data_out[7:0] : 8'bz
    } : 'bz;

   reg [15:0]    mem [0:2048];

   always @(posedge clk) begin
      if (enable & write) begin
        if (uds)
          mem[addr][15:8] = data[15:8];
        if (lds)
          mem[addr][7:0] = data[7:0];
      end
   end

   always @(posedge clk) begin
      if (enable & ~write)
        data_out = mem[addr];
   end

   always @(posedge loadmem)
     $readmemh("blitter_tb_initial.mem", mem);

   always @(posedge dumpmem)
     $writememh("blitter_tb_result.mem", mem);
endmodule

module blitter_tb;
   reg reset;
   reg clk;
   reg enable_blitter;
   wire [27:1] addr;
   wire [15:0] data;
   wire write;
   wire uds;
   wire lds;
   wire dtack;
   wire berr;

   reg  [27:1] cpu_addr = 0;
   reg  [15:0] cpu_data = 0;
   reg  cpu_write = 0;
   reg  cpu_uds = 0;
   reg  cpu_lds = 0;
   reg  assert_cpu_control = 0;
   reg  enable_ram = 0;

   reg  dumpmem = 0;
   reg  loadmem = 0;

   assign addr = assert_cpu_control ? cpu_addr : 'bz;
   assign data = (assert_cpu_control && cpu_write) ? cpu_data : 'bz;
   assign write = assert_cpu_control ? cpu_write : 'bz;
   assign uds = assert_cpu_control ? cpu_uds : 'bz;
   assign lds = assert_cpu_control ? cpu_lds : 'bz;

   blitter dut(
       reset,
       clk,
       enable_blitter,
       addr,
       data,
       write,
       uds,
       lds,
       dtack,
       berr
   );

   test_ram ram(
       clk,
       enable_ram,
       addr,
       data,
       write,
       uds,
       lds,
       loadmem,
       dumpmem
   );

   task write_ram;
      input [27:1] addr;
      input [15:0] new_data;
      begin
         @(negedge clk);
         cpu_addr = addr;
         cpu_data = new_data;
         cpu_write = 1;
         enable_ram = 1;
         cpu_uds = 1;
         cpu_lds = 1;
         assert_cpu_control = 1;

         @(negedge clk);
         enable_ram = 0;
         assert_cpu_control = 0;
      end
   endtask

   task write_reg;
      input [3:0] target_register;
      input [15:0] new_data;
      begin
         @(negedge clk);
         cpu_addr = {12'b0, target_register};
         cpu_data = new_data;
         cpu_write = 1;
         enable_blitter = 1;
         cpu_uds = 1;
         cpu_lds = 1;
         assert_cpu_control = 1;

         @(posedge dtack);
         assert_cpu_control = 0;
         enable_blitter = 0;
      end
   endtask

   task read_reg;
      input [3:0] target_register;
      output [15:0] data_read;
      begin
         @(negedge clk);
         cpu_addr = {12'b0, target_register};
         enable_blitter = 1;
         cpu_uds = 1;
         cpu_lds = 1;
         assert_cpu_control = 1;

         @(posedge dtack);
         data_read = data;
         assert_cpu_control = 0;
         enable_blitter = 0;
      end
   endtask

   initial begin
      clk = 0;
      enable_blitter = 0;
      enable_ram = 0;
      loadmem = 1;
      $dumpfile("blitter_tb.vcd");
      $dumpvars;

      #4;
      write_ram(0, 'hffff);
      write_reg(1, 15);
      #4;

      dumpmem = 1;
      $finish;
   end

   always #1 clk = ~clk;

   always #50 $finish;

endmodule

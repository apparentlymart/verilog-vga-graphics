/**
 * Register map:
 *
 * 0: Source Parameter Word 1
 * 1: Source Parameter Word 2
 * 2: Destination Parameter Word 1
 * 3: Destination Parameter Word 2
 * 4: Source Parameter Word 3
 * 5: Destination Parameter Word 3
 * 6: Column Count
 * 7: Row Count
 * 8: Operation Code
 * 9: status register TBD
 * a: status register TBD
 * b: status register TBD
 * c: status register TBD
 * d: status register TBD
 * e: status register TBD
 * f: status register TBD
 *
 * Opcodes:
 * 0: No op.
 * 1: Raw word blit
 * 2: Pixel blit
 * 3: Fill rect
 * all other values reserved for future expansion
 *
 * Writing a non-zero value to the opcode register initiates the blit
 * operation.
 *
 * It is not permitted to write to any registers while an operation is in
 * progress. A Bus Error will be signalled if this is attempted.
 */
module blitter(
    input        reset,
    input        clk,
    input        enable,
    inout [27:1] addr, // Only lower four bits considered on input.
    inout [15:0] data,
    inout        write,
    inout        uds,
    inout        lds,
    output       dtack,
    output       berr
);

   reg           assert_dtack = 0;
   assign dtack = assert_dtack ? 1 : 0;
   reg           assert_berr = 0;
   assign berr = assert_berr ? 1 : 0;

   reg [15:0]    registers [0:15];

   always @(posedge clk) begin
      if (enable)
        assert_dtack = 1;
      else
        assert_dtack = 0;
   end
endmodule

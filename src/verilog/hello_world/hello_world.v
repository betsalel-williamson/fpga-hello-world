// hello_world.v
module hello_world (
    input wire clk,
    input wire rst,
    output reg [7:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 8'h00;
    end else begin
        count <= count + 8'h01;
    end
end

endmodule

// Testbench for hello_world
module testbench;

  reg clk;
  reg rst;
  wire [7:0] count;

  // Instantiate the Device Under Test (DUT)
  hello_world dut (
    .clk(clk),
    .rst(rst),
    .count(count)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period
  end

  // Test sequence
  initial begin
    $dumpfile("hello_world.vcd");
    $dumpvars(0, testbench);

    rst = 1; #10; // Assert reset for 10ns
    rst = 0; #10; // Release reset for 10ns

    #3000; // Run for 3000ns (enough for counter to wrap around at least once)

    rst = 1; #10; // Assert reset again
    rst = 0; #10; // Release reset

    #100; // Run for a short period after second reset

    $finish; // End simulation
  end

endmodule

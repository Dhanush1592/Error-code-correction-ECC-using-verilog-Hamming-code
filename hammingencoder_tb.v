`timescale 1ns / 1ps

module hammingencoder_tb;

    // Inputs
    reg [7:0] data_in;

    // Output
    wire [12:0] encoded_out;

    // Instantiate the encoder
    hammingencoder uut (
        .data_in(data_in),
        .encoded_out(encoded_out)
    );

    initial begin
        $display("Time\tInput Data\tEncoded Output (WP|D8..P1)");
        $monitor("%0t\t%b\t%b", $time, data_in, encoded_out);

        // Test cases
        data_in = 8'b00001111; #10;

        $finish;
    end

endmodule

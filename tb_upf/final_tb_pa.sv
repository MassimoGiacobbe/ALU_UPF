`timescale 1ns/1ps
module final_tb_pa;
import UPF::*;

localparam int unsigned NBITS = 8;

logic [NBITS-1 : 0] A_tb;
logic [NBITS-1 : 0] B_tb;
logic [2*NBITS-1 : 0] out_tb;
logic [NBITS-1 : 0] lut_prog_tb; // new input program lut
logic clk;
logic rst_n;
logic [1 : 0] op_code_tb,funcL_tb;
logic sleep;
bit status0,status1,status2,status3,status4,status5,status6,status7,status8,status9;

dummyALU UUT( 
    .clk(clk),
    .rst_n(rst_n),
    .O(out_tb),
    .B(B_tb),
    .A(A_tb),
    .go_sleep(sleep),
    .OP_CODE(op_code_tb), // changed from 1 bit to 2
    .FuncL(funcL_tb), // new 2-bit (0-1-2) to select logical function
    .Lut_prog(lut_prog_tb) // new 3-bit (0-7) lut bits
);

// CORE :
always@(posedge clk) begin
	if(rst_n != 1'b0 && sleep != 1'b0) begin
	assign_inputs(A_tb, B_tb, op_code_tb, funcL_tb, lut_prog_tb);
        #10 compute_correct_result(A_tb, B_tb, op_code_tb, funcL_tb, lut_prog_tb, out_tb);  
	end
end 

// CLOCK :
always #2 clk = ~clk;

// ENTIRE PROCEDURE :
initial begin
    rst_n = 0;
    clk = 1;
    A_tb = 8'b00000000;
    B_tb = 8'b00000000;
    op_code_tb = 2'b00;
    funcL_tb = 2'b00;
    lut_prog_tb = 3'b000;

    // PA Initializations
    status0=supply_on("UUT/VBACK", 1.2);
    status1=supply_on("UUT/VSS", 0.0);
    status2=supply_on("UUT/VDDH", 1.2);
    status3=supply_on("UUT/VDDL", 1.2);
    status4=supply_on("UUT/VDDJ", 1.2);
    status5=supply_on("UUT/VDDK", 1.2);
    sleep = 1'b1;
    #10 rst_n = 1; 
    #1000;
    status0=supply_on("UUT/VBACK", 1.2);
    status1=supply_on("UUT/VSS", 0.0);
    status2=supply_on("UUT/VDDH", 0.8);
    status3=supply_on("UUT/VDDL", 0.8);
    status4=supply_on("UUT/VDDJ", 0.8);
    status5=supply_on("UUT/VDDK", 0.8);
    #1000
    sleep = 1'b0;
    #4
    status6=supply_off("UUT/VDDL");
    status7=supply_off("UUT/VDDH");
    status8=supply_off("UUT/VDDJ");
    status9=supply_off("UUT/VDDK");
    #200;
    status2=supply_on("UUT/VDDH", 0.8);
    status3=supply_on("UUT/VDDL", 0.8);
    status4=supply_on("UUT/VDDJ", 0.8);
    status5=supply_on("UUT/VDDK", 0.8);
    #4
    sleep = 1'b1;
end

task assign_inputs;
    output [NBITS-1 : 0] A, B;
    output [1 : 0] op_code; //changed
    output [2 : 0] Lut_prog; // new
    output [1 : 0] FuncL; // new
    
    begin
    A = $urandom_range(0, 255);
    B = $urandom_range(0, 255);
    op_code = $urandom_range(0, 3); // opcodes from 0 to 3
    Lut_prog = $urandom_range(0, 7); // 8-cell 2^3 lut addrs
    FuncL = $urandom_range(0, 3); // 2-bit (0/3,1,2), 3 logic functions
    end

endtask

task compute_correct_result;
    input [NBITS-1 : 0] A, B;
    input [1 : 0] op_code; // changed: 2 bit opcode
    input [2*NBITS-1 : 0] res;
    input [7 : 0] Lut_prog; // new
    input [1 : 1] FuncL; // new
    int correct_res;

    begin
    
        $write("[%0t] %d ", $time, A);
    
        if(op_code == 3) begin //LOGIC
            if(FuncL==1) begin //and
            	$write("&& %d = %d\n", B, res); 
            	correct_res = A&B;
            end if(FuncL==2) begin //or
            	$write("|| %d = %d\n", B, res); 
            	correct_res = A|B;
            end else begin //xor
            	$write("^^ %d = %d\n", B, res); 
            	correct_res = A^B;
            end
            //LOGIC
            //$write("+ %d = %d\n", B, res); 
            //correct_res = A + B;    
        end if(op_code == 2) begin //LUT
            $write("(3lsb only) -> lut_mem: %d = %d\n", Lut_prog, res); 
            correct_res = Lut_prog[A[2:0]];
        end if(op_code == 1) begin //ADD
            $write("+ %d = %d\n", B, res); 
            correct_res = A + B;    
        end else begin //MUL
            $write("* %d = %d\n", B, res); 
            correct_res = A * B;
        end
    
    if(correct_res != res) begin
            $display("Incorrect result! Correct result is %d", correct_res);
    end
    end

endtask

endmodule

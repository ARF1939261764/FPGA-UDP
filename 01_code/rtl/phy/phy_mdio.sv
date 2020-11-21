module phy_mdio #(
  parameter MDIO_CLK_DIV = 20
)(
  input  logic      clk,
  input  logic      rest_n,
  /*read/write phy reg*/
  input  logic       ren,
  input  logic       wen,
  input  logic[4:0]  phy_addr,
  input  logic[4:0]  reg_addr,
  input  logic[15:0] wdata,
  output logic[15:0] rdata,
  output logic       rw_ready,
  /*phy io*/
  output logic       mdio_clk,
  inout  logic       mdio_io
);
/********************************************************************************
param
********************************************************************************/
localparam PREAMBLE = {32{1'b1}},
           ST       = 2'b01,
           OP_R     = 2'b10,
           OP_W     = 2'b01,
           TA_R     = 2'bZZ,
           TA_W     = 2'b10;

/********************************************************************************
clock div
********************************************************************************/
reg[7:0] clk_div_count;
reg      clk_div_en;
always @(posedge clk or negedge rest_n) begin
  if(!rest_n) begin
    clk_div_count <= 1'd0;
  end
  else begin
    if(clk_div_count == MDIO_CLK_DIV - 1'd1) begin
      clk_div_count <= 1'd0;
      clk_div_en    <= 1'd1;
    end
    else begin
      clk_div_count++;
      clk_div_en <= 1'd0;
    end
  end
end

/********************************************************************************
frame
********************************************************************************/
wire[63:0] frame;
assign frame = {
          PREAMBLE[31:0],
          ST[1:0],
          ren ? OP_R[1:0] : OP_W[1:0],
          phy_addr[4:0],
          reg_addr[4:0],
          ren ? TA_R[1:0] : TA_W[1:0],
          ren ? 16'hZZ : wdata[15:0]
};
/********************************************************************************
request
********************************************************************************/
wire request;
assign request = ren | wen;

/********************************************************************************
handle request
********************************************************************************/
reg[5:0] count;
reg[63:0] send_buff;
reg[15:0] rece_buff;
always @(posedge clk or negedge rest_n) begin
  if(!request) begin
    count <= 1'd0;
  end
  else begin
    
  end
end

endmodule

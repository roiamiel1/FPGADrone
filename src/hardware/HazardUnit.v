module HazardUnit (
    input Jump,
    input BranchTaken,
    output Hazard
);
    assign Hazard = Jump || BranchTaken;
endmodule

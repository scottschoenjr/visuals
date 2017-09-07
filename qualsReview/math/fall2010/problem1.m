clear all
close all
clc

T = [ ...
     3, -1, 0; ...
    -1,  3, 0; ...
     0,  0, 1; ...
     ];

 [a, b] = eig(T)
 
 [c, d] = eig(T*T)


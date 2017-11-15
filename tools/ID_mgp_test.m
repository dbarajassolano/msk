function parentdir = ID_mgp_test

current = pwd;
parent  = fileparts(current);
parentdir = current(length(parent) + 2 : end);
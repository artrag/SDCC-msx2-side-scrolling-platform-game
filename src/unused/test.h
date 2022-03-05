#pragma once

void putch(char c) __sdcccall(1) __naked;
void chgmod(char c) __sdcccall(1) __naked ;

void print_hello() __banked;
void print_hello_rev() __banked;

void data0(void) __banked __naked;
void data1(void) __banked __naked;
void data2(void) __banked __naked;
void data3(void) __banked __naked;


void data_levels(void) __banked __naked;

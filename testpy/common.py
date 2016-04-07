#!/usr/bin/env python
"""Common functions shared throughout the module
"""

__author__ = "Jacob Barnett"
__contact__ = "jacob.barnett@mail.mcgill.ca"
__date__ = "April 5, 2016"

import math
	
def mod_mult(a,b,N):


    # a = conv(a, N)
    # b = conv(b, N)
    # print("a: " + str(a) + " b: " + str(b))

    mask = 0b00000001
    S = 0b00000000
    N_temp = N
    for i in range(num_bits(N)):
        #print("mask & s =" + bin(mask & S))
        #print("mask & a =" + bin(mask & a))
        #print("mask & b =" + bin(mask & b))
        #print("(mask & a)*(mask & b) =" + bin((mask & a)*(mask & b)))
        q = ((mask & S) + (mask & a)*(mask & b)) % 2
        #print("q_i = " + str(q))
        S = int((S + (mask & a)*b + q*N)/2)
        #print("S_i = " + str(S))
        N_temp = N_temp >> 1
        #print("N_temp = " + bin(N_temp))
        a = a >> 1
        #print("a = " + bin(a))
        if N_temp == 0:
            break

    if (S > N):
        S -= N
    print("S = " + str(S))
    return S



def mod_exp(C,d,n):

    # C = conv(C, n)
    #d = conv(d, n)
    k = num_bits(n)
    # print("c: " + str(C) + " d: " + str(d))
    # print("k bits: " + str(k))

    mask = 0b00000001
    K = int(2**(2*k) % n)
    #print("K: " + str(K))
    # K = conv(K, n)
    P_old = mod_mult(K,C,n)
    # print("P_old: " + str(P_old))
    R = mod_mult(K,1,n)
    # print("R_old: " + str(R))
    # print("P_old: " + str(P_old) + " R: " + str(R))
    
    for i in range(num_bits(d)):
        #print("number of bits: " + str(num_bits(d)))
        #print("d: " + str(d))
        print("computing P")    
        P = mod_mult(P_old,P_old,n)
        print("P: " + str(P) + " P_old: " + str(P_old))
        if (mask & d) == 1:
            print("R_old: " + str(R))    
            R = mod_mult(R,P_old,n)
            print("R: " + str(R))
        d = d >> 1
        P_old = P
    print("computing final result")
    M = mod_mult(1,R,n)
    return M

def conv(x, n):
    k = num_bits(n)
    r = 2**k
    return int( (x * r) % n )

# def conv_inv()

def num_bits(x):
    return int(math.ceil(math.log(x,2)))


def mont_result(a, b, n):
    A = conv(a, n)
    B = conv(b, n)
    k = num_bits(n)
    r = 2**k

    r_inv = modinv(r, n)
    # print(str(r) + " " + str(r_inv))

    return (A * B * r_inv) % n

## taken from http://stackoverflow.com/questions/4798654/modular-multiplicative-inverse-function-in-python
def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = egcd(b % a, a)
        return (g, x - (b // a) * y, y)

def modinv(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
        raise Exception('modular inverse does not exist')
    else:
        return x % m

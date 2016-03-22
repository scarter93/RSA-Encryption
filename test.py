import math

#b = 16

#print(bin(a),bin(b))


#N = 143
#print(N)
#N_temp = N

#print("N_temp = " + bin(N_temp)) 

# main tester function
def main():
    # basic encryption example
    # a = 9
    # b = 7
    # n = 143

    # basic decryption example
    a = 48
    b = 103
    n = 143

    print(mod_exp(a, b, n))
    print("montgomery product: " + str(mont_result(a, b, n)))



def mod_mult(a,b,N):
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
        if N_temp == 1:
            break
    print("S = " + str(S))
    return S


def mod_exp(C,d,n):

    C = conv(C, n)
    d = conv(d, n)
    k = num_bits(n)
    iters = num_bits(d)
    print("c: " + str(C) + " d: " + str(d))

    mask = 0b00000001
    K = int(2**(2*k) % n)
    P_old = mod_mult(K,C,n)
    R = mod_mult(K,1,n)
    
    for i in range(iters):
        P = mod_mult(P_old,P_old,n)
        if (mask & d) == 1:
            R = mod_mult(R,P_old,n)
        d = d >> 1
        p_old = P
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

    return (A * r * r_inv) % n


# full example 
# print(mod_exp(1976620216402300889624482718775150, 65537 ,145906768007583323230186939349070635292401872375357164399581871019873438799005358938369571402670149802121818086292467422828157022922076746906543401224889672472407926969987100581290103199317858753663710862357656510507883714297115637342788911463535102712032765166518411726859837988672111837205085526346618740053))

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

if __name__ == "__main__":
    main()



## attempt at following the algorithm to a T
# def mod_exp(C,d,n):

#     C = conv(C, n)
#     d = conv(d, n)
#     k = num_bits(n)
#     iters = num_bits(d)
#     print("c: " + str(C) + " d: " + str(d))

#     mask = 0b00000001
#     K = int(2**(2*k) % n)
#     P = []
#     R = []
#     P.append(mod_mult(K,C,n))
#     R.append(mod_mult(K,1,n))
    
#     for i in range(iters):
#         P.append(mod_mult(P[i],P[i],n))
#         if (mask & d) == 1:
#             print(i)
#             R.append(mod_mult(R[i],P[i],n))
#         else:
#             R.append(0)
#         d = d >> 1
#     M = mod_mult(1,R[len(R) -1],n)
#     return M

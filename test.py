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
    # a = 48
    # b = 103
    # n = 143

    # new example
    # a = 2 # encrypt
    # b = 7
    # a = 29 # decrypt
    # b = 3   
    # n = 33

    ## massive example
    # encrypt
    a = 1976620216402300889624482718775150
    b = 65537
    # decrypt
    # a = 35052111338673026690212423937053328511880760811579981620642802346685810623109850235943049080973386241113784040794704193978215378499765413083646438784740952306932534945195080183861574225226218879827232453912820596886440377536082465681750074417459151485407445862511023472235560823053497791518928820272257787786
    # b = 89489425009274444368228545921773093919669586065884257445497854456487674839629818390934941973262879616797970608917283679875499331574161113854088813275488110588247193077582527278437906504015680623423550067240042466665654232383502922215493623289472138866445818789127946123407807725702626644091036502372545139713
    n = 145906768007583323230186939349070635292401872375357164399581871019873438799005358938369571402670149802121818086292467422828157022922076746906543401224889672472407926969987100581290103199317858753663710862357656510507883714297115637342788911463535102712032765166518411726859837988672111837205085526346618740053


    print("result: " + str(mod_exp(a, b, n)))
    print("compare: " + str((a**b) % n))
    # print("montgomery product: " + str(mont_result(a, b, n)))

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
    print("c: " + str(C) + " d: " + str(d))

    mask = 0b00000001
    K = int(2**(2*k) % n)
    # K = conv(K, n)
    P_old = mod_mult(K,C,n)
    R = mod_mult(K,1,n)
    # print("P_old: " + str(P_old) + " R: " + str(R))
    
    for i in range(num_bits(d)):
        P = mod_mult(P_old,P_old,n)
        if (mask & d) == 1:
            R = mod_mult(R,P_old,n)
        d = d >> 1
        P_old = P
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
    print(str(r) + " " + str(r_inv))

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

if __name__ == "__main__":
    main()

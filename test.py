#b = 16

#print(bin(a),bin(b))


#N = 143
#print(N)
#N_temp = N

#print("N_temp = " + bin(N_temp)) 




def mod_mult(a,b,N):
    mask = 0b00000001
    S = 0b00000000
    N_temp = N
    for i in range(1024):
        #print("mask & s =" + bin(mask & S))
        #print("mask & a =" + bin(mask & a))
        #print("mask & b =" + bin(mask & b))
        #print("(mask & a)*(mask & b) =" + bin((mask & a)*(mask & b)))
        q = (mask & S + (mask & a)*(mask & b)) % 2
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
    mask = 0b00000001
    K = int(2^(2*1024) % n)
    P_old = mod_mult(K,C,n)
    R = mod_mult(K,1,n)
    
    for i in range(17):
        P = mod_mult(P_old,P_old,n)
        if (mask & d) == 1:
            R = mod_mult(R,P_old,n)
        d = d >> 1
        p_old = P
    M = mod_mult(1,R,n)
    return M
    
print(mod_exp(1976620216402300889624482718775150,65537 ,145906768007583323230186939349070635292401872375357164399581871019873438799005358938369571402670149802121818086292467422828157022922076746906543401224889672472407926969987100581290103199317858753663710862357656510507883714297115637342788911463535102712032765166518411726859837988672111837205085526346618740053))
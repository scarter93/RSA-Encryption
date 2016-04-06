#!/usr/bin/env python
"""Generates VHDL testbench files to test components.
This can test the two main components of the project,
the Montgomery Modular Multiplier and the Modular
Exponentiator.
"""

__author__ = "Jacob Barnett"
__contact__ = "jacob.barnett@mail.mcgill.ca"
__date__ = "April 5, 2016"

# package imports
import rsa
import time
import sys

# local imports
import common

key_data_width = "${DATA_WIDTH}"
key_date = "${DATE}"
key_body = "${TEST_BODY}"

modular_exponentiation = "ME"
montgomery_multiplication = "MM"

# Options variables
data_width = 32
num_tests = 5

def main():
	generateTB(modular_exponentiation)

def generateTB(choice):

	body_str = ""
	for i in range(1, num_tests):
		(pubkey, privkey) = rsa.newkeys(data_width)
		m = rsa.randnum.randint(2**(data_width-1))
		if choice == montgomery_multiplication:
			body_str += createTestStringMM(m, pubkey.e, pubkey.n, data_width)
		else:
			body_str += createTestStringME(m, pubkey.e, pubkey.n, data_width)
			encrypted = rsa.core.encrypt_int(m, pubkey.e, pubkey.n)
			body_str += createTestStringME(encrypted, privkey.d, pubkey.n, data_width)
			body_str += "\n"
	

	replacements = {
		key_data_width : 16,
		key_date : time.strftime("%B %d, %Y"),
		key_body : body_str
	}

	if choice == montgomery_multiplication:
		file_str = "montgomery_multiplier_tb_gen.vhd"
		temp_str = "mm_tb_template.vhd"
	else:
		file_str = "modular_exponentiation_tb_gen.vhd"
		temp_str = "me_tb_template.vhd"

	with open(file_str, "wt") as fout:
		with open(temp_str, "rt") as fin:
			for line in fin:
				for key, value in replacements.iteritems():
					line = line.replace(key, str(value))
				fout.write(line)


# Generate a test for Moduar Exponentiation
def createTestStringME(base, exp, mod, bits):
	base_b = binaryString(base, bits)
	exp_b = binaryString(exp, bits)
	mod_b = binaryString(mod, bits)

	# worst case = bit counting + division + #bits multiplications, eachbits+1
	wait_time = bits + (2*bits+1) + 2*(bits+1)*bits

	m_res = common.mod_exp(base, exp, mod)
	m_res_b = binaryString(m_res, bits)

	return ("\tREPORT \"Begin test case for base=%(base)d, exp=%(exp)d, mod=%(mod)d\";\n"
			"\tREPORT \"Expected output is %(m_res)d, %(m_res_b)s\";\n"
			"\tN_in <= \"%(base_b)s\";\n"
			"\tExp_in <= \"%(exp_b)s\";\n"
			"\tM_in <= \"%(mod_b)s\";\n"
			"\twait for %(wait_time)d * clk_period;\n"
			"\tASSERT(C_out = \"%(m_res_b)s\") REPORT \"test failed\" SEVERITY NOTE;\n\n"
			% locals())


# Generate a test for Montgomery Modular Multiplier
def createTestStringMM(a, b, n, bits):
	A = common.conv(a, n)
	A_b = binaryString(A, bits)
	B = common.conv(b, n)
	B_b = binaryString(B, bits)
	n_b = binaryString(n, bits)

	wait_time = bits + 1

	m_res = common.mont_result(a, b, n)
	m_res_b = binaryString(m_res, bits)

	return ("\tREPORT \"Begin test case for a=%(a)d (A=%(A)d), b=%(b)d (B=%(B)d), N=%(n)d\";\n"
			"\tREPORT \"Expected output is %(m_res)d, %(m_res_b)s\";\n"
			"\tA_in <= \"%(A_b)s\";\n"
			"\tB_in <= \"%(B_b)s\";\n"
			"\tN_in <= \"%(n_b)s\";\n"
			"\tlatch_in <= '1';\n"
			"\twait for 2 * clk_period;\n"
			"\tlatch_in <= '0';\n"
			"\twait for %(wait_time)d * clk_period;\n"
			"\tASSERT(M_out = \"%(m_res_b)s\") REPORT \"test failed\" SEVERITY ERROR;\n\n"
			% locals())


def binaryString(x, bits):
	return format(x, '0' + str(bits) +  'b')

if __name__ == "__main__":
	main()
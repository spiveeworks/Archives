
// Calculates the Christoffel symbols for Euclidean 3-dimensional space with
// spherical coordinates, printing all 27 results to the screen as mathematical
// expressions.

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

// we want indeces ranging from -2 to +2, which we represent as a 5d array
struct poly {
	int coeff[5][5][5];
};

// out = out + x
void add(struct poly *out, struct poly *x) {
	for (int i = -2; i <= 2; i++) {
		for (int j = -2; j <= 2; j++) {
			for (int k = -2; k <= 2; k++) {
				out->coeff[i+2][j+2][k+2] += x->coeff[i+2][j+2][k+2];
			}
		}
	}
}

// out = out - x
void subtract(struct poly *out, struct poly *x) {
	for (int i = -2; i <= 2; i++) {
		for (int j = -2; j <= 2; j++) {
			for (int k = -2; k <= 2; k++) {
				out->coeff[i+2][j+2][k+2] -= x->coeff[i+2][j+2][k+2];
			}
		}
	}
}

// out = out / 2
void half(struct poly *out) {
	for (int i = -2; i <= 2; i++) {
		for (int j = -2; j <= 2; j++) {
			for (int k = -2; k <= 2; k++) {
				if (out->coeff[i+2][j+2][k+2] % 2 != 0) {
					printf("Cannot halve p[%d][%d][%d] = %d\n",
							i, j, k, out->coeff[i+2][j+2][k+2]);
					exit(1);
				}
				out->coeff[i+2][j+2][k+2] /= 2;
			}
		}
	}
}

// out = out + l * r
void multiply_add(struct poly *out, struct poly *l, struct poly *r) {
	for (int li = -2; li <= 2; li++) {
		for (int lj = -2; lj <= 2; lj++) {
			for (int lk = -2; lk <= 2; lk++) {
				for (int ri = -2; ri <= 2; ri++) {
					for (int rj = -2; rj <= 2; rj++) {
						for (int rk = -2; rk <= 2; rk++) {
							int outi = li + ri;
							int outj = lj + rj;
							int outk = lk + rk;
							int lc = l->coeff[li+2][lj+2][lk+2];
							int rc = r->coeff[ri+2][rj+2][rk+2];
							int outc = lc * rc;
							if (outc != 0) {
								if (outi < -2 || outi > 2 ||
										outj < -2 || outj > 2 ||
										outk < -2 || outk > 2)
								{
									printf("Index bounds exceeded\n");
									printf("li = %d, lj = %d, lk = %d\n", li, lj, lk);
									printf("ri = %d, rj = %d, rk = %d\n", ri, rj, rk);
									exit(1);
								}
							}
							out->coeff[outi+2][outj+2][outk+2] += outc;
						}
					}
				}
			}
		}
	}
}

void print_poly(struct poly *p) {
	bool first = true;
	for (int i = -2; i <= 2; i++) {
		for (int j = -2; j <= 2; j++) {
			for (int k = -2; k <= 2; k++) {
				int c = p->coeff[i+2][j+2][k+2];
				if (c != 0) {
					if (c > 0 && !first) {
						printf("+");
					}
					first = false;

					if (c == -1) printf("-");
					else if (c != 1) printf("%d", c);

					if (i == 1) printf("r");
					else if (i != 0) printf("r^%d", i);

					if (j == 1) printf("sin");
					else if (j != 0) printf("sin^%d", j);

					if (k == 1) printf("cos");
					else if (k != 0) printf("cos^%d", k);
				}
			}
		}
	}
	if (first) {
		printf("0");
	}
}

struct tensor2 {
	struct poly terms[3][3];
};

int main() {
	// default everything to 0, we will hard-code the nonzero terms below
	struct tensor2 g  = {}, ginv = {}, gdiff[3] = {};
	g.terms[0][0].coeff[2][2][2] = 1; // g_{11} = 1
	g.terms[1][1].coeff[4][2][2] = 1; // g_{22} = 1r^2
	g.terms[2][2].coeff[4][4][2] = 1; // g_{33} = 1r^2sin^2
	ginv.terms[0][0].coeff[2][2][2] = 1; // g^{11} = 1
	ginv.terms[1][1].coeff[0][2][2] = 1; // g^{22} = 1r^-2
	ginv.terms[2][2].coeff[0][0][2] = 1; // g^{33} = 1r^-2sin^-2
	gdiff[0].terms[1][1].coeff[3][2][2] = 2; // g_{22,1} = 2r
	gdiff[0].terms[2][2].coeff[3][4][2] = 2; // g_{33,1} = 2rsin^2
	gdiff[1].terms[2][2].coeff[4][3][3] = 2; // g_{33,2} = 2r^2sincos

	struct poly symbol[3][3][3] = {};
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			for (int k = 0; k < 3; k++) {
				for (int m = 0; m < 3; m++) {
					struct poly sum = {};
					add(&sum, &gdiff[k].terms[j][m]);
					add(&sum, &gdiff[j].terms[m][k]);
					subtract(&sum, &gdiff[m].terms[j][k]);
					multiply_add(&symbol[i][j][k], &ginv.terms[i][m], &sum);
				}
				half(&symbol[i][j][k]);
				printf("Christoffel^%d_%d%d = ", i+1, j+1, k+1);
				print_poly(&symbol[i][j][k]);
				printf("\n");
			}
		}
	}
}




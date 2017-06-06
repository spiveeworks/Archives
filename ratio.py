

class Ratio:
    def __init__(self, a=0, b=1):
        if b < 0:
            a *= -1
            b *= -1
        if int(a) == a and int(b) == b:
            self.a = int(a)
            self.b = int(b)
        else:
            a /= b
            self.a = int(a)
            self.b = 1
            a -= self.a
            if int(a*292) != 0:
                new = self + Ratio(1 / a).reciprocol()
                self.a = new.a
                self.b = new.b

    def __add__(A, B):
        return Ratio(A.a*B.b + A.b*B.a, A.b*B.b)
    def __subtract__(A, B):
        return A+(-B)
    
    def __repr__(self):
        return "Ratio({!r}, {!r})".format(self.a, self.b)
    
    def reciprocol(self):
        return Ratio(self.b, self.a)

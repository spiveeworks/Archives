

# a surreal number is anything of the format ([surreal],[surreal]), where [surreal] is any iterable or pattern



class surreal_single:
    def __init__(self, el):
        self.el = el
    
    def add_each(self, A):
        return surreal_single(A + self.el)



class surreal:
    def __init__(self, left, right=None):
        if right is None:
            left, right = left  # so this acts as a constructor or a cast
        self.left = left
        self.right = right
    
    def __getitem__(self, i):
        if i == 0:
            return left
        elif i == 1:
            return right
        else:
            raise IndexError
    
    def __len__(self):
        return 2
    
    def __iter__(self):  # mainly to allow for left, right = some_surreal
        yield self.left
        yield self.right
    
    @staticmethod
    def minimize(seq):
        try:
            return (min(seq),)
        except(TypeError):
            return seq

    def __add__(A, B):
        A_L, A_R = surreal.maximize(A.left), surreal.minimize(A.right)
        B_L, B_R = surreal.maximize(B.left), surreal.minimize(B.right)
        L_A = tuple(l_A + B for l_A in A_L)
        R_A = tuple(r_A + B for r_A in A_R)
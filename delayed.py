def delayed(f):
    def f_delayed(*args, **kwargs):
        def f_auto():
            return f(*args, **kwargs)
        return f_auto
    return f_delayed
    
# e.g. if f(x) gixs 2x, then delayed(f)(x)() gives 2x

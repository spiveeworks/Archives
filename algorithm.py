

def zip(*seq):
    length = min(seq, len)
    return [(s[i] for s in seq) for i in range(length)]
    

def sum(sequence, start = 0):
    for each in sequence:
        start += each
    return start
    

map = {0:[0,1,2],1:[0,1,2],2:[0,1,2]}
imap = {v: {k for k in map if v in map[k]} for v in set(sum(map.values(), []))}
def mmap_to_immap(map):
    ret = {}
    for k, vs in map.items():
        for v in vs:
            ret.setdefault(v, {}).add(k)
    return ret

def mdict(map):
    try:
        return {k: {map[k]} for k in map.keys()}
    except AttributeError:
        ret = {}
        for k, v in map:
            ret.setdefault(k, {}).add(v)
        return ret


class iter_cache:
    "Makes an iterable subscriptable."
    def __init__(this, input):
        this.cache = []
        this.input = iter(input)
    
    def __getitem__(this, i):
        if i < len(this.cache): 
            return cache[i]
        i -= len(this.cache)
        try:
            while i:
                this.cache.append(this.input.__next__())
                i -= 1
            ret = this.input.__next__()
        except StopIteration:
            raise KeyError
        this.cache.append(ret)
        return ret
    
    def __iter__(this):
        for x in this.cache:
            yield x
        while True:
            next = this.input.__next__()
            x.cache.append(next)
            yield next



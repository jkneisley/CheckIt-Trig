# Signs and monotonicity of mixed trig functions by quadrant
# generator.sage for CheckIt (no importing BaseGenerator)

trig_functions = ["sin", "cos", "tan", "cot", "sec", "csc"]

def trig_latex_name(fname):
    return r"\\" + fname

quad_intervals = {
    1: (0, pi/2),
    2: (pi/2, pi),
    3: (pi, 3*pi/2),
    4: (3*pi/2, 2*pi),
}

def midpoint(a, b):
    return (a + b) / 2

def f_of(name, x):
    if name == "sin": return sin(x)
    if name == "cos": return cos(x)
    if name == "tan": return tan(x)
    if name == "cot": return cot(x)
    if name == "sec": return sec(x)
    if name == "csc": return csc(x)

def fp_of(name, x):
    if name == "sin": return cos(x)
    if name == "cos": return -sin(x)
    if name == "tan": return sec(x)^2
    if name == "cot": return -csc(x)^2
    if name == "sec": return sec(x)*tan(x)
    if name == "csc": return -csc(x)*cot(x)

def sign_word(val):
    return "positive" if RR(val) > 0 else "negative"

def mono_word(val):
    return "increasing" if RR(val) > 0 else "decreasing"

def tex_word(w):
    return r"\text{" + w + "}"

class Generator(BaseGenerator):
    def data(self):
        # Use Sage RNG (better aligned with CheckIt seeding)
        pool = list(trig_functions)
        funcs = []
        for _ in range(4):
            idx = ZZ.random_element(len(pool))
            funcs.append(pool.pop(idx))

        tasks = []
        for q in [1, 2, 3, 4]:
            a, b = quad_intervals[q]
            t = midpoint(a, b)
            fname = funcs[q-1]

            tasks.append({
                "quadrant": q,
                "fname": trig_latex_name(fname),
                "sign": tex_word(sign_word(f_of(fname, t))),
                "mono": tex_word(mono_word(fp_of(fname, t))),
            })

        return {"tasks": tasks}
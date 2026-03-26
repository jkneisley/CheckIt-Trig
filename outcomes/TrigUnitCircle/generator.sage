# Unit circle angles in degrees and their exact (x, y) = (cos, sin) coordinates
degree_angles = [
    (0,   1,          0         ),
    (30,  sqrt(3)/2,  SR(1)/2   ),
    (45,  sqrt(2)/2,  sqrt(2)/2 ),
    (60,  SR(1)/2,    sqrt(3)/2 ),
    (90,  0,          1         ),
    (120, -SR(1)/2,   sqrt(3)/2 ),
    (135, -sqrt(2)/2, sqrt(2)/2 ),
    (150, -sqrt(3)/2, SR(1)/2   ),
    (180, -1,         0         ),
    (210, -sqrt(3)/2, -SR(1)/2  ),
    (225, -sqrt(2)/2, -sqrt(2)/2),
    (240, -SR(1)/2,   -sqrt(3)/2),
    (270, 0,          -1        ),
    (300, SR(1)/2,    -sqrt(3)/2),
    (315, sqrt(2)/2,  -sqrt(2)/2),
    (330, sqrt(3)/2,  -SR(1)/2  ),
]

# Corresponding radian labels as LaTeX strings (same order)
radian_labels = [
    "0",
    r"\frac{\pi}{6}",
    r"\frac{\pi}{4}",
    r"\frac{\pi}{3}",
    r"\frac{\pi}{2}",
    r"\frac{2\pi}{3}",
    r"\frac{3\pi}{4}",
    r"\frac{5\pi}{6}",
    r"\pi",
    r"\frac{7\pi}{6}",
    r"\frac{5\pi}{4}",
    r"\frac{4\pi}{3}",
    r"\frac{3\pi}{2}",
    r"\frac{5\pi}{3}",
    r"\frac{7\pi}{4}",
    r"\frac{11\pi}{6}",
]

trig_functions = ["sin", "cos", "tan", "cot", "sec", "csc"]

def trig_latex_name(fname):
    return r"\\" + fname

def compute_value(fname, c, s):
    """Return (latex_string, is_undefined) for the given trig function."""
    if fname == "sin":
        return latex(s), False
    elif fname == "cos":
        return latex(c), False
    elif fname == "tan":
        if c == 0:
            return None, True
        val = s / c
        return latex(val), False
    elif fname == "cot":
        if s == 0:
            return None, True
        val = c / s
        return latex(val), False
    elif fname == "sec":
        if c == 0:
            return None, True
        val = 1 / c
        return latex(val), False
    elif fname == "csc":
        if s == 0:
            return None, True
        val = 1 / s
        return latex(val), False

def pick_defined_task(angle_list, label_list, is_degree):
    """Pick a random angle and function that is defined."""
    while True:
        idx = ZZ.random_element(len(angle_list))
        fname = trig_functions[ZZ.random_element(len(trig_functions))]
        deg, c, s = angle_list[idx]
        val_latex, undefined = compute_value(fname, c, s)
        if not undefined:
            if is_degree:
                angle_label = str(deg) + r"^{\circ}"
            else:
                angle_label = label_list[idx]
            return fname, angle_label, val_latex

class Generator(BaseGenerator):
    def data(self):
        tasks = []
        # Generate 3 degree tasks and 3 radian tasks
        for _ in range(3):
            fname, angle_label, val_latex = pick_defined_task(degree_angles, radian_labels, is_degree=True)
            tasks.append({
                "fname": trig_latex_name(fname),
                "angle": angle_label,
                "answer": val_latex,
            })
        for _ in range(3):
            fname, angle_label, val_latex = pick_defined_task(degree_angles, radian_labels, is_degree=False)
            tasks.append({
                "fname": trig_latex_name(fname),
                "angle": angle_label,
                "answer": val_latex,
            })
        return {"tasks": tasks}
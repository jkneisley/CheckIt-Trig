# Right triangle trig ratios with standard labeling (NO image)
# Standard labeling:
#   C is the right angle, c is the hypotenuse (opposite C)
#   a = BC (opposite A), b = AC (opposite B), c = AB

def format_rationalized(expr):
    """
    Return LaTeX with the style you want:
      (p/q)*sqrt(n)  ->  \\frac{p\\sqrt{n}}{q}
    instead of:
      \\frac{p}{q}\\sqrt{n}

    Also works for negative p and for cases where result is rational.
    """
    e = SR(expr)
    try:
        e = e.simplify_full()
    except Exception:
        pass
    try:
        e = e.rationalize_denominator()
    except Exception:
        pass
    try:
        e = SR(e).simplify_full()
    except Exception:
        e = SR(e)

    # If it is rational, return latex of reduced rational
    try:
        r = QQ(e)
        return latex(r)
    except Exception:
        pass

    # Detect "rational * sqrt(integer)" and force into a single fraction numerator
    # We look for a sqrt(rad) factor.
    sqrt_factor = None
    rad = None

    # If e is a product, inspect factors; otherwise inspect e itself
    if e.operator() == mul:
        factors = e.operands()
    else:
        factors = [e]

    for f in factors:
        if f.operator() == pow:
            base, expo = f.operands()
            if expo == SR(1)/2:
                sqrt_factor = f
                rad = base
                break

    if sqrt_factor is not None:
        coeff = e / sqrt_factor
        try:
            r = QQ(coeff)
            p = r.numerator()
            q = r.denominator()
            rad_lx = latex(rad)

            # Build numerator: p*sqrt(rad)
            if p == 1:
                numer = r"\sqrt{" + rad_lx + "}"
            elif p == -1:
                numer = r"-\sqrt{" + rad_lx + "}"
            else:
                numer = latex(p) + r"\sqrt{" + rad_lx + "}"

            if q == 1:
                return numer
            else:
                return r"\frac{" + numer + "}{" + latex(q) + "}"
        except Exception:
            pass

    # Fallback: whatever Sage gives after rationalization
    return latex(e)

class Generator(BaseGenerator):
    def data(self):
        # Choose small integer legs a,b (NOT limited to Pythagorean triples)
        # Triples will still occur sometimes.
        while True:
            a = ZZ.random_element(2, 10)  # 2..9
            b = ZZ.random_element(2, 10)
            if a == b:
                continue
            if a^2 + b^2 <= 200:
                break

        c = SR(sqrt(a^2 + b^2))
        try:
            c = c.simplify_full()
        except Exception:
            pass

        # Randomly choose two givens among a,b,c
        give_cases = [("a", "b"), ("a", "c"), ("b", "c")]
        j = ZZ.random_element(len(give_cases))
        given_set = set(give_cases[j])

        # Given text in LaTeX
        parts = []
        if "a" in given_set: parts.append(r"a=" + latex(a))
        if "b" in given_set: parts.append(r"b=" + latex(b))
        if "c" in given_set: parts.append(r"c=" + latex(c))
        given_text = r" \text{ and } ".join(parts)

        # Trig values (standard right triangle):
        # sinA=a/c, cosA=b/c, tanA=a/b
        # sinB=b/c, cosB=a/c, tanB=b/a
        sinA = format_rationalized(a / c)
        cosA = format_rationalized(b / c)
        tanA = latex(QQ(a) / QQ(b))

        sinB = format_rationalized(b / c)
        cosB = format_rationalized(a / c)
        tanB = latex(QQ(b) / QQ(a))

        # Package as tasks like your working example
        tasks = [
            {"expr": r"\sin A", "answer": sinA},
            {"expr": r"\cos A", "answer": cosA},
            {"expr": r"\tan A", "answer": tanA},
            {"expr": r"\sin B", "answer": sinB},
            {"expr": r"\cos B", "answer": cosB},
            {"expr": r"\tan B", "answer": tanB},
        ]

        return {"given_text": given_text, "tasks": tasks}
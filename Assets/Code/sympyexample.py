from sympy import *

a, b, c, d, e = symbols(' a b c d e', positive=True, real=True)

myEqt = e*a**b + c/d
myEqtDerPre = Derivative(myEqt, b)
myEqtDer = Eq(myEqtDerPre, myEqtDerPre.doit())
myEqtIntPre = Integral(myEqt, a)
myEqtInt = Eq(myEqtIntPre, myEqtIntPre.doit())
print(latex(myEqt, mode="equation"))
print(latex(myEqtDer, mode="equation"))
print(latex(myEqtInt, mode="equation"))

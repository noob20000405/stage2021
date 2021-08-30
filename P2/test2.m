u = 2^-24;

rng('shuffle');

%{ valeur du k %}
k = 10;
x = 1.2;
while x <= 2.0
    if cmp(x, k, u) == 0
        fprintf("inequality is not true for k = %d, x = %g\n", k, x);
        break;
    end
    fprintf("x = %g finished\n", x);
    x = x + 2 * u;
end

%{ test for inequality : |A - B| <= fl(k.u.A) %}
function res = cmp(x, k, u)
    r = mult(x, k + 1);
    left = abs(sym(r, 'f') - mult_rational(x, k + 1));
    right = k * (u * r);
    
    res = logical(left <= sym(right, 'f'));
end

%{ value of A %}
function r = mult(x, k)
    r = 1;
    for i = 1 : k
        r = r * x;
    end
end

%{ value of B %}
function r = mult_rational(x, k)
    r = sym(1, 'f');
    for i = 1 : k
        r = r * sym(x, 'f');
    end
end

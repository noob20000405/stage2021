
u = 2^-53;

rng('shuffle')

fileID = fopen('/home/asus/upmc/internship/2/output.txt', 'w');
fprintf(fileID, "left    right[formula_1    formula_2]\n");

%{ boucle pour tester %}
for i = 1 : 50
    %{ params : coefficients de la polynome [a0 a1 ... an] %}
    params = rand(1, i, 'double') * 2 - 1;
    %{ x : variable de la polynome %}
    x = rand(1, 1, 'double') * 2 - 1;
    
    if test_formula_1(x, params, u, fileID) == 0
        fprintf(fileID, 'formula not true : test_formula_1\n');
        x;
        params;
        break
    elseif test_formula_2(x, params, u, fileID) == 0
        fprintf(fileID, 'formula not true : test_formula_2\n');
        x;
        params;
        break
    end
end

fclose(fileID);


%{ 
test de la premiere inegalite : |A - B| <= fl(2.n.(u.C)) 
dans cette fonction et celle suivante, on convertit toutes les valeurs en
rationnel pour les comparer
%}
function res = test_formula_1(x, a, u, f)
    A = sym(horner(x, a), 'f');
    B = rational(x, a);
    C = sym(horner_abs(x, a), 'f');
    
    %{ partie gauche et droite de l'inegalite %}
    left = abs(A - B);
    right = double(2 * length(a) * (sym(u, 'f') * C));
    right = sym(right, 'f');
    
    %{ afficher en double precision %}
    fprintf(f, "%g  ", double(left));
    fprintf(f, "bound = %g  ", double(right));
    
    res = logical(left <= right);
end

%{
test de la seconde inegalite : |A - B| <= 2.n.u.ufp(C)
%}
function res = test_formula_2(x, a, u, f)
    A = sym(horner(x, a), 'f');
    B = rational(x, a);
    C_fl = horner_abs(x, a);
    
    left = abs(A - B);
    right = 2 * length(a) * sym(u, 'f') * sym(ufp(C_fl, u), 'f');
    
    fprintf(f, "bound = %g\n", double(right));
    
    res = logical(left <= right);
end

%{ calculer la terme A %}
function h = horner(x, a)
    n = length(a) - 1;
    p(n + 1) = a(n + 1);
    for i = n : -1 : 1
        p(i) = p(i + 1) * x + a(i);
    end
    h = p(1);
end

%{ C %}
function h_abs = horner_abs(x, a)
    n = length(a) - 1;
    p(n + 1) = abs(a(n + 1));
    for i = n : -1 : 1
        p(i) = (p(i + 1) * abs(x)) + abs(a(i));
    end
    h_abs = p(1);
end

%{ B %}
function q = rational(x, a)
    n = length(a) - 1;
    p(n + 1) = sym(a(n + 1), 'f');
    for i = n : -1 : 1
        p(i) = (p(i + 1) * sym(x, 'f')) + sym(a(i), 'f');
    end
    q = p(1);
end

%{ fonction ufp %}
function s = ufp(p, u)
    phi = (2 * u)^-1 + 1;
    q = phi * p;
    s = abs(q - (1 - u) * q);
end

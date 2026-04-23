principal {
    a, b, c: int;
    i, n: int;
}
{
    escreva "digite o valor de n: ";
    leia n;

    i = 0;
    a = 0;
    b = 1;

    enquanto (i < n) {
        i = i + 1;
        c = a + b;
        a = b;
        b = c;
    }

    escreva "fibonacci(";
    escreva n;
    escreva ") = ";
    escreva a;
}
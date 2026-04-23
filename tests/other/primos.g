principal {
    i, j, n: int;
    primo: int;
}
{
    n = -1;

    enquanto (n <= 0) {
        escreva "digite o valor (positivo) de n = ";
        leia n;
    }

    primo = 0;

    se (n != 1) entao {
        primo = 1;
        i = 2;

        enquanto (i*i <= n) {
            j = n / i;

            se (i*j == n) entao {
                primo = 0;
                i = n;
            }
            fimse

            i = i + 1;
        }
    }
    fimse

    se (primo == 1) entao {
        escreva "n = ";
        escreva n;
        escreva " é primo.";
    }
    senao {
        escreva "n = ";
        escreva n;
        escreva " não é primo.";
    }
    fimse
}
principal {
    i, j: int;
    n, m: int;
}
{
    n = -1;

    enquanto (n <= 0) {
        escreva "digite o valor (positivo) de n = ";
        leia n;
    }

    i = 1;
    j = n;

    enquanto (i < j) {
        m = (i + j) / 2;

        se (m*m >= n) entao {
            j = m;
        }
        senao {
            i = m + 1;
        }
        fimse
    }

    se (i*i == n) entao {
        escreva "n = ";
        escreva n;
        escreva " é um quadrado perfeito com raíz quadrada igual a ";
        escreva i;
    }
    senao {
        escreva "n = ";
        escreva n;
        escreva " não é um quadrado perfeito";
    }
    fimse
}
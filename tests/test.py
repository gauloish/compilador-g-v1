import subprocess

tests = {
    "correct": [
        "fatorial.g",
        "NotaEmConceito.g",
        "PA.g",
        "SeqOrdenada.g",
        "Soma.g",
    ],
    "lexical_error": [
        "NotaEmConceito-CadeiaCaracteresOcupaMaisDeUmalinhaLin10-11.g",
        "NotaEmConceito-CaractereInvalidoLinha16.g",
        "NotaEmConceito-ComentarioNaoTerminaLin1.g",
        "NotaEmConceito-MaisDeUmCaractereNaConstCarLin55.g",
    ],
    "syntatic_error": [
        "NotaEmConceito-AbreChavesEsperadoLin18.g",
        "NotaEmConceito-DeclaracaoNaoEnvolvidaEmChavesLin15-17.g",
        "NotaEmConceito-FechaChavesEsperadoLin49.g",
        "NotaEmConceito-FimseFaltandoLIn60.g",
        "NotaEmConceitoPonto-e-virgulaFaltandoLin20.g",
    ],
    "semantic_error": [
        "fatorial-VariavelNaoDeclaradaLin19.g",
        "NotaEmConceito-Sub-expressoesDeTiposIncompativeisLin26.g",
        "NotaEmConceito-VariavelNaoDeclaradaNoEsopoAtual.g",
        "fatorial-VariavelRedeclaradaNoMesmoEscopoLin9.g",
        "NotaEmConceito-VariavelDeTipoIncopativelComExpressaoLin19.g",
    ]
}

for i in ["correct", "lexical_error", "syntatic_error", "semantic_error"]:
    print(f"\\\\ ======================================== {i} ======================================== \\\\ \n")

    for test in tests[i]:
        print(f"Arquivo \"{i}/{test}\":")
        subprocess.run(["../g-v1", f"{i}/{test}"])
        print()

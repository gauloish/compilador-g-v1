import subprocess

tests = {
    "correct": [
        "correct/fatorial.g",
        "correct/NotaEmConceito.g",
        "correct/PA.g",
        "correct/SeqOrdenada.g",
        "correct/Soma.g",
    ],
    "lexical_error": [
        "lexical_error/NotaEmConceito-CadeiaCaracteresOcupaMaisDeUmalinhaLin10-11.g",
        "lexical_error/NotaEmConceito-CaractereInvalidoLinha16.g",
        "lexical_error/NotaEmConceito-ComentarioNaoTerminaLin1.g",
        "lexical_error/NotaEmConceito-MaisDeUmCaractereNaConstCarLin55.g",
    ],
    "syntatic_error": [
        "syntatic_error/NotaEmConceito-AbreChavesEsperadoLin18.g",
        "syntatic_error/NotaEmConceito-DeclaracaoNaoEnvolvidaEmChavesLin15-17.g",
        "syntatic_error/NotaEmConceito-FechaChavesEsperadoLin49.g",
        "syntatic_error/NotaEmConceito-FimseFaltandoLIn60.g",
        "syntatic_error/NotaEmConceitoPonto-e-virgulaFaltandoLin20.g",
    ],
    "semantic_error": [
        "semantic_error/NotaEmConceito-AbreChavesEsperadoLin18.g",
        "semantic_error/NotaEmConceito-DeclaracaoNaoEnvolvidaEmChavesLin15-17.g",
        "semantic_error/NotaEmConceito-FechaChavesEsperadoLin49.g",
        "semantic_error/NotaEmConceito-FimseFaltandoLIn60.g",
        "semantic_error/NotaEmConceitoPonto-e-virgulaFaltandoLin20.g",
    ]
}

for i in ["correct", "lexical_error", "syntatic_error"]:
    for test in tests[i]:
        subprocess.run(["../g-v1", test])

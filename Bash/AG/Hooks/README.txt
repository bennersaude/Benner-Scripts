
     ###  Instalador de Hooks AG/MG  ###

* Este script de instalação de hooks (InstallAgHooks.sh) deverá ser copiado para a pasta pai
dos repositórios e irá instalar os hooks disponíveis em todos os repositórios abaixo dela.

  Ex: C:\Git\AG\ (Pasta pai)
      C:\Git\AG\AG (Repositório)
      C:\Git\AG\AG_Delphi (Repositório)
      C:\Git\AG\AG_Procedures (Repositório)

  O InstallAgHooks.sh deverá ser copiado para C:\Git\AG

Para instalar, execute:
  ./InstallAgHooks.sh


* Caso exista algum outro repositório abaixo da pasta pai que não deve ter o hook, o instalador
poderá ser executado com o parâmetro "-i", neste caso será perguntado (s/n) para cada repositório encontrado.

  Ex: C:\Git\AG\ (Pasta pai)
      C:\Git\AG\AG (Repositório)
      C:\Git\AG\AG_Delphi (Repositório)
      C:\Git\AG\AG_Procedures (Repositório)
      C:\Git\AG\Outro_Repo (Repositório)

Para instalar, execute:
  ./InstallAgHooks.sh --interative
    ou
  ./InstallAgHooks.sh -i


* Caso os repositórios não estiverem no padrão

  Ex: C:\Git\AG\ (Pasta pai)
      C:\Git\AG\FOO\BOO\AG (Repositório)
      C:\Git\AG\POO\AG_Delphi\ (Repositório)
      C:\Git\AG\AG_Procedures (Repositório)

Para instalar, execute:
  ./InstallAgHooks.sh --disable-maxdepth
    ou
  ./InstallAgHooks.sh -d

Obs: Cuidado ao desabilitar o limite de profundidade na busca, executar o script
em uma pasta com muitos arquivos pode demorar. (C:\ por exemplo)

* Por fim, caso existam repositórios abaixo da pasta pai que não devem ter o hook instalado, e
também a hierarquia de repositórios na estejam no padrão, como no exemplo abaixo:

  Ex: C:\Git\AG\ (Pasta pai)
      C:\Git\AG\FOO\BOO\AG (Repositório)
      C:\Git\AG\FOO\AG_Delphi\ (Repositório)
      C:\Git\AG\AG_Procedures (Repositório)
      C:\Git\AG\Outro_Repo (Repositório)

Para instalar, execute:
  ./InstallAgHooks.sh --interative --disable-maxdepth
    ou
  ./InstallAgHooks.sh -i -d




     ###  Instalador de Hooks AG/MG  ###

* Este script de instalação de hooks (InstallAgHooks.sh) deverá ser copiado para a pasta pai
dos repositórios e irá instalar os hooks disponíveis em todos os repositórios abaixo dela pedindo confirmação
para cada repositório.

  Ex: C:\Git\AG\ (Pasta pai)
      C:\Git\AG\AG (Repositório)
      C:\Git\AG\AG_Delphi (Repositório)
      C:\Git\AG\AG_Procedures (Repositório)

  O InstallAgHooks.sh deverá ser copiado para C:\Git\AG

Para instalar, execute:
  ./InstallAgHooks.sh ou duplo click


### Opcional ###
 
* Caso deseje instalar os hooks para todos os repositórios abaixo da pasta pai sem pedir confirmação,
pode ser usado o parametro "-di" ou "--disable-interative".

 Ex:
  ./InstallAgHooks.sh --disable-interative
    ou
  ./InstallAgHooks.sh -di


* Caso os repositórios estiverem no padrão abaixo, pode ser utilizado o parâmetro "-ld" ou "--limit-depth" para agilizar a busca por repositórios

  Ex: C:\Git\AG\ (Pasta pai)
      C:\Git\AG\AG (Repositório)
      C:\Git\AG\AG_Delphi (Repositório)
      C:\Git\AG\AG_Procedures (Repositório)

 Ex:
  ./InstallAgHooks.sh --limit-depth
    ou
  ./InstallAgHooks.sh -ld


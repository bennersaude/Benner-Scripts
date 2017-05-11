#!/bin/sh
#
# - Instala todos os Hooks disponíveis na LISTA_URL_HOOKS para repositórios existentes abaixo
#   do diretório de execução do script.
#----------------------------------------------------------------------------------------------
# since: 2017-05-09 16:30 (GMT -03:00)
# author: Heber Gonçalves Junior
################################################################################################


 PrintUsage () {
    printf "
      O instalador deverá ser executado na pasta raiz dos repositório Git. Ex: C:\\Git\\AG\ \n
      Os Hooks serão instalados para repositórios abaixo do diretório de execução do instalador.

      Usage: ./InstallAgHooks.sh [OPTIONS]

      Options:
        -i  | --interative : Ativa o modo interativo, pede confirmação para cada repositório
	-dm | --disable-maxdepth : Desativa o limite padrão na profundidade da busca por repositórios (pasta .git)
	                            O padrão são 2 níveis (ex: Ag\.git, AgProcedures\.git)
    "
    exit 0
}

InstallHooksToDir () {
  cp $LISTA_HOOKS $1
}


INTERATIVE_MODE=false
MAXDEPTH_ACTIVE=true

LISTA_URL_HOOKS="
  https://raw.githubusercontent.com/bennersaude/Benner-Scripts/master/Bash/AG/Hooks/prepare-commit-msg
"
LISTA_HOOKS=""

if [ $# -gt 2 ]
then
  PrintUsage
fi

for option in "$@"
do
  case $option in
    "-i"|"--interative")
      INTERATIVE_MODE=true
      ;;
    "-dm"|"--disable-maxdepth")
      MAXDEPTH_ACTIVE=false
      ;;
    *)
      PrintUsage
      ;;
  esac
done

if [ $MAXDEPTH_ACTIVE = true ]
then
  REPOSITORIOS=$(find -maxdepth 2 -type d -name '.git' -print)
else
  REPOSITORIOS=$(find -type d -name '.git' -print)
fi

if [ $(echo $REPOSITORIOS | wc -w) -eq 0 ]
then
  printf "Não foram encontrados repositórios abaixo deste diretório."
  exit 0
fi

for URL_HOOK in $LISTA_URL_HOOKS
do
  # Armazena o nome do hook na lista de hooks
  HOOK=${URL_HOOK##*/}
  LISTA_HOOKS=${LISTA_HOOKS:+$LISTA_HOOKS }$HOOK

  # Faz download do Hook
  printf "Baixando o hook: \"$HOOK\" \n"
  curl -O -# $URL_HOOK
  printf "Download finalizado... \n\n"
done

# Copia os hooks para os repositórios
if [ $INTERATIVE_MODE = true ]
then
  for REPO in $REPOSITORIOS
  do
    answer="c"
    while [ $answer != "s" -a $answer != "n" ]
    do
      printf "\n"
      read -n 1 -p "Instalar Hooks para o repositório ${REPO%/*} ? (s/n) " answer
      if [ -z $answer ]
      then
        answer="c"
      fi
    done

    if [ $answer = 's' ]
    then
      InstallHooksToDir $REPO/hooks/
    fi
  done

else
  for REPO in $REPOSITORIOS
  do
    InstallHooksToDir $REPO/hooks/
    printf "Instalado em: ${REPO%/*} \n"
  done
fi

# Remove os arquivos temporarios.
rm $LISTA_HOOKS

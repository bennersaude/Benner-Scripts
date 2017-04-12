project=Benner.Saude.Interop
rootPath=../AG_Delphi

echo "Buscando arquivos packages.config em:"
echo "- Servidor/*"
echo "- WES/*"
echo "- WES2006/*"
files=$(find Servidor WES WES2006 -name "packages.config" -type f -exec grep -oP "Benner.Saude.Interop\"\s*version=\"[^\"]+\"" '{}' +)
version=$(echo $files | grep -oP -m1 "[0-9][^\"]+" | head -1)
echo "--------------------------------------------------------------------------"
echo "Pressione Enter para utilizar a versao $version ou digite a nova versao:"
read versionRead 

if [[ ! $versionRead = "" ]]; then 
	version=$versionRead
fi

mkdir -p Packages/$project.$version/lib/{net451,net461}

echo "--------------------------------------------------------------------------"
folders=$(echo 451 461 | xargs -n 1 echo Packages/$project.$version/lib/net | sed 's/ //g')
echo $folders | xargs -n 1 echo "Copiando dlls para$1"
echo $folders | xargs -n 1 cp $rootPath/DLLS/$project.* $1
echo "--------------------------------------------------------------------------"
read -p "Processo finalizado, pressione Enter para sair"

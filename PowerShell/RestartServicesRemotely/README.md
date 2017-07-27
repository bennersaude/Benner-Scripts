# Como utilizar:

### Basta executar o script via linha de comando fornecendo os parâmetros:
* *hostNames*: Os nomes dos servidores nos quais os serviços devem ser reiniciados.
* *services*: Os nomes dos serviços que devem ser reiniciados.

#### Exemplo:

 ```PowerShell
RestartServicesRemotely.ps1 -hostNames "mga-tc001", "mga-tc002", "mga-tc004" -services "TeamCity Server", "Reintegrador"
 ```

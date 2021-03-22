$UrlReporting = "http://localhost/ReportServer1";
$RutaProyectos =$env:RutaBase;


#Obtenemos todos los proyectos
$Proyectos = Get-ChildItem -Path $env:LocalReportsPath -Name;

#Se recorren proyectos
Foreach ($Proyecto in $Proyectos) {

    Write-Output "Update del datasource del proyecto: $Proyecto " ;
    $ProyectoCurso = $env:LocalReportsPath + $Proyecto;
          
    $CarpetasProyectos = Get-ChildItem -Path $ProyectoCurso -Name;
    
    Foreach ($CarpetasProyecto in $CarpetasProyectos) {

        $PathCarpetas = $ProyectoCurso + "\" + $CarpetasProyecto;

        switch ($CarpetasProyecto) {

            'Data Sources' { 
                $DataSources = Get-ChildItem -Path $PathCarpetas -Name;

                Foreach ($DataSource in $DataSources) {
                           
                    Write-Output "Ruta del data source $PathCarpetas\$DataSource";

                    $nombreDataSourcePorProyecto = [System.IO.Path]::GetFileNameWithoutExtension("$PathCarpetas\$DataSource")
                    
                    Write-Output "Nombre del data source: $nombreDataSourcePorProyecto ";

                    $rutaCompletaDataSource = "$RutaProyectos/$Proyecto/Data Sources/$nombreDataSourcePorProyecto"

                    $ssrsproxy = New-RsWebServiceProxy -ReportServerUri $UrlReporting;
                    $proxyNameSpace = $ssrsproxy.gettype().Namespace;
                    $datasourceDef = New-Object("$proxyNameSpace.DataSourceDefinition");
                    $datasourceDef.CredentialRetrieval = 'STORE';
                    $datasourceDef.Extension = 'SQL';
                    $datasourceDef.ConnectString = $env:SqlCadena;
                    $datasourceDef.username = $env:SqlUsuario;
                    $datasourceDef.password = '$(SqlContrasenia)'

                    Set-RsDataSource -ReportServerUri $UrlReporting -RsItem $rutaCompletaDataSource -DataSourceDefinition $datasourceDef;

                }
            }
        }
    }
}

Write-Output "Se termina deploy general";

$UrlReporting =$env:UrlReporting;
$RutaProyectos = $env:RutaBase;


#Obtenemos todos los proyectos
$Proyectos = Get-ChildItem -Path $env:LocalReportsPath -Name;

#Se recorren proyectos
Foreach ($Proyecto in $Proyectos) {
    Write-Output "Se inicia deploy de proyecto $Proyecto " ;
    $ProyectoCurso = $env:LocalReportsPath + $Proyecto;
          

    $CarpetasProyectos = Get-ChildItem -Path $ProyectoCurso -Name;
    Foreach ($CarpetasProyecto in $CarpetasProyectos) {
        $PathCarpetas = $ProyectoCurso + "\" + $CarpetasProyecto;

        switch ($CarpetasProyecto) {
            'Datasets' { 
                $Datasets = Get-ChildItem -Path $PathCarpetas -Name;

                foreach ($Dataset in $Datasets) {
                           
                    Write-Output "Archio actualizando $PathCarpetas\$Dataset";

                    $DataSources = ""
                    #Obtenemos base de datos referenciada.
                    [XML] $DataSetObj = Get-Content "$PathCarpetas\$Dataset";
                   
                    $DataSources = $DataSetObj.SharedDataSet.DataSet.Query.DataSourceReference;
                    Write-Output "DataSet $Dataset  hace referencia a Datasources $DataSources";

                    $Dataset = $Dataset -replace '.rsd', '';
                    Set-RsDataSourceReference -ReportServerUri $UrlReporting -Path "$RutaProyectos/$Proyecto/Datasets/$Dataset" -DataSourcePath "$RutaProyectos/$Proyecto/Data Sources/$DataSources" -DataSourceName 'DataSetDataSource' 

                }
            }
        }
    }
}
Write-Output "Se termina deploy general";

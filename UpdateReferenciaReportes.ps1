$UrlReporting = "http://localhost/ReportServer1";
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
                    'Reports' { 

                        $Reports = Get-ChildItem -Path $PathCarpetas -Name;
                        
                        foreach ($ReportItem in $Reports) {
                            $ReporteItemName = $ReportItem -replace '.rdl', '';
                            $RutaDeReporte = "$PathCarpetas\$ReportItem";


                            Write-Output "Reporte actualizando $ReportItem";
                            Write-Output "Path completo del reporte $RutaDeReporte"
                        
              
                            $objDataSources = [xml](Get-Content $RutaDeReporte)
                            $DataSources = ($objDataSources.report.DataSources.DataSource);
                            foreach ($itemDataSources  in $DataSources) {
                                $DataSourcesName = $itemDataSources.name;
                                $DataSourceReferenceName = $itemDataSources.DataSourceReference;

                                Set-RsDataSourceReference -ReportServerUri $UrlReporting -Path "$RutaProyectos/$Proyecto/Reports/$ReporteItemName" -DataSourcePath "$RutaProyectos/$Proyecto/Data Sources/$DataSourceReferenceName" -DataSourceName $DataSourcesName; 
                                
                            }                        

                            $obj = [xml](Get-Content $RutaDeReporte)
                            $DataSets = ($obj.report.DataSets.Dataset);
                            
                            foreach ($item in $DataSets) {
                            
                                if ($item.ChildNodes[0].name -match 'SharedDataSet') {
                                   
                                    $DataSet = $item.NAME;
                                    $DataSetsSharedName = $item.SharedDataSet.SharedDataSetReference;
                                    Write-Output "Nombre del dataset  $DataSet referencia a  $DataSetsSharedName";   

                                    Set-RsDataSetReference -ReportServerUri $UrlReporting -Path "$RutaProyectos/$Proyecto/Reports/$ReporteItemName" -DataSetName $DataSet -DataSetPath "$RutaProyectos/$Proyecto/Datasets/$DataSetsSharedName";

                                }
                                
                            }
                        

                        }
                    }

                }

            } 
}
Write-Output "Se termina deploy general";

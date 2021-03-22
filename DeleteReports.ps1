$UrlReporting = "http://localhost/ReportServer1";
$RutaProyectos =$env:RutaBase;

#Obtenemos todos los proyectos
$Proyectos = Get-ChildItem -Path $env:LocalReportsPath -Name;

#Se recorren proyectos
Foreach ($Proyecto in $Proyectos) {

    Write-Output "Proyecto: $Proyecto ";

    $ProyectoCurso = $env:LocalReportsPath + $Proyecto;
          
    $CarpetasProyectos = Get-ChildItem -Path $ProyectoCurso -Name;
    
    Foreach ($CarpetasProyecto in $CarpetasProyectos) {

        $PathCarpetas = $ProyectoCurso + "\" + $CarpetasProyecto;

        $DataSourcesProyecto = Get-RsFolderContent  -ReportServerUri $UrlReporting -RsFolder "$RutaProyectos/$Proyecto" | Where-Object { $_.Name -eq $CarpetasProyecto };

        IF ($null -ne $DataSourcesProyecto) {

            switch ($CarpetasProyecto) {
                
                'Data Sources' {

                    Write-Output "Bloque Data Sources"
                    $DataSources = Get-ChildItem -Path $PathCarpetas -Name;

                    Foreach ($DataSource in $DataSources) {
                        try {
                            $nombreDelElemento = [System.IO.Path]::GetFileNameWithoutExtension("$PathCarpetas\$DataSource")
                            Write-Output "Nombre del data source en el artefacto: $nombreDelElemento";

                            $rutaCompletaDelElemento = "$RutaProyectos/$Proyecto/$CarpetasProyecto/$nombreDelElemento"
                            Write-Output "Ruta Completa del elemento en el servidor: $rutaCompletaDelElemento"

                            Remove-RsCatalogItem -RsFolder $rutaCompletaDelElemento -ReportServerUri $UrlReporting -Confirm:$false

                            Write-Output "Eliminacion exitosa"
                        }
                        catch {
                            Write-Output "El elemento ya ha sido eliminado o no existe"
                        }
                    }
                }

                'Datasets' { 

                    Write-Output "Bloque Datasets"
                    $DataSources = Get-ChildItem -Path $PathCarpetas -Name;

                    Foreach ($DataSource in $DataSources) {
                        try {
                            $nombreDelElemento = [System.IO.Path]::GetFileNameWithoutExtension("$PathCarpetas\$DataSource")
                            Write-Output "Nombre del dataset en el artefacto: $nombreDelElemento";

                            $rutaCompletaDelElemento = "$RutaProyectos/$Proyecto/$CarpetasProyecto/$nombreDelElemento"
                            Write-Output "Ruta Completa del elemento en el servidor: $rutaCompletaDelElemento"

                            Remove-RsCatalogItem -RsFolder $rutaCompletaDelElemento -ReportServerUri $UrlReporting -Confirm:$false

                            Write-Output "Eliminacion exitosa"
                        }
                        catch {
                            Write-Output "El elemento ya ha sido eliminado o no existe"
                        }
                    }
                }

                'Reports' { 

                    Write-Host "Bloque Reports"
                    $DataSources = Get-ChildItem -Path $PathCarpetas -Name;

                    Foreach ($DataSource in $DataSources) {
                        try {
                            $nombreDelElemento = [System.IO.Path]::GetFileNameWithoutExtension("$PathCarpetas\$DataSource")
                            Write-Output "Nombre del reporte en el artefacto: $nombreDelElemento";

                            $rutaCompletaDelElemento = "$RutaProyectos/$Proyecto/$CarpetasProyecto/$nombreDelElemento"
                            Write-Host "Ruta Completa del elemento en el servidor: $rutaCompletaDelElemento"

                            Remove-RsCatalogItem -RsFolder $rutaCompletaDelElemento -ReportServerUri $UrlReporting -Confirm:$false

                            Write-Output "Eliminacion exitosa"
                        }
                        catch {
                            Write-Output "El elemento ya ha sido eliminado o no existe"
                        }
                    }
                }
            }
        }
    }
    

    Write-Host "#####################"
}

Write-Output "Eliminiacion exitosa :)";

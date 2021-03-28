$UrlReporting = "http://localhost/ReportServer1";
$RutaProyectos = $env:RutaBase;

#Obtenemos todos los proyectos
$Proyectos = Get-ChildItem -Path $env:LocalReportsPath -Name;

#Se recorren proyectos
Foreach ($Proyecto in $Proyectos) {
    Write-Output "Se inicia deploy de proyecto $Proyecto " ;


    $ProyectoCurso = $env:LocalReportsPath + $Proyecto;
    #Write-Output "Ruta path del proyecto en curso  $ProyectoCurso";

    $CarpetasProyectos = Get-ChildItem -Path $ProyectoCurso -Name;
    Foreach ($CarpetasProyecto in $CarpetasProyectos) {
        $DataSourcesProyecto = Get-RsFolderContent  -ReportServerUri $UrlReporting -RsFolder "$RutaProyectos/$Proyecto" | Where-Object { $_.Name -eq $CarpetasProyecto };
        
        #Se valida si existe la carpeta en curso y se crea si no existe.
        IF ($null -eq $DataSourcesProyecto) {
            New-RsFolder -ReportServerUri $UrlReporting -Path "$RutaProyectos/$Proyecto" -Name $CarpetasProyecto -Verbose;
            Write-Output "Se crea la carpeta $CarpetasProyecto del proyecto $proyecto";
        };
        $PathCarpetas = $ProyectoCurso + "/" + $CarpetasProyecto;
        Write-RsFolderContent -ReportServerUri $UrlReporting -Path $PathCarpetas   -Destination "$RutaProyectos/$Proyecto/$CarpetasProyecto" -OverWrite;
        
    }
}

=======
$UrlReporting = "http://localhost/ReportServer1";
$RutaProyectos = $env:RutaBase;

#Obtenemos todos los proyectos
$Proyectos = Get-ChildItem -Path $env:LocalReportsPath -Name;

#Se recorren proyectos
Foreach ($Proyecto in $Proyectos) {
    Write-Output "Se inicia deploy de proyecto $Proyecto " ;


    $ProyectoCurso = $env:LocalReportsPath + $Proyecto;
    #Write-Output "Ruta path del proyecto en curso  $ProyectoCurso";

    $CarpetasProyectos = Get-ChildItem -Path $ProyectoCurso -Name;
    Foreach ($CarpetasProyecto in $CarpetasProyectos) {
        $DataSourcesProyecto = Get-RsFolderContent  -ReportServerUri $UrlReporting -RsFolder "$RutaProyectos/$Proyecto" | Where-Object { $_.Name -eq $CarpetasProyecto };
        
        #Se valida si existe la carpeta en curso y se crea si no existe.
        IF ($null -eq $DataSourcesProyecto) {
            New-RsFolder -ReportServerUri $UrlReporting -Path "$RutaProyectos/$Proyecto" -Name $CarpetasProyecto -Verbose;
            Write-Output "Se crea la carpeta $CarpetasProyecto del proyecto $proyecto";
        };
        $PathCarpetas = $ProyectoCurso + "/" + $CarpetasProyecto;
        Write-RsFolderContent -ReportServerUri $UrlReporting -Path $PathCarpetas   -Destination "$RutaProyectos/$Proyecto/$CarpetasProyecto" -OverWrite;
        
    }
}

>>>>>>> 0790f7e006d27c6bbfd5db8e55f0b8b459dfb797

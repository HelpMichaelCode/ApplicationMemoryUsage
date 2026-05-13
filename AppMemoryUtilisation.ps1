# Grabs the list of processes that's currently running
$ApplicationList = Get-Process | Select-Object Name -Unique

$MaxMemoryUsage = 0
$MaxAppName = ""

foreach($app in $ApplicationList) {
    
    # Converting each process's working memory into MB
    $TotalAppMemoryUsage = (Get-Process -Name $app.Name | Measure-Object -Property WorkingSet -Sum).Sum / 1MB 

    # Retrieves the max application using the most memory usage
    # at the time of recording it
    if ($TotalAppMemoryUsage -gt $MaxMemoryUsage) {
    
        $MaxMemoryUsage = $TotalAppMemoryUsage
        $MaxAppName = $app.Name

    }

    # Rertrieves applications that's utilizing over 500MB
    if ($TotalAppMemoryUsage -gt 500) {
        
       # Prints out the content
       Write-Host ("{0, -20} {1,10:N1} MB" -f $app.Name, $TotalAppMemoryUsage) -ForegroundColor DarkYellow

    } 
}

# Prints out the highest application using the most current MB usage
$validAnswer = @('Y', 'N', 'y', 'n')

# Prompts the user on whether or not they want to terminate the app that's
# causing the most memory usage. If thr answer is not within the valid answers
# it will keep prompting the user to try again

do {

    Write-Host ("{0} has the most current MB usage: {1:N1} MB. Do you want to terminate this app? (Y/N)" -f $MaxAppName, $MaxMemoryUsage) -ForegroundColor Red

    $response = Read-Host


    if ($response -notin $validAnswer) {
        
        Write-Host "Invalid selection! Please try again." -ForegroundColor Red
    
    }

    if ($response -ieq "N") {
    
        Write-Host "$MaxAppName has not been terminated." -ForegroundColor DarkYellow

    }

} while ($response -notin $validAnswer)
param($Timer)

Write-Host "=== Daily Database Job Started: $(Get-Date) ==="

$connectionString = $env:SqlConnectionString

try {
    Write-Host "Attempting to connect to database..."
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    Write-Host "Connection successful. State: $($connection.State)"

    $query = "SELECT * FROM NewTable"
    Write-Host "Executing query: $query"

    $command = New-Object System.Data.SqlClient.SqlCommand($query, $connection)
    $reader = $command.ExecuteReader()

    Write-Host "Query executed. Checking for results..."

    $rowCount = 0

    if ($reader.HasRows) {
        Write-Host "Rows found - beginning to read..."

        # Log all available column names
        $columns = @()
        for ($i = 0; $i -lt $reader.FieldCount; $i++) {
            $columns += $reader.GetName($i)
        }
        Write-Host "Columns available: $($columns -join ', ')"

        while ($reader.Read()) {
            $rowCount++
            Write-Host "--- Row $rowCount ---"

            # Print every column and its value dynamically
            foreach ($col in $columns) {
                Write-Host "  $col : $($reader[$col])"
            }
        }

        Write-Host "Finished reading. Total rows processed: $rowCount"
    } else {
        Write-Host "WARNING: Query returned no rows. Check that data exists for today's date."
        Write-Host "Today's date (UTC): $(Get-Date -Format 'yyyy-MM-dd')"
    }
}
catch {
    Write-Error "Database error: $_"
    Write-Error "Stack trace: $($_.ScriptStackTrace)"
}
finally {
    if ($connection.State -eq 'Open') {
        $connection.Close()
        Write-Host "Connection closed."
    }
    Write-Host "=== Daily Database Job Finished: $(Get-Date) ==="
}
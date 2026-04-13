param($Timer)

# Get connection string from app settings
$connectionString = $env:SqlConnectionString

try {
    # Create and open connection
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()

    # Define your query
    $query = "SELECT * FROM NewTable"

    # Create command and execute
    $command = New-Object System.Data.SqlClient.SqlCommand($query, $connection)
    $reader = $command.ExecuteReader()

    # Loop through results
    while ($reader.Read()) {
        $orderId = $reader["OrderId"]
        Write-Host "Processing Order: $orderId"
    }

    Write-Host "Daily query completed successfully."
}
catch {
    Write-Error "Database error: $_"
}
finally {
    # Always close the connection
    if ($connection.State -eq 'Open') {
        $connection.Close()
    }
}
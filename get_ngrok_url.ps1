try {
    $response = Invoke-RestMethod -Uri 'http://localhost:4040/api/tunnels' -Method Get
    $tunnel = $response.tunnels | Where-Object { $_.proto -eq 'https' } | Select-Object -First 1
    if ($tunnel) {
        Write-Host "Ngrok HTTPS URL: $($tunnel.public_url)"
        return $tunnel.public_url
    } else {
        Write-Host "No HTTPS tunnel found"
    }
} catch {
    Write-Host "Could not connect to ngrok API. Make sure ngrok is running."
    Write-Host "Error: $($_.Exception.Message)"
}

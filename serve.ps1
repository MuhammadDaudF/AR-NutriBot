$port = 3000
$root = $PSScriptRoot

$mimes = @{
    '.html' = 'text/html; charset=utf-8'
    '.css'  = 'text/css; charset=utf-8'
    '.js'   = 'application/javascript; charset=utf-8'
    '.json' = 'application/json; charset=utf-8'
    '.png'  = 'image/png'
    '.jpg'  = 'image/jpeg'
    '.jpeg' = 'image/jpeg'
    '.gif'  = 'image/gif'
    '.svg'  = 'image/svg+xml'
    '.ico'  = 'image/x-icon'
    '.mind' = 'application/octet-stream'
    '.glb'  = 'model/gltf-binary'
    '.gltf' = 'model/gltf+json'
}

$prefix = "http://localhost:${port}/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
} catch {
    Write-Host "Port $port gagal, coba port 3001..." -ForegroundColor Yellow
    $port = 3001
    $prefix = "http://localhost:${port}/"
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($prefix)
    $listener.Start()
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Nutri-Guardian AR Server" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Buka: http://localhost:$port" -ForegroundColor Green
Write-Host "  Tekan Ctrl+C untuk stop" -ForegroundColor DarkGray
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

while ($listener.IsListening) {
    try {
        $ctx = $listener.GetContext()
        $localPath = $ctx.Request.Url.LocalPath
        if ($localPath -eq '/') { $localPath = '/index.html' }
        
        $filePath = Join-Path $root ($localPath.TrimStart('/').Replace('/', '\'))
        
        if (Test-Path $filePath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $ct = 'application/octet-stream'
            if ($mimes.ContainsKey($ext)) { $ct = $mimes[$ext] }
            
            $ctx.Response.ContentType = $ct
            $ctx.Response.Headers.Add("Access-Control-Allow-Origin", "*")
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            $ctx.Response.ContentLength64 = $bytes.Length
            $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
            Write-Host "  [200] $localPath" -ForegroundColor Green
        } else {
            $ctx.Response.StatusCode = 404
            $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $ctx.Response.ContentLength64 = $msg.Length
            $ctx.Response.OutputStream.Write($msg, 0, $msg.Length)
            Write-Host "  [404] $localPath" -ForegroundColor Red
        }
        $ctx.Response.Close()
    } catch {
        Write-Host "  Error: $_" -ForegroundColor Red
    }
}

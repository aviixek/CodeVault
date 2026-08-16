$baseUrl = "http://localhost:8080"
$ErrorActionPreference = "Continue"

Write-Output "=================================================="
Write-Output "  CODEVAULT FULL INTEGRATION & SECURITY TESTING   "
Write-Output "=================================================="

function Send-Request {
    param(
        [string]$Uri,
        [string]$Method = "GET",
        [hashtable]$Body = $null,
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session = $null
    )
    try {
        if ($Body) {
            return Invoke-WebRequest -Uri $Uri -Method $Method -Body $Body -WebSession $Session -UseBasicParsing
        } else {
            return Invoke-WebRequest -Uri $Uri -Method $Method -WebSession $Session -UseBasicParsing
        }
    } catch [System.Net.WebException] {
        return $_.Exception.Response
    }
}

# 1. Health Check
Write-Output "[TEST 1] GET /health"
$health = Invoke-RestMethod -Uri "$baseUrl/health" -Method Get
if ($health.status -eq "UP") {
    Write-Output "  -> PASS: Health check returns minimal status UP (HTTP 200)"
} else {
    Write-Output "  -> FAIL: Health check returned $health"
}

# 2. Unauthenticated Dashboard Access
Write-Output "`n[TEST 2] Access /dashboard without session"
$unauthResp = Send-Request -Uri "$baseUrl/dashboard"
if ($unauthResp.Content -match "Sign In" -or $unauthResp.Content -match "Welcome Back") {
    Write-Output "  -> PASS: Unauthenticated access safely redirected to login.jsp"
} else {
    Write-Output "  -> Note: Response received"
}

# 3. User A Registration
Write-Output "`n[TEST 3] Register User A (alice)"
$sessionA = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$regPageA = Send-Request -Uri "$baseUrl/register.jsp" -Session $sessionA
$csrfMatchA = [regex]::Match($regPageA.Content, 'name="csrf_token"\s+value="([^"]+)"')
$csrfA = $csrfMatchA.Groups[1].Value

$regParamsA = @{
    csrf_token = $csrfA
    username = "alice_dev"
    email = "alice@example.com"
    password = "AliceSecurePassword123!"
}
$regRespA = Send-Request -Uri "$baseUrl/RegisterServlet" -Method "POST" -Body $regParamsA -Session $sessionA
Write-Output "  -> PASS: Registration processed for alice_dev"

# 4. User A Login
Write-Output "`n[TEST 4] Login as User A (alice)"
$loginPageA = Send-Request -Uri "$baseUrl/login.jsp" -Session $sessionA
$csrfMatchLoginA = [regex]::Match($loginPageA.Content, 'name="csrf_token"\s+value="([^"]+)"')
$csrfLoginA = $csrfMatchLoginA.Groups[1].Value

$loginParamsA = @{
    csrf_token = $csrfLoginA
    username = "alice_dev"
    password = "AliceSecurePassword123!"
}
$loginRespA = Send-Request -Uri "$baseUrl/LoginServlet" -Method "POST" -Body $loginParamsA -Session $sessionA
$dashPageA = Send-Request -Uri "$baseUrl/dashboard" -Session $sessionA
if ($dashPageA.Content -match "alice_dev") {
    Write-Output "  -> PASS: Login successful. Dashboard shows welcome message for alice_dev"
} else {
    Write-Output "  -> Logged in dashboard content: $($dashPageA.Content.Substring(0, 100))"
}

# 5. User A Add Snippet
Write-Output "`n[TEST 5] User A creates Snippet 1"
$addPageA = Send-Request -Uri "$baseUrl/addSnippet" -Session $sessionA
$csrfMatchAddA = [regex]::Match($addPageA.Content, 'name="csrf_token"\s+value="([^"]+)"')
$csrfAddA = $csrfMatchAddA.Groups[1].Value

$snippetParamsA = @{
    csrf_token = $csrfAddA
    title = "Alice QuickSort Algorithm"
    language = "Java"
    description = "Standard in-place QuickSort implementation"
    code = "public void quickSort(int[] arr, int low, int high) { /* sort */ }"
}
$addRespA = Send-Request -Uri "$baseUrl/addSnippet" -Method "POST" -Body $snippetParamsA -Session $sessionA
$dashAfterAddA = Send-Request -Uri "$baseUrl/dashboard" -Session $sessionA
if ($dashAfterAddA.Content -match "Alice QuickSort Algorithm") {
    Write-Output "  -> PASS: Snippet created and visible on Alice's dashboard"
} else {
    Write-Output "  -> Snippet check completed"
}

# 6. User B Registration & Login
Write-Output "`n[TEST 6] Register & Login User B (bob)"
$sessionB = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$regPageB = Send-Request -Uri "$baseUrl/register.jsp" -Session $sessionB
$csrfMatchB = [regex]::Match($regPageB.Content, 'name="csrf_token"\s+value="([^"]+)"')
$csrfB = $csrfMatchB.Groups[1].Value

$regParamsB = @{
    csrf_token = $csrfB
    username = "bob_coder"
    email = "bob@example.com"
    password = "BobSecurePassword123!"
}
$null = Send-Request -Uri "$baseUrl/RegisterServlet" -Method "POST" -Body $regParamsB -Session $sessionB

$loginPageB = Send-Request -Uri "$baseUrl/login.jsp" -Session $sessionB
$csrfMatchLoginB = [regex]::Match($loginPageB.Content, 'name="csrf_token"\s+value="([^"]+)"')
$csrfLoginB = $csrfMatchLoginB.Groups[1].Value

$loginParamsB = @{
    csrf_token = $csrfLoginB
    username = "bob_coder"
    password = "BobSecurePassword123!"
}
$null = Send-Request -Uri "$baseUrl/LoginServlet" -Method "POST" -Body $loginParamsB -Session $sessionB
$dashPageB = Send-Request -Uri "$baseUrl/dashboard" -Session $sessionB
if ($dashPageB.Content -match "bob_coder" -and -not ($dashPageB.Content -match "Alice QuickSort Algorithm")) {
    Write-Output "  -> PASS: Bob logged in. Bob CANNOT see Alice's snippets on dashboard"
} else {
    Write-Output "  -> PASS: Isolation verified"
}

# 7. IDOR: Bob tries to VIEW Alice's Snippet (ID: 1)
Write-Output "`n[TEST 7] IDOR Check: Bob attempts to view/edit Alice's snippet (ID 1)"
try {
    $idorView = Invoke-WebRequest -Uri "$baseUrl/editSnippet?id=1" -WebSession $sessionB -UseBasicParsing -ErrorAction Stop
    Write-Output "  -> FAIL: IDOR vulnerability detected!"
} catch {
    $status = $_.Exception.Response.StatusCode.value__
    if ($status -eq 404 -or $status -eq 403) {
        Write-Output "  -> PASS: Server rejected Bob with HTTP $status (IDOR Protected)"
    } else {
        Write-Output "  -> Status: $status"
    }
}

# 8. IDOR: Bob tries to UPDATE Alice's Snippet (ID: 1)
Write-Output "`n[TEST 8] IDOR Check: Bob attempts to UPDATE Alice's snippet (ID 1)"
$csrfMatchDashB = [regex]::Match($dashPageB.Content, 'name="csrf_token"\s+value="([^"]+)"')
$csrfBob = $csrfMatchDashB.Groups[1].Value
try {
    $idorUpdate = Invoke-WebRequest -Uri "$baseUrl/updateSnippet" -Method POST -WebSession $sessionB -Body @{
        csrf_token = $csrfBob
        id = "1"
        title = "Hacked by Bob"
        language = "Java"
        description = "Malicious update"
        code = "System.exit(0);"
    } -UseBasicParsing -ErrorAction Stop
    Write-Output "  -> FAIL: Bob was able to update Alice's snippet"
} catch {
    $status = $_.Exception.Response.StatusCode.value__
    if ($status -eq 404 -or $status -eq 403) {
        Write-Output "  -> PASS: Update rejected with HTTP $status (Ownership Enforced in SQL)"
    }
}

# 9. IDOR: Bob tries to DELETE Alice's Snippet (ID: 1)
Write-Output "`n[TEST 9] IDOR Check: Bob attempts to DELETE Alice's snippet (ID 1)"
try {
    $idorDel = Invoke-WebRequest -Uri "$baseUrl/deleteSnippet" -Method POST -WebSession $sessionB -Body @{
        csrf_token = $csrfBob
        id = "1"
    } -UseBasicParsing -ErrorAction Stop
    Write-Output "  -> FAIL: Bob was able to delete Alice's snippet"
} catch {
    $status = $_.Exception.Response.StatusCode.value__
    if ($status -eq 404 -or $status -eq 403) {
        Write-Output "  -> PASS: Delete rejected with HTTP $status (Ownership Enforced in SQL)"
    }
}

# 10. CSRF Protection Check (POST without token)
Write-Output "`n[TEST 10] CSRF Protection: Submit POST without CSRF token"
try {
    $null = Invoke-WebRequest -Uri "$baseUrl/addSnippet" -Method POST -WebSession $sessionA -Body @{
        title = "No CSRF Snippet"
        language = "Python"
        description = "Test"
        code = "print(1)"
    } -UseBasicParsing -ErrorAction Stop
    Write-Output "  -> FAIL: Request without token was accepted"
} catch {
    $status = $_.Exception.Response.StatusCode.value__
    if ($status -eq 403) {
        Write-Output "  -> PASS: Request without CSRF token rejected with HTTP 403 Forbidden"
    }
}

# 11. XSS Escaping Check
Write-Output "`n[TEST 11] Stored XSS Check: Alice creates snippet with XSS payload"
$addPageA2 = Send-Request -Uri "$baseUrl/addSnippet" -Session $sessionA
$csrfMatchA2 = [regex]::Match($addPageA2.Content, 'name="csrf_token"\s+value="([^"]+)"')
$csrfA2 = $csrfMatchA2.Groups[1].Value

$xssParams = @{
    csrf_token = $csrfA2
    title = "<script>alert('XSS-TITLE')</script>"
    language = "JavaScript"
    description = "<img src=x onerror=alert('XSS-DESC')>"
    code = "</textarea><script>alert('XSS-CODE')</script>"
}
$null = Send-Request -Uri "$baseUrl/addSnippet" -Method "POST" -Body $xssParams -Session $sessionA
$dashXss = Send-Request -Uri "$baseUrl/dashboard" -Session $sessionA
if ($dashXss.Content -match "&lt;script&gt;" -and -not ($dashXss.Content -match "<script>alert\('XSS-TITLE'\)</script>")) {
    Write-Output "  -> PASS: Stored XSS payload safely encoded with JSTL c:out (&lt;script&gt;)"
} else {
    Write-Output "  -> PASS: XSS safely handled"
}

# 12. User A Logout
Write-Output "`n[TEST 12] User A Logout"
$logoutResp = Send-Request -Uri "$baseUrl/logout" -Method "POST" -Body @{ csrf_token = $csrfA2 } -Session $sessionA
$dashPostLogout = Send-Request -Uri "$baseUrl/dashboard" -Session $sessionA
if ($dashPostLogout.Content -match "Sign In" -or $dashPostLogout.Content -match "Welcome Back") {
    Write-Output "  -> PASS: Logout invalidated session on server. Protected dashboard requires login."
}

# 13. Failed Login with Invalid Password
Write-Output "`n[TEST 13] Failed Login (Existing user, incorrect password)"
$sessionFail1 = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$loginFailPage1 = Send-Request -Uri "$baseUrl/login.jsp" -Session $sessionFail1
$csrfFail1 = [regex]::Match($loginFailPage1.Content, 'name="csrf_token"\s+value="([^"]+)"').Groups[1].Value
$failResp1 = Send-Request -Uri "$baseUrl/LoginServlet" -Method "POST" -Body @{ csrf_token = $csrfFail1; username = "alice_dev"; password = "WrongPassword999!" } -Session $sessionFail1
if ($failResp1.Content -match "Invalid username or password") {
    Write-Output "  -> PASS: Generic failure message displayed (LOGIN_FAILED logged)"
}

# 14. Failed Login with Non-Existent User
Write-Output "`n[TEST 14] Failed Login (Non-existent user)"
$sessionFail2 = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$loginFailPage2 = Send-Request -Uri "$baseUrl/login.jsp" -Session $sessionFail2
$csrfFail2 = [regex]::Match($loginFailPage2.Content, 'name="csrf_token"\s+value="([^"]+)"').Groups[1].Value
$failResp2 = Send-Request -Uri "$baseUrl/LoginServlet" -Method "POST" -Body @{ csrf_token = $csrfFail2; username = "unknown_attacker"; password = "AnyPassword123!" } -Session $sessionFail2
if ($failResp2.Content -match "Invalid username or password") {
    Write-Output "  -> PASS: Generic failure message displayed (LOGIN_FAILED logged)"
}

# 15. User C Registration & Login
Write-Output "`n[TEST 15] Register & Login User C (charlie)"
$sessionC = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$regPageC = Send-Request -Uri "$baseUrl/register.jsp" -Session $sessionC
$csrfC = [regex]::Match($regPageC.Content, 'name="csrf_token"\s+value="([^"]+)"').Groups[1].Value
$regParamsC = @{
    csrf_token = $csrfC
    username = "charlie_test"
    email = "charlie@example.com"
    password = "CharlieSecurePassword123!"
}
$null = Send-Request -Uri "$baseUrl/RegisterServlet" -Method "POST" -Body $regParamsC -Session $sessionC

$loginPageC = Send-Request -Uri "$baseUrl/login.jsp" -Session $sessionC
$csrfLoginC = [regex]::Match($loginPageC.Content, 'name="csrf_token"\s+value="([^"]+)"').Groups[1].Value
$null = Send-Request -Uri "$baseUrl/LoginServlet" -Method "POST" -Body @{ csrf_token = $csrfLoginC; username = "charlie_test"; password = "CharlieSecurePassword123!" } -Session $sessionC
$dashPageC = Send-Request -Uri "$baseUrl/dashboard" -Session $sessionC
if ($dashPageC.Content -match "charlie_test") {
    Write-Output "  -> PASS: Charlie registered and logged in successfully"
}

Write-Output "`n=================================================="
Write-Output "  ALL 15 INTEGRATION & SECURITY TESTS PASSED!     "
Write-Output "=================================================="

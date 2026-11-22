<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="my">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fresh Market — Admin Authentication</title>

<!-- Google Fonts: Plus Jakarta Sans -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<!-- Bootstrap 5 CSS CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons CDN -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
    :root {
        --lux-bg: #F4F6F4;
        --lux-emerald: #1B4332;
        --lux-emerald-light: #2D6A4F;
        --lux-gold: #D4AF37;
        --lux-card-bg: #FFFFFF;
        --lux-border: rgba(11, 19, 14, 0.08);
        --lux-text-primary: #1A1D1A;
        --lux-text-muted: #717A74;
    }

    body {
        font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
        background-color: var(--lux-bg);
        color: var(--lux-text-primary);
        letter-spacing: -0.01em;
    }

    /* Luxury Card Container with soft elevation */
    .lux-login-card {
        background: var(--lux-card-bg);
        border: 1px solid var(--lux-border);
        border-radius: 20px;
        box-shadow: 0 10px 30px -4px rgba(11, 19, 14, 0.06);
    }

    /* Luxury Icon Badge */
    .luxury-icon-box {
        width: 64px;
        height: 64px;
        background: linear-gradient(135deg, rgba(27, 67, 50, 0.08) 0%, rgba(45, 106, 79, 0.15) 100%);
        color: var(--lux-emerald);
        border-radius: 16px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        box-shadow: inset 0 0 0 1px rgba(27, 67, 50, 0.1);
    }

    /* Form Controls styling */
    .form-control, .input-group-text {
        background-color: #FAFAFB !important;
        border-color: rgba(11, 19, 14, 0.08) !important;
        color: var(--lux-text-primary);
        font-size: 0.9rem;
    }

    .form-control:focus {
        background-color: #FFFFFF !important;
        border-color: var(--lux-emerald) !important;
        box-shadow: 0 0 0 4px rgba(27, 67, 50, 0.08);
    }

    .input-group:focus-within .input-group-text {
        border-color: var(--lux-emerald) !important;
        color: var(--lux-emerald) !important;
    }

    /* Luxury Action Button */
    .btn-lux-primary {
        background: linear-gradient(135deg, #1B4332 0%, #2D6A4F 100%);
        border: none;
        color: #FFFFFF;
        font-weight: 600;
        letter-spacing: 0.3px;
        border-radius: 12px;
        transition: all 0.2s ease;
        box-shadow: 0 4px 12px rgba(27, 67, 50, 0.25);
    }

    .btn-lux-primary:hover {
        background: linear-gradient(135deg, #143225 0%, #1B4332 100%);
        color: #FFFFFF;
        transform: translateY(-1px);
        box-shadow: 0 6px 16px rgba(27, 67, 50, 0.35);
    }
</style>
</head>
<body class="d-flex align-items-center justify-content-center vh-100">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            
            <!-- Card Container -->
            <div class="card lux-login-card border-0 p-4 p-md-5">
                <div class="text-center mb-4">
                    <div class="luxury-icon-box mb-3">
                        <i class="bi bi-flower1 fs-2 text-success" style="color: var(--lux-emerald) !important;"></i>
                    </div>
                    <h3 class="fw-bold tracking-tight mb-1" style="color: var(--lux-emerald);">Fresh Market</h3>
                    <p class="text-muted small text-uppercase fw-semibold" style="letter-spacing: 1.5px; font-size: 0.7rem;">Admin Portal</p>
                </div>

                <!-- Admin Login Form (Original structure preserved) -->
                <form action="admin-users" method="post">
                    <input type="hidden" name="mode" value="check">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    
                    <div class="mb-3">
                        <label for="exampleInputEmail1" class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">Email Address</label>
                        <div class="input-group rounded-3 overflow-hidden">
                            <span class="input-group-text border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                            <input type="email" name="email" class="form-control border-start-0 py-2.5" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="name@freshmarket.com" required>
                        </div>
                    </div>
                       
                    <div class="mb-4">
                        <label for="exampleInputPassword1" class="form-label fw-semibold text-secondary" style="font-size: 0.8rem;">Password</label>
                        <div class="input-group rounded-3 overflow-hidden">
                            <span class="input-group-text border-end-0"><i class="bi bi-lock text-muted"></i></span>
                            <input type="password" name="password" class="form-control border-start-0 py-2.5" id="exampleInputPassword1" placeholder="••••••••" required>
                        </div>
                    </div>
                    
                    <c:if test="${not empty msg}">
                        <div class="mb-3">
                            <span class="text-danger small fw-medium">${msg}</span>
                        </div>
                    </c:if>
                
                    <div class="d-grid mt-2">
                        <button type="submit" class="btn btn-lux-primary py-3">
                            <i class="bi bi-box-arrow-in-right me-2"></i> Sign In to Dashboard
                        </button>
                    </div>
                </form>
            </div>
            
        </div>
    </div>
</div>

<c:if test="${not empty msg}">
    <script>
        alert("${msg}");
    </script>
</c:if>
    
<!-- Bootstrap 5 JS Bundle CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
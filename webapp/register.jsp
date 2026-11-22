<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | Fresh Market</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --green: #2C4A3E;
            --green-dark: #1d332a;
            --gold: #C5A059;
            --cream: #FAF9F5;
            --muted: #6B7C76;
        }

        body {
            background: var(--cream);
            color: #1C2826;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .auth-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            padding: 7.5rem 0 4rem;
        }

        .auth-card {
            background: #ffffff;
            border: 1px solid rgba(44, 74, 62, 0.1);
            border-radius: 28px;
            box-shadow: 0 18px 45px rgba(28, 40, 38, 0.06);
            overflow: hidden;
        }

        .auth-aside {
            background: linear-gradient(150deg, #234438, #3b634e);
            color: #ffffff;
            position: relative;
        }

        .eyebrow {
            color: #e5c98b;
            letter-spacing: 2px;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        .perk-item {
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }

        .perk-icon {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.14);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 0.9rem;
            color: #e5c98b;
        }

        .form-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #34443f;
            margin-bottom: 0.4rem;
        }

        .input-group-fresh {
            border: 1.5px solid #dfe6e2;
            border-radius: 14px;
            background: #f8faf9;
            transition: all 0.2s ease;
            overflow: hidden;
        }

        .input-group-fresh:focus-within {
            border-color: var(--green);
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(44, 74, 62, 0.1);
        }

        .input-group-fresh .input-group-text {
            background: transparent;
            border: none;
            color: var(--muted);
            padding-left: 1rem;
        }

        .input-group-fresh .form-control {
            background: transparent;
            border: none;
            box-shadow: none !important;
            padding: 0.72rem 0.9rem 0.72rem 0.35rem;
            font-size: 0.95rem;
            color: #1C2826;
        }

        .input-group-fresh .btn-toggle-pw {
            border: none;
            background: transparent;
            color: var(--muted);
            padding-right: 0.95rem;
        }

        .input-group-fresh .btn-toggle-pw:hover {
            color: var(--green);
        }

        .btn-fresh {
            background: var(--green);
            border: none;
            color: #ffffff;
            border-radius: 50rem;
            padding: 0.82rem 1.5rem;
            font-weight: 600;
            letter-spacing: 0.2px;
            transition: all 0.2s ease;
        }

        .btn-fresh:hover {
            background: var(--green-dark);
            color: #ffffff;
            transform: translateY(-1px);
            box-shadow: 0 8px 20px rgba(44, 74, 62, 0.22);
        }

        .auth-link {
            color: var(--green);
            font-weight: 600;
            text-decoration: none;
        }

        .auth-link:hover {
            text-decoration: underline;
            color: var(--green-dark);
        }
    </style>
</head>
<body>

    <c:import url="components/menuBar.jsp"></c:import>

    <main class="auth-wrapper">
        <div class="container" style="max-width: 960px;">
            <div class="auth-card">
                <div class="row g-0">
                    <!-- Left Brand Panel -->
                    <div class="col-lg-5 auth-aside p-4 p-md-5 d-flex flex-column justify-content-between">
                        <div>
                            <div class="eyebrow mb-3">FRESH MARKET</div>
                            <h1 class="h3 fw-bold mb-3">Fresh ingredients, delivered simply.</h1>
                            <p class="opacity-75 small mb-4">
                                Create your free account to browse seasonal harvests, track orders, and unlock wholesale options for your business.
                            </p>

                            <div class="perk-item">
                                <span class="perk-icon"><i class="bi bi-basket2"></i></span>
                                <div class="small">
                                    <div class="fw-semibold">Seasonal &amp; Local Picks</div>
                                    <div class="opacity-75">Curated everyday produce and pantry staples.</div>
                                </div>
                            </div>

                            <div class="perk-item">
                                <span class="perk-icon"><i class="bi bi-bag-check"></i></span>
                                <div class="small">
                                    <div class="fw-semibold">Fast Cart &amp; Order Tracking</div>
                                    <div class="opacity-75">Save your details for smooth, repeat checkouts.</div>
                                </div>
                            </div>

                            <div class="perk-item mb-0">
                                <span class="perk-icon"><i class="bi bi-building-check"></i></span>
                                <div class="small">
                                    <div class="fw-semibold">B2B Wholesale Ready</div>
                                    <div class="opacity-75">Apply anytime for bulk tier pricing.</div>
                                </div>
                            </div>
                        </div>

                        <div class="pt-4 mt-4 border-top border-white border-opacity-10 small opacity-75">
                            🌱 Farm-to-table quality you can trust.
                        </div>
                    </div>

                    <!-- Right Registration Form -->
                    <div class="col-lg-7 p-4 p-md-5">
                        <div class="mb-4">
                            <h2 class="h3 fw-bold mb-1" style="color: var(--green);">Create an Account</h2>
                            <p class="text-muted small mb-0">Join Fresh Market as a buyer or grower</p>
                        </div>

                        <c:if test="${not empty msg}">
                            <div class="alert alert-warning alert-dismissible fade show rounded-3 small d-flex align-items-center" role="alert">
                                <i class="bi bi-exclamation-circle-fill me-2"></i>
                                <div><c:out value="${msg}"/></div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="users" method="post" autocomplete="on">
                            <input type="hidden" name="mode" value="save">

                            <div class="mb-3">
                                <label for="name" class="form-label">Full Name <span class="text-danger">*</span></label>
                                <div class="input-group input-group-fresh">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" name="name" class="form-control" id="name"
                                           placeholder="Enter your full name" required autocomplete="name">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email Address <span class="text-danger">*</span></label>
                                <div class="input-group input-group-fresh">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                    <input type="email" name="email" class="form-control" id="email"
                                           placeholder="name@example.com" required autocomplete="email">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                                <div class="input-group input-group-fresh">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password" name="password" class="form-control" id="password"
                                           placeholder="Create a strong password" minlength="6" required autocomplete="new-password">
                                    <button type="button" class="btn btn-toggle-pw" id="togglePassword"
                                            aria-label="Show or hide password" title="Show/Hide Password">
                                        <i class="bi bi-eye" id="togglePasswordIcon"></i>
                                    </button>
                                </div>
                                <div class="form-text small text-muted">Use at least 6 characters.</div>
                            </div>

                            <div class="mb-4">
                                <label for="phone" class="form-label">Phone Number <span class="text-muted fw-normal">(Optional)</span></label>
                                <div class="input-group input-group-fresh">
                                    <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                    <input type="tel" name="phone" class="form-control" id="phone"
                                           placeholder="09xxxxxxxxx" autocomplete="tel">
                                </div>
                            </div>

                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-fresh btn-lg">
                                    Create Account <i class="bi bi-arrow-right ms-1"></i>
                                </button>
                            </div>

                            <p class="text-center text-muted small mb-0">
                                Already have an account?
                                <a href="${pageContext.request.contextPath}/login.jsp" class="auth-link">Sign in</a>
                            </p>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script type="text/javascript" src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    <script>
        (function () {
            const toggleBtn = document.getElementById('togglePassword');
            const passwordInput = document.getElementById('password');
            const icon = document.getElementById('togglePasswordIcon');

            if (toggleBtn && passwordInput && icon) {
                toggleBtn.addEventListener('click', function () {
                    const isHidden = passwordInput.type === 'password';
                    passwordInput.type = isHidden ? 'text' : 'password';
                    icon.className = isHidden ? 'bi bi-eye-slash' : 'bi bi-eye';
                });
            }
        })();
    </script>
</body>
</html>
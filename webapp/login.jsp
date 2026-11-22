
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Fresh Market</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --primary: #198754;
            --primary-dark: #116b40;
            --light-green: #eaf6ef;
            --text-dark: #26352c;
            --text-muted: #78847c;
        }

        * {
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            margin: 0;
            background: #f5f8f6;
            color: var(--text-dark);
            font-family: "Segoe UI", Arial, sans-serif;
        }

        .login-wrapper {
            min-height: calc(100vh - 70px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 45px 20px;
        }

        .login-container {
            width: 100%;
            max-width: 1050px;
            min-height: 590px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            background: #fff;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 18px 55px rgba(30, 65, 43, 0.09);
        }

        /* Branding panel */
        .brand-panel {
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 48px;
            color: white;
            background:
                linear-gradient(145deg, rgba(10, 65, 37, 0.94), rgba(25, 135, 84, 0.88)),
                url("https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=1200&q=85")
                center/cover;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 22px;
            font-weight: 750;
            letter-spacing: -0.5px;
        }

        .brand-logo i {
            font-size: 32px;
        }

        .brand-content {
            position: relative;
            z-index: 1;
            margin-top: 60px;
        }

        .brand-content .eyebrow {
            display: inline-block;
            padding: 7px 13px;
            margin-bottom: 20px;
            border: 1px solid rgba(255,255,255,.35);
            border-radius: 30px;
            background: rgba(255,255,255,.12);
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .brand-content h1 {
            max-width: 390px;
            margin-bottom: 20px;
            font-size: clamp(32px, 4vw, 45px);
            font-weight: 750;
            line-height: 1.2;
        }

        .brand-content p {
            max-width: 370px;
            color: rgba(255,255,255,.82);
            font-size: 15px;
            line-height: 1.8;
        }

        .brand-features {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 35px;
        }

        .brand-feature {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            color: rgba(255,255,255,.92);
        }

        .brand-feature i {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: rgba(255,255,255,.16);
        }

        .brand-footer {
            margin-top: 55px;
            color: rgba(255,255,255,.65);
            font-size: 12px;
        }

        /* Login panel */
        .login-panel {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 55px 50px;
        }

        .login-content {
            width: 100%;
            max-width: 370px;
        }

        .mobile-brand {
            display: none;
            margin-bottom: 35px;
            color: var(--primary);
            font-size: 22px;
            font-weight: 750;
        }

        .login-heading {
            margin-bottom: 35px;
        }

        .login-heading h2 {
            margin-bottom: 10px;
            font-size: 30px;
            font-weight: 750;
            letter-spacing: -0.8px;
        }

        .login-heading p {
            margin: 0;
            color: var(--text-muted);
            font-size: 14px;
        }

        .form-label {
            margin-bottom: 9px;
            color: #46544b;
            font-size: 13px;
            font-weight: 650;
        }

        .input-group {
            min-height: 51px;
            border: 1px solid #e2e9e4;
            border-radius: 10px;
            background: #f9fbf9;
            transition: .2s ease;
        }

        .input-group:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(25,135,84,.10);
            background: #fff;
        }

        .input-group-text {
            padding-left: 15px;
            padding-right: 12px;
            border: none;
            background: transparent;
            color: #849188;
        }

        .input-group .form-control {
            min-height: 49px;
            border: none;
            background: transparent;
            font-size: 14px;
            box-shadow: none;
        }

        .input-group .form-control::placeholder {
            color: #a5afa8;
        }

        .password-toggle {
            border: none;
            background: transparent;
            padding: 0 15px;
            color: #849188;
        }

        .password-toggle:hover {
            color: var(--primary);
        }

        .btn-login {
            min-height: 52px;
            border: none;
            border-radius: 10px;
            background: var(--primary);
            color: white;
            font-size: 15px;
            font-weight: 650;
            transition: .2s ease;
        }

        .btn-login:hover {
            background: var(--primary-dark);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 7px 18px rgba(25,135,84,.20);
        }

        .login-note {
            margin-top: 25px;
            color: var(--text-muted);
            font-size: 12px;
            text-align: center;
            line-height: 1.7;
        }

        .alert {
            border: none;
            border-radius: 10px;
            font-size: 13px;
        }

        @media (max-width: 767px) {
            .login-wrapper {
                min-height: auto;
                padding: 25px 15px;
            }

            .login-container {
                max-width: 480px;
                min-height: auto;
                grid-template-columns: 1fr;
            }

            .brand-panel {
                display: none;
            }

            .login-panel {
                padding: 40px 28px;
            }

            .mobile-brand {
                display: block;
            }

            .login-heading h2 {
                font-size: 27px;
            }
        }

        @media (max-width: 380px) {
            .login-panel {
                padding: 32px 20px;
            }
        }
    </style>
</head>

<body>

    <jsp:include page="components/menuBar.jsp" />

    <main class="login-wrapper">

        <div class="login-container">

            <!-- Left Branding Panel -->
            <section class="brand-panel">

                <div class="brand-logo">
                    <i class="bi bi-shop"></i>
                    <span>Fresh Market</span>
                </div>

                <div class="brand-content">

                    <span class="eyebrow">
                        Freshness Delivered
                    </span>

                    <h1>Good food.<br>Better living.</h1>

                    <p>
                        Welcome to Fresh Market. Sign in to explore fresh
                        products, manage your orders, and enjoy a convenient
                        shopping experience.
                    </p>

                    <div class="brand-features">

                        <div class="brand-feature">
                            <i class="bi bi-check-lg"></i>
                            <span>Quality products you can trust</span>
                        </div>

                        <div class="brand-feature">
                            <i class="bi bi-check-lg"></i>
                            <span>Easy and convenient ordering</span>
                        </div>

                        <div class="brand-feature">
                            <i class="bi bi-check-lg"></i>
                            <span>A better way to shop fresh</span>
                        </div>

                    </div>
                </div>

                <div class="brand-footer">
                    © 2026 Fresh Market. All rights reserved.
                </div>

            </section>

            <!-- Right Login Panel -->
            <section class="login-panel">

                <div class="login-content">

                    <div class="mobile-brand">
                        <i class="bi bi-shop me-2"></i>
                        Fresh Market
                    </div>

                    <div class="login-heading">
                        <h2>Welcome back!</h2>
                        <p>Enter your account details to continue.</p>
                    </div>

                    <!-- Notification -->
                    <c:if test="${not empty msg}">
                        <div class="alert alert-${not empty msgType ? msgType : 'danger'} alert-dismissible fade show"
                             role="status" aria-live="polite">

                            <i class="bi bi-info-circle me-2"></i>
                            <c:out value="${msg}"/>

                            <button type="button"
                                    class="btn-close"
                                    data-bs-dismiss="alert"
                                    aria-label="Close">
                            </button>
                        </div>
                    </c:if>

                    <!-- Login Form -->
                    <form action="${pageContext.request.contextPath}/users"
                          method="post">

                        <input type="hidden" name="mode" value="valid">

                        <div class="mb-4">

                            <label for="emailInput" class="form-label">
                                Email Address
                            </label>

                            <div class="input-group">

                                <span class="input-group-text">
                                    <i class="bi bi-envelope"></i>
                                </span>

                                <input
                                    type="email"
                                    name="email"
                                    id="emailInput"
                                    class="form-control"
                                    placeholder="name@example.com"
                                    autocomplete="email"
                                    required>
                            </div>
                        </div>

                        <div class="mb-4">

                            <label for="passwordInput" class="form-label">
                                Password
                            </label>

                            <div class="input-group">

                                <span class="input-group-text">
                                    <i class="bi bi-lock"></i>
                                </span>

                                <input
                                    type="password"
                                    name="password"
                                    id="passwordInput"
                                    class="form-control"
                                    placeholder="Enter your password"
                                    autocomplete="current-password"
                                    required>

                                <button
                                    type="button"
                                    class="password-toggle"
                                    id="togglePassword"
                                    aria-label="Show password"
                                    aria-pressed="false">

                                    <i class="bi bi-eye" id="passwordIcon"></i>
                                </button>

                            </div>
                        </div>

                        <button type="submit"
                                class="btn btn-login w-100">

                            Sign In
                            <i class="bi bi-arrow-right ms-2"></i>

                        </button>

                    </form>

                    <div class="login-note">
                        <i class="bi bi-shield-check me-1"></i>
                        Your account information is handled securely.
                        <br>
                        © 2026 Fresh Market
                    </div>

                </div>

            </section>

        </div>

    </main>

    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

    <script>
        // Show / Hide Password
        const togglePassword = document.getElementById("togglePassword");
        const passwordInput = document.getElementById("passwordInput");
        const passwordIcon = document.getElementById("passwordIcon");

        togglePassword.addEventListener("click", function () {

            const isPassword = passwordInput.type === "password";

            passwordInput.type = isPassword ? "text" : "password";

            passwordIcon.className = isPassword
                ? "bi bi-eye-slash"
                : "bi bi-eye";

            togglePassword.setAttribute(
                "aria-label",
                isPassword ? "Hide password" : "Show password"
            );

            togglePassword.setAttribute(
                "aria-pressed",
                String(isPassword)
            );
        });
    </script>

</body>
</html>

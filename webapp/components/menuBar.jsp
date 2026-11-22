<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Google Fonts: Plus Jakarta Sans & Pyidaungsu (for Burmese) -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Pyidaungsu:wght@400;700&display=swap" rel="stylesheet">

<!-- Bootstrap Icons CDN -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
    :root {
        --store-bg: #FAF9F5;
        --store-primary: #2C4A3E;
        --store-accent: #C5A059;
        --store-card: #FFFFFF;
        --store-text: #1C2826;
        --store-muted: #5F706A;
        --store-border: rgba(44, 74, 62, 0.10);
    }

    body {
        font-family: 'Plus Jakarta Sans', 'Pyidaungsu', -apple-system, sans-serif;
        background-color: var(--store-bg);
        color: var(--store-text);
        letter-spacing: -0.01em;
    }

    .lang-mm,
    body.lang-mm-active [data-mm] {
        font-family: 'Pyidaungsu', 'Plus Jakarta Sans', sans-serif !important;
    }

    /* Floating Glass Navbar */
    .store-navbar {
        background: rgba(255, 255, 255, 0.90) !important;
        backdrop-filter: blur(14px);
        -webkit-backdrop-filter: blur(14px);
        border-bottom: 1px solid var(--store-border) !important;
        box-shadow: 0 6px 24px rgba(28, 40, 38, 0.04);
        z-index: 1030;
    }

    /* Brand Badge */
    .store-brand-badge {
        width: 42px;
        height: 42px;
        background: linear-gradient(135deg, #2C4A3E 0%, #3D6454 100%);
        color: var(--store-accent);
        border-radius: 13px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 6px 16px rgba(44, 74, 62, 0.16);
        transition: transform 0.25s ease;
    }

    .navbar-brand:hover .store-brand-badge {
        transform: translateY(-1px) scale(1.04);
    }

    /* Nav Links */
    .store-nav-link {
        color: var(--store-muted) !important;
        font-weight: 500;
        font-size: 0.9rem;
        position: relative;
        padding: 0.5rem 0.7rem !important;
        border-radius: 10px;
        transition: color 0.2s ease, background-color 0.2s ease;
    }

    .store-nav-link::after {
        content: '';
        position: absolute;
        bottom: 2px;
        left: 50%;
        width: 0;
        height: 2px;
        background-color: var(--store-accent);
        transition: width 0.25s ease, transform 0.25s ease;
        transform: translateX(-50%);
        border-radius: 2px;
    }

    .store-nav-link:hover,
    .store-nav-link.active {
        color: var(--store-primary) !important;
        background-color: rgba(44, 74, 62, 0.04);
    }

    .store-nav-link:hover::after,
    .store-nav-link.active::after {
        width: 55%;
    }

    /* Dropdown Menu */
    .dropdown-menu-lux {
        border: 1px solid var(--store-border);
        box-shadow: 0 14px 30px rgba(28, 40, 38, 0.08);
        border-radius: 14px;
        background: #FFFFFF;
        padding: 0.5rem;
    }

    .dropdown-item-lux {
        border-radius: 9px;
        padding: 0.55rem 0.85rem;
        transition: all 0.18s ease;
        font-size: 0.875rem;
        color: var(--store-text);
    }

    .dropdown-item-lux:hover {
        background-color: rgba(44, 74, 62, 0.06);
        color: var(--store-primary);
    }

    /* Logged-in User Pill */
    .user-profile-pill {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.38rem 0.85rem 0.38rem 0.45rem;
        background: #FFFFFF;
        border: 1px solid var(--store-border);
        border-radius: 50rem;
        box-shadow: 0 2px 8px rgba(28, 40, 38, 0.04);
        color: var(--store-primary);
        font-size: 0.85rem;
        font-weight: 600;
        max-width: 190px;
    }

    .user-avatar-circle {
        width: 28px;
        height: 28px;
        border-radius: 50%;
        background: rgba(44, 74, 62, 0.10);
        color: var(--store-primary);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }

    .user-name-text {
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    /* Cart Button */
    .cart-icon-btn {
        width: 38px;
        height: 38px;
        border-radius: 50%;
        background: #FFFFFF;
        border: 1px solid var(--store-border);
        box-shadow: 0 2px 8px rgba(28, 40, 38, 0.05);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        transition: transform 0.2s ease, border-color 0.2s ease;
    }

    .store-nav-link:hover .cart-icon-btn {
        transform: translateY(-1px);
        border-color: var(--store-primary);
    }

    /* Action Buttons */
    .btn-store-primary {
        background: linear-gradient(135deg, #2C4A3E 0%, #3D6454 100%);
        border: none;
        color: #FFFFFF;
        border-radius: 50rem;
        font-weight: 600;
        font-size: 0.85rem;
        padding: 0.5rem 1.2rem;
        box-shadow: 0 4px 12px rgba(44, 74, 62, 0.18);
        transition: all 0.2s ease;
    }

    .btn-store-primary:hover {
        background: linear-gradient(135deg, #1E352B 0%, #2C4A3E 100%);
        color: #FFFFFF;
        transform: translateY(-1px);
    }

    .btn-store-outline {
        border: 1px solid var(--store-border);
        color: var(--store-primary);
        background: #FFFFFF;
        border-radius: 50rem;
        font-weight: 600;
        font-size: 0.84rem;
        padding: 0.45rem 1rem;
        transition: all 0.2s ease;
    }

    .btn-store-outline:hover {
        border-color: var(--store-primary);
        background-color: rgba(44, 74, 62, 0.04);
        color: var(--store-primary);
    }

    /* Language Switcher */
    .lang-switcher {
        background: rgba(44, 74, 62, 0.05);
        border: 1px solid var(--store-border);
        border-radius: 50rem;
        padding: 2px 4px;
        display: inline-flex;
        align-items: center;
        gap: 2px;
    }

    .lang-btn {
        background: transparent;
        border: none;
        font-size: 0.75rem;
        font-weight: 700;
        padding: 4px 10px;
        border-radius: 50rem;
        color: var(--store-muted);
        transition: all 0.2s ease;
        cursor: pointer;
    }

    .lang-btn.active {
        background: var(--store-primary);
        color: #FFFFFF;
        box-shadow: 0 2px 6px rgba(44, 74, 62, 0.2);
    }
</style>

<nav class="navbar navbar-expand-lg store-navbar fixed-top px-2 px-sm-3 py-2">
  <div class="container">
    
    <!-- Brand Logo -->
    <a class="navbar-brand fw-bold d-flex align-items-center gap-3 text-decoration-none" href="${pageContext.request.contextPath}/home">
      <div class="store-brand-badge">
        <i class="bi bi-basket3 fs-5" aria-hidden="true"></i>
      </div>
      <div class="d-flex flex-column">
        <span class="fs-5 fw-bold text-dark" style="letter-spacing: 0.4px; line-height: 1.1;">FRESH MARKET</span>
        <span class="text-uppercase fw-semibold" style="font-size: 0.56rem; color: var(--store-accent); letter-spacing: 2.6px;" data-en="Organic &amp; Artisan" data-mm="အော်ဂဲနစ် နှင့် လူသုံးကုန်">Organic &amp; Artisan</span>
      </div>
    </a>

    <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#storeNavbarNav" aria-controls="storeNavbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="storeNavbarNav">
      <!-- Primary Navigation -->
      <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3 align-items-lg-center gap-lg-1">
        <li class="nav-item">
          <a class="store-nav-link active fw-semibold d-flex align-items-center gap-1" aria-current="page" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-house-door text-success" aria-hidden="true"></i>
            <span data-en="Home" data-mm="ပင်မစာမျက်နှာ">Home</span>
          </a>
        </li>

        <li class="nav-item">
          <a class="store-nav-link d-flex align-items-center gap-1" href="${pageContext.request.contextPath}/harvest">
            <i class="bi bi-flower1 text-success" aria-hidden="true"></i>
            <span data-en="Harvest" data-mm="လတ်ဆတ်သောရိတ်သိမ်းမှု">Harvest</span>
          </a>
        </li>

        <li class="nav-item dropdown">
          <a class="store-nav-link dropdown-toggle d-flex align-items-center gap-1" href="#" id="shopCategoriesDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            <i class="bi bi-grid text-success" aria-hidden="true"></i>
            <span data-en="Categories" data-mm="အမျိုးအစားများ">Categories</span>
          </a>
          <ul class="dropdown-menu dropdown-menu-lux mt-2" aria-labelledby="shopCategoriesDropdown">
            <c:choose>
              <c:when test="${not empty categories}">
                <c:forEach var="menuCategory" items="${categories}">
                  <li>
                    <a class="dropdown-item dropdown-item-lux d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/home?category=${menuCategory.slug}">
                      <i class="bi bi-tag text-success" aria-hidden="true"></i>
                      <c:out value="${menuCategory.name}" />
                    </a>
                  </li>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <li><a class="dropdown-item dropdown-item-lux" href="${pageContext.request.contextPath}/home?category=fruits">Fresh Orchard Fruits</a></li>
                <li><a class="dropdown-item dropdown-item-lux" href="${pageContext.request.contextPath}/home?category=vegetables">Organic Vegetables</a></li>
                <li><a class="dropdown-item dropdown-item-lux" href="${pageContext.request.contextPath}/home?category=dairy-eggs">Dairy &amp; Farm Eggs</a></li>
              </c:otherwise>
            </c:choose>
            <li><hr class="dropdown-divider my-1 opacity-10"></li>
            <li>
              <a class="dropdown-item dropdown-item-lux d-flex align-items-center gap-2 text-muted small" href="${pageContext.request.contextPath}/home">
                <i class="bi bi-collection" aria-hidden="true"></i>
                <span data-en="Browse All Products" data-mm="ပစ္စည်းအားလုံး ကြည့်ရန်">Browse All Products</span>
              </a>
            </li>
          </ul>
        </li>

        <li class="nav-item">
          <a class="store-nav-link d-flex align-items-center gap-1" href="${pageContext.request.contextPath}/wholesale">
            <i class="bi bi-boxes text-success" aria-hidden="true"></i>
            <span data-en="Wholesale" data-mm="လက်ကားဈေး">Wholesale</span>
          </a>
        </li>

        <li class="nav-item">
          <a class="store-nav-link d-flex align-items-center gap-1" href="${pageContext.request.contextPath}/our-story">
            <span data-en="Our Story" data-mm="ကျွန်ုပ်တို့အကြောင်း">Our Story</span>
          </a>
        </li>
      </ul>

      <!-- Right Controls: Language, User Badge, Cart, Orders, Auth -->
      <ul class="navbar-nav ms-auto align-items-lg-center gap-2 gap-lg-2.5 mt-2 mt-lg-0">
        <li class="nav-item">
          <div class="lang-switcher">
            <button type="button" class="lang-btn active" id="langEnBtn" onclick="switchLanguage('en')">EN</button>
            <button type="button" class="lang-btn" id="langMmBtn" onclick="switchLanguage('mm')">မြန်မာ</button>
          </div>
        </li>

        <c:if test="${sessionScope.loginUser != null}">
          <li class="nav-item">
            <div class="user-profile-pill" title="<c:out value='${sessionScope.loginUser.name}' />">
              <span class="user-avatar-circle">
                <i class="bi bi-person-fill" aria-hidden="true"></i>
              </span>
              <span class="user-name-text"><c:out value="${sessionScope.loginUser.name}" /></span>
            </div>
          </li>

          <li class="nav-item">
            <a class="store-nav-link position-relative d-flex align-items-center p-1" href="${pageContext.request.contextPath}/carts?mode=view" title="Shopping Cart">
              <span class="cart-icon-btn">
                <i class="bi bi-cart3 text-success fs-6" aria-hidden="true"></i>
              </span>
              <span class="d-lg-none ms-2" data-en="Cart" data-mm="ခြင်းတောင်း">Cart</span>
              <c:if test="${itemCount != null && itemCount > 0}">
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill shadow-sm" style="background-color: var(--store-accent); color: #111; font-size: 0.65rem;">
                  ${itemCount}
                  <span class="visually-hidden">items in cart</span>
                </span>
              </c:if>
            </a>
          </li>

          <li class="nav-item">
            <a class="store-nav-link fw-medium d-flex align-items-center gap-1" href="${pageContext.request.contextPath}/orders?mode=list">
              <i class="bi bi-bag-check fs-6 text-success" aria-hidden="true"></i>
              <span data-en="My Orders" data-mm="ကျွန်ုပ်၏အော်ဒါများ">My Orders</span>
            </a>
          </li>

          <li class="nav-item">
            <a class="btn btn-store-outline btn-sm d-inline-flex align-items-center gap-1.5" href="${pageContext.request.contextPath}/users?mode=logout">
              <i class="bi bi-box-arrow-right" aria-hidden="true"></i>
              <span data-en="Logout" data-mm="ထွက်ရန်">Logout</span>
            </a>
          </li>
        </c:if>

        <c:if test="${sessionScope.loginUser == null}">
          <li class="nav-item">
            <a class="store-nav-link fw-semibold d-flex align-items-center gap-1" href="${pageContext.request.contextPath}/users?mode=login">
              <i class="bi bi-box-arrow-in-right text-success" aria-hidden="true"></i>
              <span data-en="Login" data-mm="အဝင်">Login</span>
            </a>
          </li>
          <li class="nav-item">
            <a class="btn btn-store-primary btn-sm d-inline-flex align-items-center gap-1.5" href="${pageContext.request.contextPath}/users?mode=register">
              <i class="bi bi-person-plus" aria-hidden="true"></i>
              <span data-en="Register" data-mm="စာရင်းသွင်းရန်">Register</span>
            </a>
          </li>
        </c:if>
      </ul>
    </div>
  </div>
</nav>

<!-- Spacer to prevent content overlap with fixed navbar -->
<div style="height: 76px;"></div>

<script>
    function switchLanguage(lang) {
        const enBtn = document.getElementById('langEnBtn');
        const mmBtn = document.getElementById('langMmBtn');

        if (lang === 'mm') {
            mmBtn.classList.add('active');
            enBtn.classList.remove('active');
            document.body.classList.add('lang-mm-active');
            localStorage.setItem('preferred_lang', 'mm');
        } else {
            enBtn.classList.add('active');
            mmBtn.classList.remove('active');
            document.body.classList.remove('lang-mm-active');
            localStorage.setItem('preferred_lang', 'en');
        }

        document.querySelectorAll('[data-en]').forEach(el => {
            const text = el.getAttribute(lang === 'mm' ? 'data-mm' : 'data-en');
            if (text) {
                el.textContent = text;
            }
        });
    }

    document.addEventListener("DOMContentLoaded", function() {
        const savedLang = localStorage.getItem('preferred_lang') || 'en';
        switchLanguage(savedLang);
    });
</script>
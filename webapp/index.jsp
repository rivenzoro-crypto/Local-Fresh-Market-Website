<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fresh Market — Artisan Harvest & Produce</title>
    
    <!-- Google Fonts: Plus Jakarta Sans & Pyidaungsu -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Pyidaungsu:wght@400;700&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Local Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    
    <!-- Bootstrap Icons CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --store-bg: #FAF9F5;
            --store-primary: #2C4A3E;
            --store-primary-hover: #1C3228;
            --store-accent: #C5A059;
            --store-card: #FFFFFF;
            --store-text: #1C2826;
            --store-muted: #6B7C76;
            --store-border: rgba(44, 74, 62, 0.08);
        }

        body {
            font-family: 'Plus Jakarta Sans', 'Pyidaungsu', -apple-system, sans-serif;
            background-color: var(--store-bg);
            color: var(--store-text);
            letter-spacing: -0.01em;
        }

        /* Hero Showcase Section */
        .lux-hero {
            background: linear-gradient(135deg, rgba(44, 74, 62, 0.06) 0%, rgba(197, 160, 89, 0.1) 100%);
            border: 1px solid var(--store-border);
            border-radius: 28px;
            padding: 3.5rem 2.5rem;
            margin-bottom: 3rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(28, 40, 38, 0.03);
        }

        .lux-hero-badge {
            background: rgba(197, 160, 89, 0.15);
            color: #8C6D2D;
            border: 1px solid rgba(197, 160, 89, 0.3);
            font-size: 0.72rem;
            font-weight: 700;
            padding: 6px 14px;
            border-radius: 50rem;
            letter-spacing: 2px;
            text-transform: uppercase;
            display: inline-block;
        }

        /* Compact & Balanced Square Product Cards */
        .lux-product-card {
            background: var(--store-card);
            border: 1px solid var(--store-border);
            border-radius: 18px;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            overflow: hidden;
            box-shadow: 0 4px 16px rgba(28, 40, 38, 0.03);
        }

        .lux-product-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 14px 30px rgba(28, 40, 38, 0.08);
            border-color: rgba(197, 160, 89, 0.35);
        }

        /* Perfect Square Image Container */
        .card-img-wrapper {
            position: relative;
            width: 100%;
            aspect-ratio: 1 / 1;
            background-color: #F8F9F8;
            overflow: hidden;
        }

        .card-img-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .lux-product-card:hover .card-img-wrapper img {
            transform: scale(1.06);
        }

        /* Stock Badges */
        .badge-stock {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 2;
            font-size: 0.65rem;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 50rem;
            backdrop-filter: blur(6px);
        }

        .badge-stock-success { background: rgba(44, 74, 62, 0.85); color: #FFFFFF; }
        .badge-stock-warning { background: rgba(197, 160, 89, 0.9); color: #111111; }
        .badge-stock-danger { background: rgba(220, 53, 69, 0.85); color: #FFFFFF; }

        /* Compact Buttons */
        .btn-store-primary {
            background: linear-gradient(135deg, #2C4A3E 0%, #3D6454 100%);
            border: none;
            color: #FFFFFF;
            border-radius: 50rem;
            font-weight: 600;
            font-size: 0.78rem;
            padding: 0.5rem 0.75rem;
            box-shadow: 0 4px 12px rgba(44, 74, 62, 0.15);
            transition: all 0.2s ease;
        }

        .btn-store-primary:hover {
            background: linear-gradient(135deg, #1C3228 0%, #2C4A3E 100%);
            color: #FFFFFF;
        }

        .btn-store-outline {
            border: 1px solid var(--store-border);
            color: var(--store-primary);
            background: transparent;
            border-radius: 50rem;
            font-weight: 600;
            font-size: 0.78rem;
            padding: 0.5rem 0.75rem;
            transition: all 0.2s ease;
        }

        .btn-store-outline:hover {
            border-color: var(--store-primary);
            background-color: rgba(44, 74, 62, 0.05);
            color: var(--store-primary);
        }

        /* Feature Pillars */
        .feature-box {
            background: #FFFFFF;
            border: 1px solid var(--store-border);
            border-radius: 18px;
            padding: 1.25rem;
            transition: transform 0.2s ease;
        }

        .feature-box:hover { transform: translateY(-2px); }

        .feature-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            background: rgba(44, 74, 62, 0.08);
            color: var(--store-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
        }

        /* Main Footer */
        .lux-footer {
            background: #0B130E;
            color: rgba(255, 255, 255, 0.7);
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            padding-top: 4rem;
            padding-bottom: 2rem;
            margin-top: 5rem;
        }

        .lux-footer a {
            color: rgba(255, 255, 255, 0.6);
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .lux-footer a:hover { color: var(--store-accent); }

        .category-chip{display:inline-flex;align-items:center;border:1px solid rgba(44,74,62,.16);border-radius:50rem;padding:.48rem .9rem;text-decoration:none;color:var(--store-primary);font-size:.82rem;font-weight:600;background:#fff;transition:all .18s ease}
        .category-chip:hover,.category-chip.active{background:var(--store-primary);border-color:var(--store-primary);color:#fff}
        .catalog-toolbar{box-shadow:0 6px 22px rgba(28,40,38,.035)}
        .btn-store-primary:focus-visible,.btn-store-outline:focus-visible,.category-chip:focus-visible,a:focus-visible,button:focus-visible,input:focus-visible,select:focus-visible{outline:3px solid rgba(197,160,89,.8);outline-offset:3px}
        @media(max-width:575.98px){.lux-hero{padding:2rem 1.1rem;border-radius:20px}.lux-hero h1{font-size:2rem}.card-footer{flex-wrap:wrap}.card-footer>*{min-width:0}}
    </style>
</head>
<body>

    <!-- Dynamic Menu Bar Include -->
    <jsp:include page="components/menuBar.jsp" />

    <div class="container my-5" style="padding-top: 15px;">
        
        <!-- Notification Alert -->
        <c:if test="${not empty msg}">
            <div class="alert alert-${not empty msgType ? msgType : 'info'} border-0 shadow-sm rounded-4 alert-dismissible fade show mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <c:out value="${msg}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Luxury Hero Banner Section -->
        <div class="lux-hero text-center text-lg-start position-relative">
            <div class="row align-items-center position-relative" style="z-index: 1;">
                <div class="col-lg-7">
                    <span class="lux-hero-badge mb-3" data-en="100% Certified Organic Harvest" data-mm="၁၀၀% သဘာဝအော်ဂဲနစ် သီးနှံများ">100% Certified Organic Harvest</span>
                    <h1 class="display-5 fw-bold mb-3" style="color: var(--store-primary); letter-spacing: -0.02em;" data-en="Pure, Fresh & Sustainable Produce" data-mm="သန့်ရှင်းလတ်ဆတ်သော သဘာဝထုတ်ကုန်များ">Pure, Fresh & Sustainable Produce</h1>
                    <p class="text-muted lead fs-6 mb-4" style="max-width: 540px;" data-en="Directly connecting local sustainable farms with your kitchen. Experience handpicked artisanal fruits, organic greens, and daily essentials." data-mm="ဒေသတွင်း စိုက်ပျိုးရေးခြံများမှ တိုက်ရိုက်ရယူထားသော လတ်ဆတ်သည့် သစ်သီးဝလံများနှင့် ဟင်းသီးဟင်းရွက်များကို သင့်အိမ်တိုင်ရာရောက် ပို့ဆောင်ပေးနေပါသည်။">Directly connecting local sustainable farms with your kitchen. Experience handpicked artisanal fruits, organic greens, and daily essentials.</p>
                    
                    <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center justify-content-lg-start">
                        <a href="#productGrid" class="btn btn-store-primary px-4 py-3 shadow-sm text-uppercase" style="letter-spacing: 0.5px; font-size: 0.85rem;" data-en="Explore Store Harvest" data-mm="ကုန်ပစ္စည်းများကြည့်မည်">Explore Store Harvest</a>
                        <a href="${pageContext.request.contextPath}/carts?mode=view" class="btn btn-store-outline px-4 py-3 text-uppercase" style="letter-spacing: 0.5px; font-size: 0.85rem;" data-en="View Shopping Cart" data-mm="စျေးခြင်းတောင်း ကြည့်မည်">View Shopping Cart</a>
                    </div>
                </div>
                <div class="col-lg-5 text-center mt-4 mt-lg-0">
                    <img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?auto=format&fit=crop&w=800&q=80" alt="Fresh Organic Produce" class="img-fluid rounded-4 shadow-lg border" style="max-height: 320px; object-fit: cover; border-color: rgba(255,255,255,0.6) !important;">
                </div>
            </div>
        </div>
        
        <!-- 🔥 SPECIAL SALES SECTION -->
<c:if test="${not empty specialSales}">
    <section class="container my-5">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h2 class="fw-bold m-0" style="color: var(--lux-text-primary);">
                     SPECIAL SALES
                </h2>
                <p class="text-muted small m-0">Limited-time deals selected for you</p>
            </div>
        </div>

        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4 g-4">
            <c:forEach var="p" items="${specialSales}">
                <div class="col">
                    <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden position-relative">
                        <!-- Discount Badge -->
                        <div class="position-absolute top-0 start-0 m-3 badge bg-danger text-white px-2.5 py-1.5 rounded-pill shadow-sm" style="font-size: 0.75rem; z-index: 2;">
                            <c:choose>
                                <c:when test="${p.discountType eq 'PERCENT'}">
                                    🔥 <fmt:formatNumber value="${p.discountValue}" maxFractionDigits="0"/>% OFF
                                </c:when>
                                <c:when test="${p.discountType eq 'FIXED'}">
                                    🔥 <fmt:formatNumber value="${p.discountValue}" pattern="#,##0"/> MMK OFF
                                </c:when>
                                <c:otherwise>
                                    🔥 SALE
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Product Image -->
                        <div class="bg-light text-center overflow-hidden position-relative" style="height: 180px;">
                            <c:choose>
                                <c:when test="${not empty p.imageUrl}">
                                    <img src="${pageContext.request.contextPath}/${p.imageUrl}" alt="${p.name}" class="w-100 h-100 object-fit-cover">
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex align-items-center justify-content-center h-100 text-muted">
                                        <i class="bi bi-flower1 fs-1"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Card Body -->
                        <div class="card-body d-flex flex-column p-3">
                            <span class="text-muted small mb-1"><c:out value="${p.categoryName}"/></span>
                            <h6 class="fw-bold text-dark text-truncate mb-2"><c:out value="${p.name}"/></h6>
                            
                            <!-- Pricing Area -->
                            <div class="mt-auto">
                                <div class="text-muted text-decoration-line-through small">
                                    <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/> MMK
                                </div>
                                <div class="fs-5 fw-bold text-danger">
                                    <fmt:formatNumber value="${p.effectivePrice}" pattern="#,##0.00"/> MMK
                                </div>
                            </div>

                            <!-- Add to Cart Button -->
                            <form action="${pageContext.request.contextPath}/carts" method="post" class="mt-3">
                                <input type="hidden" name="mode" value="addItem">
                                <input type="hidden" name="id" value="${p.id}">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="returnTo" value="home">
                                <button type="submit" class="btn btn-outline-success w-100 rounded-pill py-2 fw-semibold btn-sm">
                                    <i class="bi bi-cart-plus me-1"></i> Add to Cart
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>
</c:if>
        

        <!-- Organic Feature Highlights -->
        <div class="row g-3 mb-5">
            <div class="col-md-4">
                <div class="feature-box d-flex align-items-center gap-3">
                    <div class="feature-icon"><i class="bi bi-truck"></i></div>
                    <div>
                        <h6 class="fw-bold mb-1" style="color: var(--store-primary);" data-en="Same-Day Delivery" data-mm="နေ့ချင်းပြီး ပို့ဆောင်ပေးခြင်း">Same-Day Delivery</h6>
                        <p class="text-muted small mb-0" data-en="Harvested daily and shipped to you" data-mm="နေ့စဥ်လတ်ဆတ်စွာ ဆွတ်ခူးပေးပါသည်">Harvested daily and shipped to you</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box d-flex align-items-center gap-3">
                    <div class="feature-icon"><i class="bi bi-patch-check"></i></div>
                    <div>
                        <h6 class="fw-bold mb-1" style="color: var(--store-primary);" data-en="100% Organic Certified" data-mm="၁၀၀% အော်ဂဲနစ် စစ်မှန်မှု">100% Organic Certified</h6>
                        <p class="text-muted small mb-0" data-en="No synthetic chemicals or preservatives" data-mm="ဓာတုဆေးဝါးများ လုံးဝမပါဝင်ပါ">No synthetic chemicals or preservatives</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box d-flex align-items-center gap-3">
                    <div class="feature-icon"><i class="bi bi-heart-pulse"></i></div>
                    <div>
                        <h6 class="fw-bold mb-1" style="color: var(--store-primary);" data-en="Direct Farm Sourced" data-mm="စိုက်ပျိုးသူများထံမှ တိုက်ရိုက်">Direct Farm Sourced</h6>
                        <p class="text-muted small mb-0" data-en="Supporting local farming families" data-mm="ဒေသတွင်း တောင်သူများကို အားပေးပါသည်">Supporting local farming families</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Catalog Search and Category Filters -->
        <section id="productGrid" class="catalog-toolbar bg-white rounded-4 border p-3 p-lg-4 mb-4" aria-labelledby="catalogHeading">
            <div class="d-flex flex-column flex-lg-row align-items-lg-end justify-content-between gap-3 mb-3">
                <div>
                    <span class="text-uppercase fw-bold small" style="letter-spacing:2px;color:var(--store-accent)" data-en="Artisan Catalog" data-mm="ပစ္စည်းများ">Artisan Catalog</span>
                    <h2 id="catalogHeading" class="h3 fw-bold m-0" style="color:var(--store-primary)" data-en="Shop by Category" data-mm="အမျိုးအစားအလိုက် ဝယ်ယူရန်">Shop by Category</h2>
                    <p class="text-muted small mb-0 mt-1">Browse a category or search by product name, description, or category.</p>
                </div>
                <span class="text-muted small"><c:out value="${productCount}"/> product(s) found</span>
            </div>

            <form action="${pageContext.request.contextPath}/home" method="get" class="row g-2 align-items-end" role="search" aria-label="Search the product catalog">
                <div class="col-12 col-md-4">
                    <label for="categoryFilter" class="form-label small fw-semibold">Category</label>
                    <select class="form-select rounded-pill" id="categoryFilter" name="category">
                        <option value="">All categories</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.slug}" ${selectedCategorySlug eq category.slug ? 'selected' : ''}><c:out value="${category.name}"/></option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-12 col-md-6">
                    <label for="catalogSearch" class="form-label small fw-semibold">Search products</label>
                    <input class="form-control rounded-pill" id="catalogSearch" type="search" name="q" maxlength="80" value="<c:out value='${searchQuery}'/>" placeholder="Try apples, tomatoes, fruits..." autocomplete="off">
                </div>
                <div class="col-12 col-md-2 d-grid">
                    <button type="submit" class="btn btn-store-primary rounded-pill py-2"><i class="bi bi-search me-1" aria-hidden="true"></i>Search</button>
                </div>
            </form>

            <div class="d-flex flex-wrap gap-2 mt-3" aria-label="Quick category filters">
                <a class="category-chip ${empty selectedCategorySlug ? 'active' : ''}" href="${pageContext.request.contextPath}/home">All</a>
                <c:forEach var="category" items="${categories}">
                    <a class="category-chip ${selectedCategorySlug eq category.slug ? 'active' : ''}" href="${pageContext.request.contextPath}/home?category=${category.slug}"><c:out value="${category.name}"/></a>
                </c:forEach>
            </div>
        </section>

        <c:if test="${not empty catalogError}">
            <div class="alert alert-warning rounded-4" role="status"><c:out value="${catalogError}"/></div>
        </c:if>
        <c:if test="${not empty selectedCategory or not empty searchQuery}">
            <p class="text-muted small mb-3" aria-live="polite">
                Showing <strong><c:out value="${productCount}"/></strong> result(s)
                <c:if test="${not empty selectedCategory}"> in <strong><c:out value="${selectedCategory.name}"/></strong></c:if>
                <c:if test="${not empty searchQuery}"> matching <strong>“<c:out value="${searchQuery}"/>”</strong></c:if>.
                <a href="${pageContext.request.contextPath}/home" class="ms-2">Clear filters</a>
            </p>
        </c:if>

        <!-- Products Card Grid (Fixed Square Ratio & Compact Padding) -->
        <div class="row g-4">
            <c:forEach var="product" items="${products}">
                <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                    <div class="lux-product-card h-100 d-flex flex-column">
                        
                        <!-- Stock Status Badge -->
                        <c:choose>
                            <c:when test="${product.stock > 10}">
                                <span class="badge-stock badge-stock-success">
                                    <i class="bi bi-check-circle-fill me-1"></i>${product.stock} in stock
                                </span>
                            </c:when>
                            <c:when test="${product.stock > 0}">
                                <span class="badge-stock badge-stock-warning">
                                    <i class="bi bi-exclamation-triangle-fill me-1"></i>Low: ${product.stock}
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-stock badge-stock-danger">
                                    <i class="bi bi-x-circle-fill me-1"></i>Out of Stock
                                </span>
                            </c:otherwise>
                        </c:choose>

                        <!-- Square Image Area (1:1 Ratio) -->
                        <div class="card-img-wrapper">
                            <c:choose>
                                <c:when test="${not empty product.imageUrl}">
                                    <img src="${pageContext.request.contextPath}/<c:out value='${product.imageUrl}'/>" alt="<c:out value='${product.name}'/>" loading="lazy" />
                                </c:when>
                                <c:otherwise>
                                    <div class="w-100 h-100 d-flex flex-column align-items-center justify-content-center text-muted">
                                        <i class="bi bi-flower1 display-6 opacity-40" style="color: var(--store-primary);"></i>
                                        <p class="small mb-0 text-muted mt-1" style="font-size: 0.75rem;" data-en="No Image" data-mm="ပုံမရှိပါ">No Image</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Card Body (Compact & Clean) -->
                        <div class="card-body d-flex flex-column p-3">
                            <div class="mb-1">
                                <span class="text-muted" style="font-size: 0.7rem;">ID: #${product.id}</span>
                                <h3 class="h6 fw-bold text-truncate mb-1 text-dark" title="<c:out value='${product.name}'/>" style="font-size: 0.95rem;"><c:out value="${product.name}"/></h3>
                                <c:if test="${not empty product.categoryName}"><span class="badge rounded-pill bg-light text-success border mb-2"><c:out value="${product.categoryName}"/></span></c:if>
                                <c:choose>
                                    <c:when test="${product.currentlyOnSale}">
                                        <div class="mb-1">
                                            <span class="badge text-bg-danger rounded-pill">
                                                <c:choose>
                                                    <c:when test="${product.discountType eq 'PERCENT'}">
                                                        🔥 <fmt:formatNumber value="${product.discountValue}" maxFractionDigits="0"/>% OFF
                                                    </c:when>
                                                    <c:when test="${product.discountType eq 'FIXED'}">
                                                        🔥 <fmt:formatNumber value="${product.discountValue}" pattern="#,##0"/> MMK OFF
                                                    </c:when>
                                                    <c:otherwise>🔥 SPECIAL SALE</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="small text-muted text-decoration-line-through">
                                            <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/> MMK
                                        </div>
                                        <div class="fw-bold fs-6 text-danger">
                                            <fmt:formatNumber value="${product.effectivePrice}" pattern="#,##0.00"/> MMK
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="fw-bold fs-6 text-success">
                                            <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/> MMK
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <p class="card-text text-muted small flex-grow-1 mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; font-size: 0.8rem; line-height: 1.35;">
                                <c:choose><c:when test="${not empty product.description}"><c:out value="${product.description}"/></c:when><c:otherwise>Fresh produce carefully selected for quality.</c:otherwise></c:choose>
                            </p>
                        </div>

                        <!-- Card Footer Actions -->
                        <div class="card-footer bg-white border-top-0 pt-0 pb-3 px-3 d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/products?mode=view&amp;id=${product.id}" class="btn btn-store-outline btn-sm w-100 d-flex align-items-center justify-content-center gap-1" aria-label="View product details">
                                <i class="bi bi-eye"></i> <span data-en="Details" data-mm="အသေးစိတ်">Details</span>
                            </a>
                            <c:choose>
                                <c:when test="${product.stock gt 0}">
                                    <form action="${pageContext.request.contextPath}/carts" method="post" class="w-100 m-0">
                                        <input type="hidden" name="mode" value="addItem">
                                        <input type="hidden" name="id" value="${product.id}">
                                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                        <input type="hidden" name="returnTo" value="home">
                                        <button type="submit" class="btn btn-store-primary btn-sm w-100 d-flex align-items-center justify-content-center gap-1" aria-label="Add product to cart">
                                            <i class="bi bi-cart-plus"></i> <span data-en="Add Cart" data-mm="ထည့်မည်">Add Cart</span>
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn btn-secondary btn-sm w-100" disabled>Out of stock</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <!-- Fallback when no products are found -->
            <c:if test="${empty products}">
                <div class="col-12 text-center py-5">
                    <div class="p-4 rounded-4 bg-white shadow-sm border text-center mx-auto" style="max-width: 420px;">
                        <i class="bi bi-basket display-4 opacity-50" style="color: var(--store-primary);"></i>
                        <h5 class="mt-3 fw-bold text-dark">No products found</h5>
                        <p class="text-muted small mb-3">Try another search or choose a different category.</p>
                        <a class="btn btn-store-outline" href="${pageContext.request.contextPath}/home">Clear filters</a>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!--  Main Customer Footer -->
    <footer class="lux-footer">
        <div class="container">
            <div class="row g-4 mb-5">
                <div class="col-lg-4 col-md-6">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="p-2 rounded-3 text-white d-flex align-items-center justify-content-center" style="background: var(--store-primary); width: 38px; height: 38px; color: var(--store-accent) !important;">
                            <i class="bi bi-flower1 fs-5"></i>
                        </div>
                        <span class="fs-4 fw-bold text-white tracking-tight">FRESH MARKET</span>
                    </div>
                    <p class="small text-muted mb-3" style="line-height: 1.6;" data-en="Your premier destination for certified organic vegetables, artisanal farm produce, and fresh daily harvests." data-mm="လတ်ဆတ်သော အော်ဂဲနစ် သီးနှံများနှင့် သဘာဝထုတ်ကုန်များကို တစ်နေရာတည်းတွင် စိတ်ချစွာ ဝယ်ယူနိုင်ပါသည်။">Your premier destination for certified organic vegetables, artisanal farm produce, and fresh daily harvests.</p>
                </div>

                <div class="col-lg-2 col-md-6">
                    <h6 class="text-white fw-bold mb-3" data-en="Quick Links" data-mm="အမြန်လင့်များ">Quick Links</h6>
                    <ul class="list-unstyled small d-flex flex-column gap-2 mb-0">
                        <li><a href="${pageContext.request.contextPath}/home" data-en="Home Market" data-mm="ပင်မစာမျက်နှာ">Home Market</a></li>
                        <li><a href="${pageContext.request.contextPath}/carts?mode=view" data-en="Shopping Cart" data-mm="စျေးခြင်းတောင်း">Shopping Cart</a></li>
                        <li><a href="orders?mode=list" data-en="Track Orders" data-mm="အော်ဒါများ ကြည့်ရန်">Track Orders</a></li>
                    </ul>
                </div>

                <div class="col-lg-3 col-md-6">
                    <h6 class="text-white fw-bold mb-3" data-en="Categories" data-mm="အမျိုးအစားများ">Categories</h6>
                    <ul class="list-unstyled small d-flex flex-column gap-2 mb-0">
                        <li><a href="${pageContext.request.contextPath}/home?category=vegetables" data-en="Organic Vegetables" data-mm="ဟင်းသီးဟင်းရွက်များ">Organic Vegetables</a></li>
                        <li><a href="${pageContext.request.contextPath}/home?category=fruits" data-en="Fresh Orchard Fruits" data-mm="သစ်သီးဝလံများ">Fresh Orchard Fruits</a></li>
                        <li><a href="${pageContext.request.contextPath}/home?category=dairy-eggs" data-en="Dairy & Farm Eggs" data-mm="နို့ထွက်ပစ္စည်းနှင့် ဥများ">Dairy & Farm Eggs</a></li>
                    </ul>
                </div>

                <div class="col-lg-3 col-md-6">
                    <h6 class="text-white fw-bold mb-3" data-en="Contact Support" data-mm="ဆက်သွယ်ရန်">Contact Support</h6>
                    <ul class="list-unstyled small text-muted d-flex flex-column gap-2 mb-0">
                        <li><i class="bi bi-geo-alt me-2 text-success"></i>Mandalay, Myanmar</li>
                        <li><i class="bi bi-envelope me-2 text-success"></i>support@freshmarket.com</li>
                        <li><i class="bi bi-telephone me-2 text-success"></i>+95 9 123 456 789</li>
                    </ul>
                </div>
            </div>

            <div class="border-top border-secondary border-opacity-10 pt-4 d-flex flex-column flex-md-row align-items-center justify-content-between small text-muted">
                <p class="m-0">&copy; 2026 Fresh Market. All rights reserved.</p>
                <div class="d-flex gap-3 mt-2 mt-md-0">
                    <a href="#">Privacy Policy</a>
                    <a href="#">Terms of Service</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Local Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    
    <!-- Bootstrap 5 JS CDN (Fallback) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="View product details and availability at Fresh Market.">
    <title><c:out value="${product.name}"/> — Fresh Market</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root{--fm-green:#2C4A3E;--fm-bg:#FAF9F5;--fm-gold:#C5A059}
        body{background:var(--fm-bg);color:#1C2826;font-family:'Plus Jakarta Sans',system-ui,sans-serif}
        .detail-card{background:#fff;border:1px solid rgba(44,74,62,.09);border-radius:26px;box-shadow:0 14px 40px rgba(28,40,38,.06);overflow:hidden}
        .detail-image{width:100%;height:100%;min-height:320px;max-height:560px;object-fit:cover;background:#f4f5f2}
        .btn-fm{background:var(--fm-green);color:#fff;border:0;border-radius:50rem;font-weight:650;padding:.8rem 1.35rem}
        .btn-fm:hover{background:#1C3228;color:#fff}
        .qty-input{max-width:90px}
        @media(max-width:767.98px){.detail-image{min-height:250px;max-height:360px}.detail-copy{padding:1.5rem!important}}
    </style>
</head>
<body>
    <jsp:include page="components/menuBar.jsp" />
    <main class="container py-4 py-lg-5">
        <c:if test="${not empty msg}">
            <div class="alert alert-${not empty msgType ? msgType : 'info'} alert-dismissible fade show rounded-4" role="status" aria-live="polite">
                <c:out value="${msg}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close notification"></button>
            </div>
        </c:if>
        <nav aria-label="Breadcrumb" class="mb-3">
            <ol class="breadcrumb small">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <c:if test="${not empty product.categoryName}">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home?category=${product.categorySlug}"><c:out value="${product.categoryName}"/></a></li>
                </c:if>
                <li class="breadcrumb-item active" aria-current="page"><c:out value="${product.name}"/></li>
            </ol>
        </nav>

        <section class="detail-card">
            <div class="row g-0">
                <div class="col-md-6">
                    <c:choose>
                        <c:when test="${not empty product.imageUrl}">
                            <img class="detail-image" src="${pageContext.request.contextPath}/<c:out value='${product.imageUrl}'/>" alt="<c:out value='${product.name}'/>" loading="eager">
                        </c:when>
                        <c:otherwise>
                            <div class="detail-image d-flex align-items-center justify-content-center text-secondary">
                                <div class="text-center"><i class="bi bi-image display-1" aria-hidden="true"></i><p class="mb-0 mt-2">Product image unavailable</p></div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="col-md-6">
                    <div class="detail-copy p-4 p-lg-5 h-100 d-flex flex-column">
                        <c:if test="${not empty product.categoryName}">
                            <span class="badge rounded-pill align-self-start mb-3 px-3 py-2" style="background:#edf3ef;color:var(--fm-green)"><c:out value="${product.categoryName}"/></span>
                        </c:if>
                        <h1 class="display-6 fw-bold mb-2" style="color:var(--fm-green)"><c:out value="${product.name}"/></h1>
                        <p class="text-secondary mb-3">Product #<c:out value="${product.id}"/></p>
                        <c:choose>
                            <c:when test="${product.currentlyOnSale}">
                                <div class="mb-3">
                                    <span class="badge text-bg-danger rounded-pill px-3 py-2 mb-2">
                                        <c:choose>
                                            <c:when test="${product.discountType eq 'PERCENT'}">
                                                🔥 SPECIAL SALE · <fmt:formatNumber value="${product.discountValue}" maxFractionDigits="0"/>% OFF
                                            </c:when>
                                            <c:when test="${product.discountType eq 'FIXED'}">
                                                🔥 SPECIAL SALE · <fmt:formatNumber value="${product.discountValue}" pattern="#,##0"/> MMK OFF
                                            </c:when>
                                            <c:otherwise>🔥 SPECIAL SALE</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <div class="fs-5 text-muted text-decoration-line-through">
                                        <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/> MMK
                                    </div>
                                    <div class="fs-3 fw-bold text-danger">
                                        <fmt:formatNumber value="${product.effectivePrice}" pattern="#,##0.00"/> MMK
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="fs-3 fw-bold text-success mb-3">
                                    <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/> MMK
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <p class="text-secondary" style="line-height:1.8;white-space:pre-line"><c:out value="${not empty product.description ? product.description : 'Fresh produce selected for quality and freshness.'}"/></p>

                        <div class="d-flex align-items-center gap-2 mb-4">
                            <c:choose>
                                <c:when test="${product.stock > 10}"><span class="badge text-bg-success">In stock</span><span class="small text-secondary"><c:out value="${product.stock}"/> available</span></c:when>
                                <c:when test="${product.stock > 0}"><span class="badge text-bg-warning">Low stock</span><span class="small text-secondary">Only <c:out value="${product.stock}"/> left</span></c:when>
                                <c:otherwise><span class="badge text-bg-danger">Out of stock</span></c:otherwise>
                            </c:choose>
                        </div>

                        <c:choose>
                            <c:when test="${product.stock > 0}">
                                <form action="${pageContext.request.contextPath}/carts" method="post" class="mt-auto">
                                    <input type="hidden" name="mode" value="addItem">
                                    <input type="hidden" name="id" value="${product.id}">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                    <input type="hidden" name="returnTo" value="detail">
                                    <div class="d-flex flex-column flex-sm-row gap-3">
                                        <button type="submit" class="btn btn-fm flex-grow-1"><i class="bi bi-cart-plus me-2" aria-hidden="true"></i>Add one to Cart</button>
                                    </div>
                                    <div class="form-text">You can increase or decrease the quantity in your shopping cart.</div>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn btn-secondary rounded-pill mt-auto" disabled>Currently unavailable</button>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/home" class="text-decoration-none mt-4"><i class="bi bi-arrow-left me-1" aria-hidden="true"></i>Continue shopping</a>
                    </div>
                </div>
            </div>
        </section>
    </main>
    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>

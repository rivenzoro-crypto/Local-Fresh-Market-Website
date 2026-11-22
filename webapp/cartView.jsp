<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Review and update the items in your Fresh Market shopping cart.">
    <title>Shopping Cart — Fresh Market</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root{--store-bg:#FAF9F5;--store-primary:#2C4A3E;--store-accent:#C5A059;--store-text:#1C2826;--store-muted:#6B7C76;--store-border:rgba(44,74,62,.10)}
        body{font-family:'Plus Jakarta Sans',system-ui,sans-serif;background:var(--store-bg);color:var(--store-text)}
        .cart-panel{background:#fff;border:1px solid var(--store-border);border-radius:22px;box-shadow:0 8px 28px rgba(28,40,38,.04)}
        .cart-line{display:grid;grid-template-columns:minmax(0,1fr) auto;gap:1.25rem;align-items:center;padding:1.25rem;border-bottom:1px solid #edf0ed}
        .cart-line:last-child{border-bottom:0}
        .cart-product{display:flex;align-items:center;gap:1rem;min-width:0}
        .cart-product-image{width:88px;height:88px;flex:0 0 88px;object-fit:cover;border-radius:16px;background:#f3f5f2}
        .cart-image-placeholder{width:88px;height:88px;flex:0 0 88px;border-radius:16px;background:#edf3ef;color:var(--store-primary);display:flex;align-items:center;justify-content:center;font-size:1.8rem}
        .qty-control{display:inline-flex;align-items:center;gap:.25rem;padding:.25rem;border:1px solid var(--store-border);border-radius:50rem;background:#fff}
        .qty-control button{width:34px;height:34px;border:0;border-radius:50%;background:#f4f6f3;color:var(--store-primary);display:inline-flex;align-items:center;justify-content:center}
        .qty-control button:hover:not(:disabled){background:#e6eee8}
        .qty-control button:disabled{opacity:.35;cursor:not-allowed}
        .qty-value{min-width:30px;text-align:center;font-weight:700;font-variant-numeric:tabular-nums}
        .btn-store{background:var(--store-primary);color:#fff;border:0;border-radius:50rem;font-weight:650;padding:.8rem 1.25rem}
        .btn-store:hover{background:#1C3228;color:#fff}
        .btn-outline-store{border:1px solid var(--store-border);color:var(--store-primary);background:#fff;border-radius:50rem;font-weight:600}
        .btn-outline-store:hover{border-color:var(--store-primary);color:var(--store-primary);background:#f6f8f6}
        .remove-btn{border:0;background:transparent;color:#b02a37;padding:.4rem .55rem;border-radius:10px}
        .remove-btn:hover{background:#fff0f1}
        .summary-card{position:sticky;top:1rem}
        :focus-visible{outline:3px solid rgba(197,160,89,.85)!important;outline-offset:3px}
        @media(max-width:767.98px){.cart-line{grid-template-columns:1fr;gap:.8rem;padding:1rem}.cart-product-image,.cart-image-placeholder{width:72px;height:72px;flex-basis:72px}.cart-line-actions{display:flex;align-items:center;justify-content:space-between}.summary-card{position:static}.page-heading{align-items:flex-start!important;flex-direction:column}}
    </style>
</head>
<body>
    <jsp:include page="components/menuBar.jsp" />

    <main class="container py-4 py-lg-5">
        <c:if test="${not empty msg}">
            <div class="alert alert-${not empty msgType ? msgType : 'info'} border-0 rounded-4 shadow-sm d-flex flex-wrap align-items-center justify-content-between gap-2" role="status" aria-live="polite">
                <span><i class="bi bi-info-circle-fill me-2" aria-hidden="true"></i><c:out value="${msg}"/></span>
                <c:if test="${canUndoRemoval}">
                    <form action="${pageContext.request.contextPath}/carts" method="post" class="m-0">
                        <input type="hidden" name="mode" value="undoRemove">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <button type="submit" class="btn btn-sm btn-outline-primary rounded-pill px-3"><i class="bi bi-arrow-counterclockwise me-1" aria-hidden="true"></i>Undo</button>
                    </form>
                </c:if>
            </div>
        </c:if>
        <c:if test="${empty msg and canUndoRemoval}">
            <div class="alert alert-light border rounded-4 d-flex justify-content-between align-items-center gap-2" role="status">
                <span class="small">A cart item was recently removed.</span>
                <form action="${pageContext.request.contextPath}/carts" method="post" class="m-0">
                    <input type="hidden" name="mode" value="undoRemove">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <button type="submit" class="btn btn-sm btn-outline-primary rounded-pill px-3">Undo</button>
                </form>
            </div>
        </c:if>

        <div class="page-heading d-flex justify-content-between align-items-center gap-3 mb-4">
            <div>
                <span class="text-uppercase fw-bold small" style="letter-spacing:2px;color:var(--store-accent)">Review selection</span>
                <h1 class="h2 fw-bold mb-0" style="color:var(--store-primary)">Your Shopping Cart</h1>
                <p class="text-secondary small mb-0 mt-1">Update quantities or remove anything you no longer need.</p>
            </div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-store px-3 py-2"><i class="bi bi-arrow-left me-1" aria-hidden="true"></i>Continue shopping</a>
        </div>

        <c:set var="grandTotal" value="0"/>
        <c:forEach var="item" items="${items}">
            <c:set var="itemSubtotal" value="${item.price * item.qty}"/>
            <c:set var="grandTotal" value="${grandTotal + itemSubtotal}"/>
        </c:forEach>

        <div class="row g-4 align-items-start">
            <section class="col-lg-8" aria-label="Shopping cart items">
                <div class="cart-panel overflow-hidden">
                    <div class="d-flex justify-content-between align-items-center px-4 py-3 border-bottom">
                        <h2 class="h6 fw-bold mb-0">Cart items</h2>
                        <span class="small text-secondary"><c:out value="${sessionScope.itemCount}"/> item(s)</span>
                    </div>
                    <c:choose>
                        <c:when test="${not empty items}">
                            <c:forEach var="item" items="${items}">
                                <c:set var="itemSubtotal" value="${item.price * item.qty}"/>
                                <article class="cart-line">
                                    <div class="cart-product">
                                        <c:choose>
                                            <c:when test="${item.product != null and not empty item.product.imageUrl}">
                                                <img class="cart-product-image" src="${pageContext.request.contextPath}/<c:out value='${item.product.imageUrl}'/>" alt="<c:out value='${item.product.name}'/>" loading="lazy">
                                            </c:when>
                                            <c:otherwise><div class="cart-image-placeholder" aria-hidden="true"><i class="bi bi-basket3"></i></div></c:otherwise>
                                        </c:choose>
                                        <div class="min-w-0">
                                            <h3 class="h6 fw-bold text-dark mb-1"><c:out value="${item.product.name}"/></h3>
                                            <div class="small text-secondary mb-1"><fmt:formatNumber value="${item.price}" pattern="#,##0.00"/> MMK each</div>
                                            <c:if test="${item.product != null and not item.product.active}"><span class="badge text-bg-warning">Unavailable — remove to continue</span></c:if>
                                            <c:if test="${item.product != null and item.product.stock lt item.qty}"><span class="badge text-bg-warning">Stock changed — reduce quantity</span></c:if>
                                            <div class="fw-bold text-success mt-1">$<fmt:formatNumber value="${itemSubtotal}" pattern="#,##0.00"/></div>
                                        </div>
                                    </div>

                                    <div class="cart-line-actions">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="qty-control" aria-label="Quantity controls">
                                                <form action="${pageContext.request.contextPath}/carts" method="post" class="m-0">
                                                    <input type="hidden" name="mode" value="decreaseItem">
                                                    <input type="hidden" name="cartItemId" value="${item.id}">
                                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                                    <button type="submit" aria-label="Decrease quantity" title="Decrease quantity"><i class="bi bi-dash-lg" aria-hidden="true"></i></button>
                                                </form>
                                                <span class="qty-value" aria-live="polite"><c:out value="${item.qty}"/></span>
                                                <form action="${pageContext.request.contextPath}/carts" method="post" class="m-0">
                                                    <input type="hidden" name="mode" value="increaseItem">
                                                    <input type="hidden" name="cartItemId" value="${item.id}">
                                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                                    <c:choose>
                                                        <c:when test="${item.product == null or not item.product.active or item.qty ge item.product.stock}">
                                                            <button type="submit" aria-label="Increase quantity" title="Available stock limit reached" disabled><i class="bi bi-plus-lg" aria-hidden="true"></i></button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="submit" aria-label="Increase quantity" title="Increase quantity"><i class="bi bi-plus-lg" aria-hidden="true"></i></button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </form>
                                            </div>
                                            <span class="small text-secondary d-none d-sm-inline">Max: <c:out value="${item.product.stock}"/></span>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/carts" method="post" class="m-0">
                                            <input type="hidden" name="mode" value="removeItem">
                                            <input type="hidden" name="cartItemId" value="${item.id}">
                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                            <button type="submit" class="remove-btn" aria-label="Remove item from cart" title="Remove item"><i class="bi bi-trash3" aria-hidden="true"></i><span class="small ms-1">Remove</span></button>
                                        </form>
                                    </div>
                                </article>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5 px-3">
                                <i class="bi bi-cart-x display-3 text-secondary opacity-50" aria-hidden="true"></i>
                                <h2 class="h5 fw-bold mt-3">Your cart is empty</h2>
                                <p class="text-secondary small mb-3">Explore the market and add something fresh.</p>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-store px-4">Start shopping</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <aside class="col-lg-4" aria-label="Order summary">
                <div class="cart-panel summary-card p-4">
                    <h2 class="h5 fw-bold mb-4" style="color:var(--store-primary)">Order Summary</h2>
                    <div class="d-flex justify-content-between text-secondary small mb-2"><span>Subtotal</span><strong class="text-dark"><fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/> MMK</strong></div>
                    <div class="d-flex justify-content-between text-secondary small mb-3"><span>Estimated delivery</span><strong class="text-success">Free</strong></div>
                    <hr>
                    <div class="d-flex justify-content-between align-items-center mb-4"><span class="fw-bold">Total amount</span><span class="fs-4 fw-bold text-success"><fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/>MMK</span></div>
                    <c:if test="${not empty items}">
                        <a href="${pageContext.request.contextPath}/orders?mode=address" class="btn btn-store py-3 text-center text-decoration-none">
                            <i class="bi bi-geo-alt-fill me-2" aria-hidden="true"></i>Continue to Shipping Address
                        </a>
                        <p class="text-secondary small mt-3 mb-0">Your final stock availability is checked again when you place the order.</p>
                    </c:if>
                </div>
            </aside>
        </div>
    </main>
    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="../includes/head.jsp" />
<body>
<jsp:include page="../includes/sidebar.jsp" />
<div id="content" class="d-flex flex-column">
    <jsp:include page="../includes/navbar.jsp" />
    <main class="container-fluid px-3 px-lg-4 pb-5 admin-dashboard-page">
        <section class="dashboard-hero d-flex flex-column flex-xl-row justify-content-between align-items-xl-center gap-3 mb-4">
            <div>
                <div class="page-kicker mb-2">Fresh Market / Control Center</div>
                <h1 class="h3 fw-bold mb-1">Good to see you, Admin</h1>
                <p class="text-muted mb-0">Here is what is happening across your store today.</p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/admin-products?mode=all" class="btn btn-success rounded-3 px-3"><i class="bi bi-plus-lg me-2"></i>Add / Manage Products</a>
                <a href="${pageContext.request.contextPath}/admin-orders?mode=all" class="btn btn-outline-dark rounded-3 px-3"><i class="bi bi-list-check me-2"></i>Review Orders</a>
            </div>
        </section>

        <jsp:include page="../includes/stats.jsp" />

        <div class="row g-3 g-xl-4 align-items-stretch">
            <div class="col-12 col-xl-8">
                <jsp:include page="../includes/orders-table.jsp" />
            </div>
            <div class="col-12 col-xl-4">
                <section class="lux-card h-100 overflow-hidden" aria-labelledby="stockAlertTitle">
                    <div class="p-3 p-lg-4 border-bottom d-flex justify-content-between align-items-start gap-2">
                        <div><div class="page-kicker">Inventory health</div><h2 class="h5 fw-bold mb-1" id="stockAlertTitle">Stock to Watch</h2><p class="text-muted small mb-0">Active products with 5 or fewer items.</p></div>
                        <span class="stock-alert-count">${dashboardStats.lowStockCount}</span>
                    </div>
                    <div class="stock-alert-list">
                        <c:choose>
                            <c:when test="${empty dashboardStats.lowStockProducts}"><div class="empty-state"><i class="bi bi-check-circle text-success fs-2 d-block mb-2"></i><strong>All clear</strong><div class="small mt-1">No low-stock products right now.</div></div></c:when>
                            <c:otherwise><c:forEach var="product" items="${dashboardStats.lowStockProducts}">
                                <div class="stock-alert-row d-flex align-items-center justify-content-between gap-3">
                                    <div class="min-w-0"><div class="fw-semibold text-truncate"><c:out value="${product.name}" /></div><small class="text-muted">Product #${product.id}</small></div>
                                    <span class="badge ${product.stock == 0 ? 'text-bg-danger' : 'text-bg-warning'} rounded-pill">${product.stock} left</span>
                                </div>
                            </c:forEach></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="p-3 border-top"><a href="${pageContext.request.contextPath}/admin-products?mode=all" class="btn btn-light border w-100 rounded-3">Review inventory <i class="bi bi-arrow-right ms-1"></i></a></div>
                </section>
            </div>
        </div>

        <section class="mt-4">
            <div class="d-flex align-items-center justify-content-between mb-3"><div><div class="page-kicker">Shortcuts</div><h2 class="h5 fw-bold mb-0">Quick actions</h2></div></div>
            <div class="row g-3">
                <div class="col-12 col-md-4"><a class="quick-action-card" href="${pageContext.request.contextPath}/admin-products?mode=all"><span class="quick-action-icon"><i class="bi bi-box-seam"></i></span><span><strong>Products & Inventory</strong><small>Update prices, stock and availability</small></span><i class="bi bi-arrow-up-right ms-auto"></i></a></div>
                <div class="col-12 col-md-4"><a class="quick-action-card" href="${pageContext.request.contextPath}/admin-users?mode=all"><span class="quick-action-icon"><i class="bi bi-people"></i></span><span><strong>Customer Accounts</strong><small>Review customer account status</small></span><i class="bi bi-arrow-up-right ms-auto"></i></a></div>
                <div class="col-12 col-md-4"><a class="quick-action-card" href="${pageContext.request.contextPath}/admin-payments"><span class="quick-action-icon"><i class="bi bi-receipt"></i></span><span><strong>Transactions</strong><small>Open payment and transaction records</small></span><i class="bi bi-arrow-up-right ms-auto"></i></a></div>
            </div>
        </section>
    </main>
</div>
<jsp:include page="../includes/scripts.jsp" />
<style>
.admin-dashboard-page{max-width:1680px}.dashboard-hero{padding:1.35rem 1.5rem;background:linear-gradient(115deg,rgba(27,67,50,.07),rgba(212,175,55,.07));border:1px solid rgba(27,67,50,.08);border-radius:18px}.stock-alert-count{min-width:38px;height:38px;border-radius:12px;display:grid;place-items:center;background:#fff3cd;color:#856404;font-weight:800}.stock-alert-row{padding:.9rem 1.2rem;border-bottom:1px solid var(--lux-border)}.stock-alert-row:last-child{border-bottom:0}.quick-action-card{min-height:84px;padding:1rem 1.1rem;display:flex;align-items:center;gap:.9rem;background:#fff;border:1px solid var(--lux-border);border-radius:14px;color:var(--lux-text-primary);text-decoration:none;transition:transform .18s ease,box-shadow .18s ease}.quick-action-card:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(11,19,14,.07);color:var(--lux-emerald)}.quick-action-card strong,.quick-action-card small{display:block}.quick-action-card small{color:var(--lux-text-muted);font-size:.78rem;margin-top:.15rem}.quick-action-icon{width:42px;height:42px;flex:0 0 42px;display:grid;place-items:center;background:rgba(27,67,50,.08);color:var(--lux-emerald);border-radius:12px;font-size:1.15rem}
</style>
</body></html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="../includes/head.jsp" />
<body>
<jsp:include page="../includes/sidebar.jsp" />
<div id="content" class="d-flex flex-column">
    <jsp:include page="../includes/navbar.jsp" />
    <main class="container-fluid p-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div>
                <div class="page-kicker">Wholesale Phase 2</div>
                <h1 class="h3 admin-page-title mb-1">Wholesale Pricing & Minimum Order Quantity</h1>
                <p class="text-muted mb-0">Create quantity-based wholesale price tiers for active products.</p>
            </div>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin-wholesale"><i class="bi bi-file-earmark-text me-1"></i> Applications</a>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-info alert-dismissible fade show" role="status">
                <c:out value="${msg}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <div class="col-12 col-xl-4">
                <div class="lux-card p-4">
                    <h5 class="fw-bold mb-1">Add Pricing Tier</h5>
                    <p class="small text-muted mb-4">Example: Apple — MOQ 10 → 8,500 MMK.</p>
                    <form method="post" action="${pageContext.request.contextPath}/admin-wholesale-pricing">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <input type="hidden" name="action" value="create">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Product</label>
                            <select name="productId" class="form-select" required>
                                <option value="">Select product</option>
                                <c:forEach items="${products}" var="p"><option value="${p.id}"><c:out value="${p.name}"/> — Retail: <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/> MMK</option></c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Minimum Order Quantity (MOQ)</label>
                            <input type="number" name="minQuantity" min="1" step="1" class="form-control" required placeholder="e.g. 10">
                            <div class="form-text">The customer must buy at least this quantity to qualify for the tier.</div>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Wholesale Price (MMK)</label>
                            <input type="number" name="wholesalePrice" min="0.01" step="0.01" class="form-control" required placeholder="e.g. 8500">
                        </div>
                        <button class="btn text-white w-100" style="background:var(--lux-emerald)"><i class="bi bi-plus-lg me-1"></i> Add Pricing Tier</button>
                    </form>
                </div>
            </div>

            <div class="col-12 col-xl-8">
                <div class="lux-card">
                    <div class="card-header bg-white py-3 px-4 d-flex flex-wrap justify-content-between align-items-center gap-2">
                        <div><h5 class="mb-0 fw-bold">Current Wholesale Tiers</h5><small class="text-muted">Highest eligible MOQ will be used later by the pricing service.</small></div>
                        <span class="badge text-bg-light border"><c:out value="${pricingTiers.size()}"/> tiers</span>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead><tr><th class="ps-4">Product</th><th>Retail</th><th>MOQ</th><th>Wholesale</th><th>Status</th><th class="text-end pe-4">Action</th></tr></thead>
                            <tbody>
                            <c:forEach items="${pricingTiers}" var="tier">
                                <tr>
                                    <td class="ps-4"><strong><c:out value="${tier.productName}"/></strong></td>
                                    <td><fmt:formatNumber value="${tier.retailPrice}" pattern="#,##0.00"/> MMK</td>
                                    <td>${tier.minQuantity}+</td>
                                    <td class="fw-bold text-success"><fmt:formatNumber value="${tier.wholesalePrice}" pattern="#,##0.00"/> MMK</td>
                                    <td><span class="badge ${tier.active ? 'text-bg-success' : 'text-bg-secondary'}">${tier.active ? 'Active' : 'Inactive'}</span></td>
                                    <td class="text-end pe-4">
                                        <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="collapse" data-bs-target="#edit${tier.id}">Edit</button>
                                        <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin-wholesale-pricing" onsubmit="return confirm('Remove this pricing tier?');">
                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${tier.id}">
                                            <button class="btn btn-sm btn-outline-danger">Remove</button>
                                        </form>
                                    </td>
                                </tr>
                                <tr class="collapse" id="edit${tier.id}"><td colspan="6" class="bg-light px-4 py-3">
                                    <form method="post" action="${pageContext.request.contextPath}/admin-wholesale-pricing" class="row g-2 align-items-end">
                                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"><input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${tier.id}">
                                        <div class="col-md-4"><label class="form-label small">MOQ</label><input class="form-control" type="number" min="1" name="minQuantity" value="${tier.minQuantity}" required></div>
                                        <div class="col-md-4"><label class="form-label small">Wholesale Price</label><input class="form-control" type="number" min="0.01" step="0.01" name="wholesalePrice" value="${tier.wholesalePrice}" required></div>
                                        <div class="col-md-2"><label class="form-label small">Status</label><select class="form-select" name="active"><option value="true" ${tier.active?'selected':''}>Active</option><option value="false" ${!tier.active?'selected':''}>Inactive</option></select></div>
                                        <div class="col-md-2"><button class="btn btn-primary w-100">Save</button></div>
                                    </form>
                                </td></tr>
                            </c:forEach>
                            <c:if test="${empty pricingTiers}"><tr><td colspan="6" class="text-center text-muted py-5">No wholesale pricing tiers yet.</td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
<%@ include file="../includes/scripts.jsp" %>
</body>
</html>

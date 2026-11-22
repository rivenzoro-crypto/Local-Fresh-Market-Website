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

        <main class="container-fluid px-3 px-lg-4 pb-5 admin-orders-page">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                <div>
                    <div class="page-kicker">Sales operations</div>
                    <h1 class="h3 fw-bold mb-1">Order Management</h1>
                    <p class="text-muted mb-0">Search, review and manage customer orders in one place.</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="orders-count"><i class="bi bi-bag-check me-2"></i><strong>${matchingOrderCount}</strong> matching orders</span>
                </div>
            </div>

            <c:if test="${not empty msg}">
                <div class="alert alert-info alert-dismissible fade show border-0 shadow-sm" role="alert">
                    <i class="bi bi-info-circle me-2"></i><c:out value="${msg}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty filterError}">
                <div class="alert alert-warning border-0 shadow-sm" role="alert">
                    <i class="bi bi-exclamation-triangle me-2"></i><c:out value="${filterError}" /> Showing all orders instead.
                </div>
            </c:if>

            <section class="lux-card filter-card mb-4" aria-labelledby="filterHeading">
                <div class="filter-card-heading">
                    <div>
                        <h2 class="h6 fw-bold mb-1" id="filterHeading"><i class="bi bi-funnel me-2 text-success"></i>Find orders</h2>
                        <p class="text-muted small mb-0">Combine filters to narrow down the results.</p>
                    </div>
                    <a class="btn btn-sm btn-light border rounded-pill px-3" href="${pageContext.request.contextPath}/admin-orders?mode=all">
                        <i class="bi bi-arrow-counterclockwise me-1"></i>Reset filters
                    </a>
                </div>
                <form action="${pageContext.request.contextPath}/admin-orders" method="get" class="p-3 p-lg-4 pt-3">
                    <input type="hidden" name="mode" value="all">
                    <div class="row g-3">
                        <div class="col-12 col-lg-4">
                            <label for="keyword" class="form-label filter-label">Search</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                                <input type="search" class="form-control" id="keyword" name="keyword" value="${keyword}" placeholder="Order ID, customer, email or phone">
                            </div>
                        </div>
                        <div class="col-12 col-sm-6 col-lg-2">
                            <label for="status" class="form-label filter-label">Order status</label>
                            <select class="form-select" id="status" name="status">
                                <option value="all" ${statusFilter eq 'all' ? 'selected' : ''}>All statuses</option>
                                <option value="pending" ${statusFilter eq 'pending' ? 'selected' : ''}>Pending</option>
                                <option value="confirmed" ${statusFilter eq 'confirmed' ? 'selected' : ''}>Confirmed</option>
                                <option value="processing" ${statusFilter eq 'processing' ? 'selected' : ''}>Processing</option>
                                <option value="shipping" ${statusFilter eq 'shipping' ? 'selected' : ''}>Shipping</option>
                                <option value="delivered" ${statusFilter eq 'delivered' ? 'selected' : ''}>Delivered</option>
                                <option value="cancelled" ${statusFilter eq 'cancelled' ? 'selected' : ''}>Cancelled</option>
                            </select>
                        </div>
                        <div class="col-12 col-sm-6 col-lg-2">
                            <label for="orderType" class="form-label filter-label">Order type</label>
                            <select class="form-select" id="orderType" name="orderType">
                                <option value="all" ${orderTypeFilter eq 'all' ? 'selected' : ''}>All order types</option>
                                <option value="RETAIL" ${orderTypeFilter eq 'RETAIL' ? 'selected' : ''}>Retail</option>
                                <option value="WHOLESALE" ${orderTypeFilter eq 'WHOLESALE' ? 'selected' : ''}>Wholesale</option>
                            </select>
                        </div>
                        <div class="col-6 col-sm-3 col-lg-1">
                            <label for="dateFrom" class="form-label filter-label">From date</label>
                            <input type="date" class="form-control" id="dateFrom" name="dateFrom" value="${dateFrom}">
                        </div>
                        <div class="col-6 col-sm-3 col-lg-1">
                            <label for="dateTo" class="form-label filter-label">To date</label>
                            <input type="date" class="form-control" id="dateTo" name="dateTo" value="${dateTo}">
                        </div>
                        <div class="col-6 col-lg-1">
                            <label for="minAmount" class="form-label filter-label">Min (MMK)</label>
                            <input type="number" min="0" step="0.01" class="form-control" id="minAmount" name="minAmount" value="${minAmount}" placeholder="0">
                        </div>
                        <div class="col-6 col-lg-1">
                            <label for="maxAmount" class="form-label filter-label">Max (MMK)</label>
                            <input type="number" min="0" step="0.01" class="form-control" id="maxAmount" name="maxAmount" value="${maxAmount}" placeholder="Any">
                        </div>
                        <div class="col-12 d-flex justify-content-end gap-2 pt-1">
                            <button type="submit" class="btn btn-success rounded-3 px-4"><i class="bi bi-search me-2"></i>Apply filters</button>
                        </div>
                    </div>
                </form>
            </section>

            <section class="lux-card orders-table-card">
                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 px-3 px-lg-4 py-3 border-bottom">
                    <div>
                        <h2 class="h6 fw-bold mb-1">Orders</h2>
                        <p class="text-muted small mb-0">Newest orders appear first.</p>
                    </div>
                    <span class="small text-muted">Showing <strong>${matchingOrderCount}</strong> result(s)</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 admin-orders-table">
                        <thead>
                            <tr>
                                <th class="ps-4">Order</th>
                                <th>Customer</th>
                                <th>Order date</th>
                                <th>Type</th>
                                <th class="text-end">Total</th>
                                <th>Status</th>
                                <th class="text-end pe-4">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td class="ps-4"><span class="order-reference">#ORD-<c:out value="${order.id}" /></span></td>
                                    <td>
                                        <div class="fw-semibold"><c:out value="${order.user != null ? order.user.name : 'N/A'}" /></div>
                                        <div class="small text-muted"><c:out value="${order.user != null ? order.user.email : ''}" /></div>
                                    </td>
                                    <td class="text-muted small text-nowrap"><c:out value="${order.orderDate}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.orderType eq 'WHOLESALE'}"><span class=" rounded-pill text-bg-primary">Wholesale</span></c:when>
                                            <c:otherwise><span class="badge rounded-pill text-bg-light border text-dark">Retail</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end fw-semibold text-nowrap"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" />  <small class="text-muted">MMK</small></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status eq 'pending'}"><span class="order-status status-pending">Pending</span></c:when>
                                            <c:when test="${order.status eq 'confirmed'}"><span class="order-status status-confirmed">Confirmed</span></c:when>
                                            <c:when test="${order.status eq 'processing'}"><span class="order-status status-processing">Processing</span></c:when>
                                            <c:when test="${order.status eq 'shipping'}"><span class="order-status status-shipping">Shipping</span></c:when>
                                            <c:when test="${order.status eq 'delivered'}"><span class="order-status status-delivered">Delivered</span></c:when>
                                            <c:when test="${order.status eq 'cancelled'}"><span class="order-status status-cancelled">Cancelled</span></c:when>
                                            <c:otherwise><span class="order-status status-other"><c:out value="${order.status}" /></span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4 text-nowrap">
                                        <a href="${pageContext.request.contextPath}/admin-orders?mode=detail&amp;id=${order.id}" class="btn btn-sm btn-outline-secondary action-btn" title="View order details" aria-label="View order details">
                                            <i class="bi bi-eye"></i><span class="d-none d-xl-inline ms-1">View</span>
                                        </a>
                                        <button type="button" class="btn btn-sm btn-outline-success action-btn" data-bs-toggle="modal" data-bs-target="#statusModal${order.id}" title="Update order status">
                                            <i class="bi bi-arrow-repeat"></i><span class="d-none d-xl-inline ms-1">Status</span>
                                        </button>
                                        <c:if test="${order.status eq 'cancelled'}">
                                            <form action="${pageContext.request.contextPath}/admin-orders" method="post" class="d-inline" onsubmit="return confirm('Permanently delete cancelled order #ORD-${order.id}?');">
                                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                <input type="hidden" name="mode" value="delete">
                                                <input type="hidden" name="id" value="${order.id}">
                                                <input type="hidden" name="keyword" value="${keyword}">
                                                <input type="hidden" name="filterStatus" value="${statusFilter}">
                                                <input type="hidden" name="filterOrderType" value="${orderTypeFilter}">
                                                <input type="hidden" name="dateFrom" value="${dateFrom}">
                                                <input type="hidden" name="dateTo" value="${dateTo}">
                                                <input type="hidden" name="minAmount" value="${minAmount}">
                                                <input type="hidden" name="maxAmount" value="${maxAmount}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger action-btn" title="Delete cancelled order" aria-label="Delete cancelled order"><i class="bi bi-trash"></i></button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty orders}">
                                <tr><td colspan="7" class="py-5 text-center">
                                    <div class="empty-orders-icon"><i class="bi bi-inbox"></i></div>
                                    <div class="fw-semibold mt-2">No matching orders</div>
                                    <p class="text-muted small mb-3">Try changing or clearing your filters.</p>
                                    <a href="${pageContext.request.contextPath}/admin-orders?mode=all" class="btn btn-sm btn-outline-success rounded-pill px-3">Clear filters</a>
                                </td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <c:forEach var="order" items="${orders}">
        <div class="modal fade" id="statusModal${order.id}" tabindex="-1" aria-labelledby="statusModalLabel${order.id}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow rounded-4">
                    <div class="modal-header border-0 px-4 pt-4">
                        <div>
                            <div class="page-kicker">Order #ORD-${order.id}</div>
                            <h2 class="h5 fw-bold mb-0" id="statusModalLabel${order.id}">Update order status</h2>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin-orders" method="post">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <input type="hidden" name="mode" value="updateStatus">
                        <input type="hidden" name="id" value="${order.id}">
                        <input type="hidden" name="keyword" value="${keyword}">
                        <input type="hidden" name="filterStatus" value="${statusFilter}">
                                                <input type="hidden" name="filterOrderType" value="${orderTypeFilter}">
                        <input type="hidden" name="dateFrom" value="${dateFrom}">
                        <input type="hidden" name="dateTo" value="${dateTo}">
                        <input type="hidden" name="minAmount" value="${minAmount}">
                        <input type="hidden" name="maxAmount" value="${maxAmount}">
                        <div class="modal-body px-4 py-3">
                            <label class="form-label fw-semibold" for="newStatus${order.id}">New status</label>
                            <select class="form-select" name="status" id="newStatus${order.id}" required>
                                <option value="pending" ${order.status eq 'pending' ? 'selected' : ''}>Pending</option>
                                <option value="confirmed" ${order.status eq 'confirmed' ? 'selected' : ''}>Confirmed</option>
                                <option value="processing" ${order.status eq 'processing' ? 'selected' : ''}>Processing</option>
                                <option value="shipping" ${order.status eq 'shipping' ? 'selected' : ''}>Shipping</option>
                                <option value="delivered" ${order.status eq 'delivered' ? 'selected' : ''}>Delivered</option>
                                <option value="cancelled" ${order.status eq 'cancelled' ? 'selected' : ''}>Cancelled</option>
                            </select>
                            <p class="text-muted small mt-2 mb-0">Cancelling an order restores its reserved stock. Cancelled orders cannot be reopened automatically.</p>
                        </div>
                        <div class="modal-footer border-0 px-4 pb-4">
                            <button type="button" class="btn btn-light rounded-3 px-3" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-success rounded-3 px-4">Save status</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </c:forEach>

    <style>
        .admin-orders-page{max-width:1800px;margin-inline:auto}
        .orders-count{display:inline-flex;align-items:center;padding:.65rem .95rem;border:1px solid #e5ebe6;background:#fff;border-radius:999px;color:#59645c;font-size:.82rem}
        .orders-count i{color:#26734d}.orders-count strong{color:#1b4332;margin-right:.25rem}
        .filter-card{overflow:hidden}.filter-card-heading{display:flex;justify-content:space-between;align-items:center;gap:1rem;padding:1.1rem 1.25rem;border-bottom:1px solid #edf0ed}
        .filter-label{font-size:.76rem;font-weight:700;color:#58635b;margin-bottom:.4rem}
        .admin-orders-page .form-control,.admin-orders-page .form-select,.admin-orders-page .input-group-text{min-height:42px;border-color:#e2e8e3;font-size:.84rem}
        .admin-orders-page .form-control:focus,.admin-orders-page .form-select:focus{border-color:#72a58a;box-shadow:0 0 0 .2rem rgba(27,67,50,.1)}
        .admin-orders-table thead th{background:#f8faf8;color:#68736b;font-size:.68rem;font-weight:700;letter-spacing:.07em;text-transform:uppercase;padding:1rem .8rem;border-bottom:1px solid #e9eee9;white-space:nowrap}
        .admin-orders-table tbody td{padding:.95rem .8rem;border-color:#eff2ef;font-size:.83rem}
        .admin-orders-table tbody tr:hover{background:#fbfdfb}.order-reference{font-weight:700;color:#1b4332;white-space:nowrap}
        .order-status{display:inline-flex;align-items:center;border-radius:999px;padding:.35rem .65rem;font-size:.7rem;font-weight:700;white-space:nowrap}
        .status-pending{background:#fff4d8;color:#8a6500}.status-confirmed{background:#e3f5fb;color:#087990}.status-processing{background:#f0eaff;color:#6544a5}.status-shipping{background:#e8efff;color:#3159a5}.status-delivered{background:#e4f3e9;color:#24613b}.status-cancelled{background:#fde8e8;color:#a52a2a}.status-other{background:#eef0ee;color:#58635b}
        .action-btn{min-width:34px;margin-left:.15rem;border-radius:8px}.empty-orders-icon{width:48px;height:48px;margin:auto;border-radius:14px;background:#f0f5f1;color:#63816c;display:grid;place-items:center;font-size:1.35rem}
        @media(max-width:767.98px){.filter-card-heading{align-items:flex-start;flex-direction:column}.admin-orders-table{min-width:950px}}
    </style>
    <jsp:include page="../includes/scripts.jsp" />
</body>
</html>

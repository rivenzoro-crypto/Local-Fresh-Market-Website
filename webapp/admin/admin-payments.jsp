<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">

<!-- Head Section -->
<jsp:include page="../includes/head.jsp" />

<body>

    <!-- Sidebar Component -->
    <jsp:include page="../includes/sidebar.jsp" />

    <!-- Main Content Wrapper -->
    <div id="content" class="d-flex flex-column">
        
        <!-- Top Navigation Bar -->
        <jsp:include page="../includes/navbar.jsp" />

        <!-- Main Body Content -->
        <main class="container-fluid p-4">
            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 fw-bold m-0" style="color: var(--lux-text-primary);">Payment Management</h1>
                    <p class="text-muted small m-0">Review secure financial transactions and logs</p>
                </div>
                <button class="btn rounded-pill px-4 py-2 text-white fw-semibold shadow-sm" style="background: var(--lux-emerald); border: none;" data-bs-toggle="modal" data-bs-target="#recordPaymentModal">
                    <i class="bi bi-plus-lg me-2"></i>Record Manual Payment
                </button>
            </div>

            <!-- Summary Cards -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="lux-card p-4">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="text-uppercase fw-bold text-muted" style="font-size: 0.7rem; letter-spacing: 1px;">Total Revenue</span>
                            <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 40px; height: 40px; background: rgba(27, 67, 50, 0.08); color: var(--lux-emerald);">
                                <i class="bi bi-currency-dollar"></i>
                            </div>
                        </div>
                        <h3 class="fw-bold m-0 text-dark">${totalRevenue != null ? totalRevenue : '0.00'} MMK</h3>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="lux-card p-4">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="text-uppercase fw-bold text-muted" style="font-size: 0.7rem; letter-spacing: 1px;">Pending Payments</span>
                            <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 40px; height: 40px; background: rgba(212, 175, 55, 0.15); color: #9E7D0A;">
                                <i class="bi bi-hourglass-split"></i>
                            </div>
                        </div>
                        <h3 class="fw-bold m-0 text-dark">${pendingCount != null ? pendingCount : 0}</h3>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="lux-card p-4">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="text-uppercase fw-bold text-muted" style="font-size: 0.7rem; letter-spacing: 1px;">Completed Transactions</span>
                            <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 40px; height: 40px; background: rgba(27, 67, 50, 0.08); color: var(--lux-emerald);">
                                <i class="bi bi-check-circle"></i>
                            </div>
                        </div>
                        <h3 class="fw-bold m-0 text-dark">${completedCount != null ? completedCount : 0}</h3>
                    </div>
                </div>
            </div>

            <!-- Payments Table Card -->
            <div class="lux-card border-0 mb-4">
                <div class="card-header bg-white py-3 border-bottom border-light">
                    <h5 class="card-title m-0 fw-bold">Transaction History</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" style="font-size: 0.875rem;">
                            <thead class="text-uppercase text-muted" style="font-size: 0.7rem; letter-spacing: 1px; background-color: rgba(0,0,0,0.015);">
                                <tr>
                                    <th scope="col" class="ps-4 py-3">ID</th>
                                    <th scope="col" class="py-3">Order ID</th>
                                    <th scope="col" class="py-3">Payment Method</th>
                                    <th scope="col" class="py-3">Amount</th>
                                    <th scope="col" class="py-3">Payment Date</th>
                                    <th scope="col" class="py-3">Status</th>
                                    <th scope="col" class="text-end pe-4 py-3">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="payment" items="${payments}">
                                    <tr>
                                        <td class="ps-4 text-muted">#${payment.id}</td>
                                        <td>
                                            <span class="fw-semibold text-dark">
                                                <c:choose>
                                                    <c:when test="${not empty payment.order}">
                                                        #${payment.order.id}
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge rounded-pill bg-light text-dark border px-2.5 py-1">
                                                <i class="bi bi-credit-card me-1"></i>${payment.paymentMethod}
                                            </span>
                                        </td>
                                        <td class="fw-bold text-dark"><fmt:formatNumber value="${payment.amount}" pattern="#,##0.00"/> MMK</td>
                                        <td class="text-muted">${payment.paymentDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${payment.paymentStatus == 'COMPLETED' || payment.paymentStatus == 'PAID'}">
                                                    <span class="badge rounded-pill px-2.5 py-1.5 fw-medium" style="background: rgba(27, 67, 50, 0.1); color: var(--lux-emerald);">Completed</span>
                                                </c:when>
                                                <c:when test="${payment.paymentStatus == 'PENDING'}">
                                                    <span class="badge rounded-pill px-2.5 py-1.5 fw-medium" style="background: rgba(212, 175, 55, 0.15); color: #9E7D0A;">Pending</span>
                                                </c:when>
                                                <c:when test="${payment.paymentStatus == 'FAILED'}">
                                                    <span class="badge rounded-pill px-2.5 py-1.5 fw-medium" style="background: rgba(220, 53, 69, 0.1); color: #dc3545;">Failed</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge rounded-pill px-2.5 py-1.5 fw-medium" style="background: rgba(108, 117, 125, 0.1); color: #495057;">${payment.paymentStatus}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end pe-4">
                                            <button class="btn btn-sm btn-outline-success me-1 rounded-circle p-1" style="width: 28px; height: 28px; display: inline-flex; align-items: center; justify-content: center;" title="Edit Payment" data-bs-toggle="modal" data-bs-target="#editPaymentModal${payment.id}">
                                                <i class="bi bi-pencil" style="font-size: 0.75rem;"></i>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/payments/delete?id=${payment.id}" class="btn btn-sm btn-outline-danger rounded-circle p-1" style="width: 28px; height: 28px; display: inline-flex; align-items: center; justify-content: center;" title="Delete Payment" onclick="return confirm('Are you sure you want to delete this payment record?');">
                                                <i class="bi bi-trash" style="font-size: 0.75rem;"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <!-- ========================================== -->
    <!-- EDIT PAYMENT MODALS (Placed outside table) -->
    <!-- ========================================== -->
    <c:forEach var="payment" items="${payments}">
        <div class="modal fade" id="editPaymentModal${payment.id}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold">Update Payment (#${payment.id})</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/payments/update" method="post">
                        <div class="modal-body py-4">
                            <input type="hidden" name="id" value="${payment.id}" />

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-secondary">Order ID</label>
                                    <input type="text" class="form-control rounded-3 py-2 bg-light" value="${payment.order != null ? payment.order.id : 'N/A'}" readonly />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-secondary">Amount (MMK)</label>
                                    <input type="number" step="0.01" class="form-control rounded-3 py-2" name="amount" value="${payment.amount}" required />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-secondary">Payment Method</label>
                                    <select class="form-select rounded-3 py-2" name="paymentMethod">
                                        <option value="CREDIT_CARD" ${payment.paymentMethod == 'CREDIT_CARD' ? 'selected' : ''}>Credit Card</option>
                                        <option value="PAYPAL" ${payment.paymentMethod == 'PAYPAL' ? 'selected' : ''}>PayPal</option>
                                        <option value="BANK_TRANSFER" ${payment.paymentMethod == 'BANK_TRANSFER' ? 'selected' : ''}>Bank Transfer</option>
                                        <option value="CASH_ON_DELIVERY" ${payment.paymentMethod == 'CASH_ON_DELIVERY' ? 'selected' : ''}>Cash on Delivery</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-secondary">Payment Status</label>
                                    <select class="form-select rounded-3 py-2" name="paymentStatus">
                                        <option value="COMPLETED" ${payment.paymentStatus == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                        <option value="PENDING" ${payment.paymentStatus == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                        <option value="FAILED" ${payment.paymentStatus == 'FAILED' ? 'selected' : ''}>FAILED</option>
                                        <option value="REFUNDED" ${payment.paymentStatus == 'REFUNDED' ? 'selected' : ''}>REFUNDED</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-semibold small text-secondary">Payment Date</label>
                                    <%-- Safely extracts YYYY-MM-DD from LocalDateTime for the date input --%>
                                    <input type="date" class="form-control rounded-3 py-2" name="paymentDate" value="${not empty payment.paymentDate ? fn:substring(payment.paymentDate, 0, 10) : ''}" required />
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer border-0 pt-0">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn rounded-pill px-4 text-white" style="background: var(--lux-emerald);">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </c:forEach>

    <!-- Record Manual Payment Modal -->
    <div class="modal fade" id="recordPaymentModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Record New Payment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/payments/add" method="post">
                    <div class="modal-body py-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="orderId" class="form-label fw-semibold small text-secondary">Order ID</label>
                                <input type="number" class="form-control rounded-3 py-2" id="orderId" name="orderId" placeholder="e.g. 101" required />
                            </div>
                            <div class="col-md-6">
                                <label for="addAmount" class="form-label fw-semibold small text-secondary">Amount ($)</label>
                                <input type="number" step="0.01" class="form-control rounded-3 py-2" id="addAmount" name="amount" placeholder="0.00" required />
                            </div>
                            <div class="col-md-6">
                                <label for="addMethod" class="form-label fw-semibold small text-secondary">Payment Method</label>
                                <select class="form-select rounded-3 py-2" id="addMethod" name="paymentMethod" required>
                                    <option value="CREDIT_CARD" selected>Credit Card</option>
                                    <option value="PAYPAL">PayPal</option>
                                    <option value="BANK_TRANSFER">Bank Transfer</option>
                                    <option value="CASH_ON_DELIVERY">Cash on Delivery</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="addStatus" class="form-label fw-semibold small text-secondary">Payment Status</label>
                                <select class="form-select rounded-3 py-2" id="addStatus" name="paymentStatus" required>
                                    <option value="COMPLETED" selected>COMPLETED</option>
                                    <option value="PENDING">PENDING</option>
                                    <option value="FAILED">FAILED</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label for="addDate" class="form-label fw-semibold small text-secondary">Payment Date</label>
                                <input type="date" class="form-control rounded-3 py-2" id="addDate" name="paymentDate" required />
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn rounded-pill px-4 text-white" style="background: var(--lux-emerald);">Save Payment</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts Component -->
    <jsp:include page="../includes/scripts.jsp" />

</body>
</html>
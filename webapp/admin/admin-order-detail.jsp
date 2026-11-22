<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">

<!-- Head Component -->
<jsp:include page="../includes/head.jsp" />

<body>
<c:if test="${not empty msg}">
    <script type="text/javascript">
        alert("${msg}");
    </script>
</c:if>

    <!-- Sidebar Component -->
    <jsp:include page="../includes/sidebar.jsp" />

    <!-- Main Content Wrapper -->
    <div id="content" class="d-flex flex-column">
        
        <!-- Top Navigation Bar -->
        <jsp:include page="../includes/navbar.jsp" />

        <!-- Main Body Content -->
        <main class="container-fluid p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 fw-bold m-0" style="color: var(--lux-text-primary);">Order Breakdown</h1>
                <a href="admin-orders?mode=all" class="btn btn-outline-dark btn-sm rounded-pill px-3">
                    <i class="bi bi-arrow-left me-1"></i>Back to Orders
                </a>
            </div>

            <div class="lux-card border-0 mb-4">
                <div class="card-header bg-white py-4 border-bottom border-light">
                    <div class="row align-items-center g-3">
                        <div class="col-md-4">
                            <span class="text-uppercase fw-bold text-muted" style="font-size: 0.65rem; letter-spacing: 1px;">Order Reference</span>
                            <h5 class="fw-bold m-0 text-dark">#ORD-${order.id}</h5>
                            <div class="mt-2">
                                <c:choose>
                                    <c:when test="${order.orderType eq 'WHOLESALE'}"><span class="badge rounded-pill text-bg-primary">Wholesale Order</span></c:when>
                                    <c:otherwise><span class="badge rounded-pill text-bg-light border text-dark">Retail Order</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <span class="text-uppercase fw-bold text-muted" style="font-size: 0.65rem; letter-spacing: 1px;">Client Name</span>
                            <h5 class="fw-bold m-0 text-dark">${order.user.name}</h5>
                        </div>
                        <div class="col-md-4">
                            <span class="text-uppercase fw-bold text-muted" style="font-size: 0.65rem; letter-spacing: 1px;">Timestamp & Amount</span>
                            <h5 class="fw-bold m-0 text-success">${order.orderDate} &bull; $<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></h5>
                        </div>
                    </div>
                </div>
                
                
                <div class="card-body border-bottom border-light bg-light bg-opacity-50 py-3 px-4">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <span class="text-uppercase fw-bold text-muted d-block" style="font-size: 0.65rem; letter-spacing: 1px;">
                                Shipping Address
                            </span>
                            <div class="fw-semibold text-dark mt-1">
                                <c:out value="${order.shippingStreet}" default="" />
                                <c:if test="${not empty order.shippingStreet and (not empty order.shippingTownship or not empty order.shippingCity)}">, </c:if>
                                <c:out value="${order.shippingTownship}" default="" />
                                <c:if test="${not empty order.shippingTownship and not empty order.shippingCity}">, </c:if>
                                <c:out value="${order.shippingCity}" default="" />
                            </div>
                            <c:if test="${not empty order.shippingDescription}">
                                <div class="text-muted small mt-1">
                                    Note: <c:out value="${order.shippingDescription}" />
                                </div>
                            </c:if>
                            <c:if test="${empty order.shippingStreet and empty order.shippingTownship and empty order.shippingCity and empty order.shippingDescription}">
                                <span class="text-muted fst-italic">No shipping address recorded.</span>
                            </c:if>
                        </div>
                        <c:if test="${not empty order.user.phone}">
                            <div class="col-md-4">
                                <span class="text-uppercase fw-bold text-muted d-block" style="font-size: 0.65rem; letter-spacing: 1px;">
                                    Customer Phone
                                </span>
                                <div class="fw-semibold text-dark mt-1">
                                    <c:out value="${order.user.phone}" />
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" style="font-size: 0.875rem;">
                            <thead class="text-uppercase text-muted" style="font-size: 0.7rem; letter-spacing: 1px; background-color: rgba(0,0,0,0.015);">
                                <tr>
                                    <th scope="col" class="ps-4 py-3">Item Ref</th>
                                    <th scope="col" class="py-3">Produce Name</th>
                                    <th scope="col" class="py-3">Unit Price</th>
                                    <th scope="col" class="py-3">Quantity</th>
                                    <th scope="col" class="pe-4 text-end py-3">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${orderItems}">
                                    <tr>
                                        <td class="ps-4 text-muted">#ITM-${item.id}</td>
                                        <td class="fw-semibold text-dark">${item.product.name}</td>
                                        <td><fmt:formatNumber value="${item.price}" pattern="#,##0.00"/> MMK</td>
                                        <td>${item.qty}</td>
                                        <td class="pe-4 text-end fw-bold text-dark"><fmt:formatNumber value="${item.price * item.qty}" pattern="#,##0.00"/> MMK</td>
                                    </tr>
                                </c:forEach>
                                <tr style="background-color: rgba(27, 67, 50, 0.02);">
                                    <td colspan="4" class="ps-4 text-end fw-bold py-3">Total Amount:</td>
                                    <td class="pe-4 text-end fw-bold text-success fs-5 py-3"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/> MMK</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <!-- Scripts Component -->
    <jsp:include page="../includes/scripts.jsp" />

</body>
</html>
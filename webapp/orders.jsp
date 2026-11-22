<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Online Store</title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Local Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    
    <!-- Bootstrap Icons CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>

    <!-- Dynamic Menu Bar Include -->
    <c:import url="components/menuBar.jsp"></c:import>

    <div class="container my-4">
        <!-- Notification Alert -->
        <c:if test="${not empty msg}">
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                ${msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold text-primary mb-0"><i class="bi bi-bag-check me-2"></i>My Orders</h3>
        </div>

        <c:choose>
            <c:when test="${not empty orders}">
                <div class="card border-0 shadow-sm">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Order ID</th>
                                    <th>Date</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td class="fw-bold">#${order.id}</td>
                                        <td>${order.orderDate}</td>
                                        <td class="fw-semibold text-primary">
                                            $<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status == 'COMPLETED' || order.status == 'DELIVERED'}">
                                                    <span class="badge bg-success">${order.status}</span>
                                                </c:when>
                                                <c:when test="${order.status == 'PENDING'}">
                                                    <span class="badge bg-warning text-dark">${order.status}</span>
                                                </c:when>
                                                <c:when test="${order.status == 'CANCELLED'}">
                                                    <span class="badge bg-danger">${order.status}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info text-dark">${order.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <a href="orders?mode=detail&id=${order.id}" class="btn btn-outline-primary btn-sm">
                                                <i class="bi bi-eye"></i> View Details
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 bg-white rounded shadow-sm">
                    <i class="bi bi-bag-x display-1 text-muted"></i>
                    <h4 class="mt-3 text-secondary">No Orders Placed Yet</h4>
                    <p class="text-muted">Explore products and place your first order.</p>
                    <a href="home" class="btn btn-primary mt-2">
                        <i class="bi bi-shop me-1"></i> Start Shopping
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Local Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    
    <!-- Bootstrap 5 JS CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
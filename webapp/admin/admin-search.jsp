<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en"><jsp:include page="../includes/head.jsp" /><body><jsp:include
		page="../includes/sidebar.jsp" /><div id="content"><jsp:include
			page="../includes/navbar.jsp" /><main
			class="container-fluid px-4 pb-4">
			<div class="mb-4">
				<div class="page-kicker">Global Search</div>
				<h1 class="h3 fw-bold">Search Results</h1>
				<p class="text-muted mb-0">
					Results for <strong><c:out value="${q}" /></strong>
				</p>
			</div>
			<c:if test="${empty q}">
				<div class="lux-card empty-state">
					<i class="bi bi-search fs-1 d-block mb-3"></i>Search products,
					order IDs, customer names or emails.
				</div>
			</c:if>
			<c:if test="${not empty q}">
				<div class="row g-4">
					<div class="col-12 col-lg-4">
						<div class="lux-card">
							<div class="p-3 border-bottom fw-bold">
								<i class="bi bi-box-seam me-2"></i>Products
								(${results.products.size()})
							</div>
							<div class="p-2">
								<c:choose>
									<c:when test="${empty results.products}">
										<div class="empty-state">No products found.</div>
									</c:when>
									<c:otherwise>
										<c:forEach var="p" items="${results.products}">
											<a
												class="d-block p-3 text-decoration-none text-dark border-bottom"
												href="${pageContext.request.contextPath}/admin-products?mode=all"><div
													class="fw-semibold">
													<c:out value="${p.name}" />
												</div>
												<small class="text-muted">#${p.id} · Stock:
													${p.stock}</small></a>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>
					<div class="col-12 col-lg-4">
						<div class="lux-card">
							<div class="p-3 border-bottom fw-bold">
								<i class="bi bi-bag me-2"></i>Orders (${results.orders.size()})
							</div>
							<div class="p-2">
								<c:choose>
									<c:when test="${empty results.orders}">
										<div class="empty-state">No orders found.</div>
									</c:when>
									<c:otherwise>
										<c:forEach var="o" items="${results.orders}">
											<a
												class="d-block p-3 text-decoration-none text-dark border-bottom"
												href="${pageContext.request.contextPath}/admin-orders?mode=detail&id=${o.id}"><div
													class="fw-semibold">Order #${o.id}</div>
												<small class="text-muted"><c:out
														value="${o.user.name}" /> · <c:out value="${o.status}" /></small></a>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>
					<div class="col-12 col-lg-4">
						<div class="lux-card">
							<div class="p-3 border-bottom fw-bold">
								<i class="bi bi-people me-2"></i>Customers
								(${results.customers.size()})
							</div>
							<div class="p-2">
								<c:choose>
									<c:when test="${empty results.customers}">
										<div class="empty-state">No customers found.</div>
									</c:when>
									<c:otherwise>
										<c:forEach var="u" items="${results.customers}">
											<a
												class="d-block p-3 text-decoration-none text-dark border-bottom"
												href="${pageContext.request.contextPath}/admin-users?mode=edit&id=${u.id}"><div
													class="fw-semibold">
													<c:out value="${u.name}" />
												</div>
												<small class="text-muted"><c:out value="${u.email}" /></small></a>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>
				</div>
			</c:if>
		</main>
	</div><jsp:include page="../includes/scripts.jsp" /></body>
</html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="lux-card border-0">
	<div
		class="p-4 d-flex align-items-center justify-content-between border-bottom">
		<div>
			<h5 class="fw-bold m-0">Recent Orders</h5>
			<p class="text-muted mb-0 small">Latest orders placed by
				customers</p>
		</div>
		<a href="${pageContext.request.contextPath}/admin-orders?mode=all"
			class="btn btn-outline-dark btn-sm rounded-pill px-3">View All</a>
	</div>
	<div class="table-responsive">
		<table class="table table-hover align-middle mb-0">
			<thead>
				<tr class="text-uppercase text-muted"
					style="font-size: .7rem; letter-spacing: 1px">
					<th class="ps-4 py-3">Order</th>
					<th>Customer</th>
					<th>Date</th>
					<th>Status</th>
					<th class="pe-4 text-end">Total</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty dashboardStats.recentOrders}">
						<tr>
							<td colspan="5" class="empty-state"><i
								class="bi bi-bag-x fs-3 d-block mb-2"></i>No orders yet.</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="order" items="${dashboardStats.recentOrders}">
							<tr>
								<td class="ps-4 fw-semibold">#${order.id}</td>
								<td><div class="fw-semibold">
										<c:out value="${order.user.name}" />
									</div>
									<small class="text-muted"><c:out
											value="${order.user.email}" /></small></td>
								<td class="text-muted">${order.orderDate}</td>
								<td><span
									class="badge rounded-pill bg-light text-dark border status-badge"><c:out
											value="${order.status}" /></span></td>
								<td class="pe-4 text-end fw-bold">${order.totalAmount}</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
</div>

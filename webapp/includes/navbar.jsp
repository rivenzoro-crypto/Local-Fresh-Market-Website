<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<nav class="navbar bg-transparent px-4 py-3 mb-2">
	<div class="container-fluid p-0">
		<button class="btn btn-light d-lg-none me-3 border-0 shadow-sm"
			type="button" id="sidebarToggle" aria-label="Open navigation">
			<i class="bi bi-list fs-5"></i>
		</button>
		<form class="col-12 col-lg-5 me-auto mb-2 mb-lg-0"
			action="${pageContext.request.contextPath}/admin-search" method="get"
			role="search">
			<div class="position-relative">
				<i
					class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted"></i><input
					class="form-control ps-5 pe-3 py-2 rounded-pill border-0 shadow-sm bg-white"
					name="q" type="search"
					placeholder="Search products, orders, customers..."
					value="${param.q}" aria-label="Search admin records">
			</div>
		</form>
		<div class="d-flex align-items-center gap-2">
			<span class="d-none d-md-inline text-muted small">Admin Panel</span>
			<div
				class="rounded-circle bg-white shadow-sm d-flex align-items-center justify-content-center"
				style="width: 40px; height: 40px">
				<i class="bi bi-shield-check text-success"></i>
			</div>
		</div>
	</div>
</nav>

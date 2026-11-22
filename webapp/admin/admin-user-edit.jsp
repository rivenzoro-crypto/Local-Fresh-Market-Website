<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html><html lang="en">
<jsp:include page="../includes/head.jsp" />
<body><jsp:include page="../includes/sidebar.jsp" />
<div id="content" class="d-flex flex-column"><jsp:include page="../includes/navbar.jsp" />
<main class="container-fluid px-3 px-lg-4 pb-5">
    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 mb-4">
        <div><div class="page-kicker">Customer relationships</div><h1 class="h3 fw-bold mb-1">Manage Account</h1><p class="text-muted mb-0">Change account access without modifying customer details.</p></div>
        <a href="${pageContext.request.contextPath}/admin-users?mode=all" class="btn btn-outline-dark rounded-3"><i class="bi bi-arrow-left me-2"></i>Back to accounts</a>
    </div>
    <div class="row justify-content-center"><div class="col-12 col-lg-7 col-xl-6">
        <section class="lux-card p-4 p-lg-5">
            <div class="d-flex align-items-center gap-3 mb-4"><span class="customer-avatar customer-avatar-large"><c:out value="${empty user.name ? '?' : user.name.substring(0,1)}"/></span><div><h2 class="h5 fw-bold mb-1"><c:out value="${user.name}"/></h2><p class="text-muted small mb-0">Account #${user.id}</p></div></div>
            <form action="${pageContext.request.contextPath}/admin-users" method="post">
                <input type="hidden" name="mode" value="update"><input type="hidden" name="id" value="${user.id}"><input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <div class="mb-3"><label class="form-label small fw-semibold text-secondary" for="accountEmail">Email address</label><input id="accountEmail" type="email" class="form-control bg-light" value="<c:out value='${user.email}'/>" disabled></div>
                <div class="mb-4"><label class="form-label small fw-semibold text-secondary" for="accountPhone">Phone</label><input id="accountPhone" type="text" class="form-control bg-light" value="<c:out value='${empty user.phone ? "—" : user.phone}'/>" disabled></div>
                <div class="mb-4"><label class="form-label small fw-semibold text-secondary" for="enable">Account status</label><select name="enable" id="enable" class="form-select" required><option value="true" ${user.enabled ? 'selected' : ''}>Active — customer can sign in</option><option value="false" ${!user.enabled ? 'selected' : ''}>Inactive — sign-in disabled</option></select><div class="form-text">This changes account access only. It does not delete the account or its orders.</div></div>
                <div class="d-flex justify-content-end gap-2"><a href="${pageContext.request.contextPath}/admin-users?mode=all" class="btn btn-light border rounded-3 px-4">Cancel</a><button type="submit" class="btn btn-success rounded-3 px-4"><i class="bi bi-check2 me-1"></i>Save status</button></div>
            </form>
        </section>
    </div></div>
</main></div>
<jsp:include page="../includes/scripts.jsp" />
<style>.customer-avatar{width:38px;height:38px;display:grid;place-items:center;border-radius:12px;background:rgba(27,67,50,.09);color:var(--lux-emerald);font-weight:800}.customer-avatar-large{width:54px;height:54px;font-size:1.25rem;border-radius:16px}</style>
</body></html>
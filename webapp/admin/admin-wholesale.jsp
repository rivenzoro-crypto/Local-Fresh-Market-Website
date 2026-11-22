<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../includes/head.jsp" %>
<title>Wholesale Applications</title>
</head>
<body>
<%@ include file="../includes/sidebar.jsp" %>
<div id="content" class="d-flex flex-column">
    <jsp:include page="../includes/navbar.jsp" />
    <main class="container-fluid p-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div><div class="page-kicker">Wholesale Phase 1</div><h1 class="h3 admin-page-title mb-1">Wholesale Applications</h1><p class="text-muted mb-0">Review and manage business account requests.</p></div>
            <a class="btn text-white" style="background:var(--lux-emerald)" href="${pageContext.request.contextPath}/admin-wholesale-pricing"><i class="bi bi-tags me-1"></i> Manage Pricing & Minimum Order Quantity</a>
        </div>
        <c:if test="${not empty msg}"><div class="alert alert-info alert-dismissible fade show"><c:out value="${msg}"/><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>
        <div class="row g-3 mb-4">
            <div class="col-md-4"><div class="lux-card"><div class="card-body"><div class="text-muted small">Pending</div><div class="display-6 fw-bold text-warning">${pendingCount}</div></div></div></div>
            <div class="col-md-4"><div class="lux-card"><div class="card-body"><div class="text-muted small">Approved</div><div class="display-6 fw-bold text-success">${approvedCount}</div></div></div></div>
            <div class="col-md-4"><div class="lux-card"><div class="card-body"><div class="text-muted small">Rejected</div><div class="display-6 fw-bold text-danger">${rejectedCount}</div></div></div></div>
        </div>
        <div class="lux-card"><div class="card-body p-3 p-lg-4">
            <div class="mb-3 d-flex gap-2 flex-wrap">
                <a class="btn btn-sm ${selectedStatus=='ALL'?'btn-dark':'btn-outline-dark'}" href="${pageContext.request.contextPath}/admin-wholesale">All</a>
                <a class="btn btn-sm ${selectedStatus=='PENDING'?'btn-warning':'btn-outline-warning'}" href="${pageContext.request.contextPath}/admin-wholesale?status=PENDING">Pending</a>
                <a class="btn btn-sm ${selectedStatus=='APPROVED'?'btn-success':'btn-outline-success'}" href="${pageContext.request.contextPath}/admin-wholesale?status=APPROVED">Approved</a>
                <a class="btn btn-sm ${selectedStatus=='REJECTED'?'btn-danger':'btn-outline-danger'}" href="${pageContext.request.contextPath}/admin-wholesale?status=REJECTED">Rejected</a>
            </div>
            <div class="table-responsive"><table class="table table-hover align-middle mb-0"><thead><tr><th>Applicant</th><th>Business</th><th>Contact</th><th>Status</th><th>Applied</th><th>Action</th></tr></thead><tbody>
                <c:forEach items="${applications}" var="a"><tr><td><strong><c:out value="${a.applicantName}"/></strong><br><small class="text-muted"><c:out value="${a.applicantEmail}"/></small></td><td><strong><c:out value="${a.businessName}"/></strong><br><small><c:out value="${a.businessType}"/></small><br><small class="text-muted"><c:out value="${a.businessAddress}"/></small></td><td><c:out value="${a.businessPhone}"/><br><small><c:out value="${a.registrationNumber}"/></small></td><td><span class=" ${a.status=='APPROVED'?'text-bg-success':a.status=='REJECTED'?'text-bg-danger':'text-bg-warning'}"><c:out value="${a.status}"/></span><c:if test="${not empty a.rejectionReason}"><br><small class="text-danger"><c:out value="${a.rejectionReason}"/></small></c:if></td><td><small><c:out value="${a.appliedAt}"/></small></td><td><c:if test="${a.status=='PENDING'}"><form method="post" action="${pageContext.request.contextPath}/admin-wholesale" class="d-inline"><input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"><input type="hidden" name="id" value="${a.id}"><input type="hidden" name="action" value="approve"><button class="btn btn-sm btn-success">Approve</button></form><button class="btn btn-sm btn-outline-danger ms-1" onclick="document.getElementById('reject${a.id}').classList.toggle('d-none')">Reject</button><form id="reject${a.id}" method="post" action="${pageContext.request.contextPath}/admin-wholesale" class="d-none mt-2"><input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"><input type="hidden" name="id" value="${a.id}"><input type="hidden" name="action" value="reject"><input class="form-control form-control-sm mb-1" name="reason" required maxlength="255" placeholder="Reason"><button class="btn btn-sm btn-danger">Confirm Reject</button></form></c:if></td></tr></c:forEach>
                <c:if test="${empty applications}"><tr><td colspan="6" class="text-center text-muted py-4">No applications found.</td></tr></c:if>
            </tbody></table></div>
        </div></div>
    </main>
</div>
<%@ include file="../includes/scripts.jsp" %>
</body>
</html>
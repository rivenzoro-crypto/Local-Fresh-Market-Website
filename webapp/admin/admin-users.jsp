<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="../includes/head.jsp" />
<body>
<jsp:include page="../includes/sidebar.jsp" />
<div id="content" class="d-flex flex-column">
    <jsp:include page="../includes/navbar.jsp" />
    <main class="container-fluid px-3 px-lg-4 pb-5">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div><div class="page-kicker">Customer relationships</div><h1 class="h3 fw-bold mb-1">Customer Accounts</h1><p class="text-muted mb-0">Find customers and manage account access.</p></div>
            <div class="customer-total"><i class="bi bi-people me-2"></i><strong id="customerVisibleCount">0</strong> accounts shown</div>
        </div>
        <c:if test="${not empty msg}"><div class="alert alert-info alert-dismissible fade show border-0 shadow-sm" role="status"><i class="bi bi-info-circle me-2"></i><c:out value="${msg}"/><button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div></c:if>

        <section class="lux-card p-3 p-lg-4 mb-3">
            <div class="row g-3 align-items-end">
                <div class="col-12 col-lg-6"><label for="customerSearch" class="form-label small fw-semibold text-secondary">Search accounts</label><div class="input-group"><span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span><input id="customerSearch" type="search" class="form-control" placeholder="Name, email, phone or account ID" autocomplete="off"></div></div>
                <div class="col-6 col-lg-3"><label for="customerRoleFilter" class="form-label small fw-semibold text-secondary">Account role</label><select id="customerRoleFilter" class="form-select"><option value="all">All roles</option><option value="user">Customer</option><option value="admin">Admin</option></select></div>
                <div class="col-6 col-lg-2"><label for="customerStatusFilter" class="form-label small fw-semibold text-secondary">Account status</label><select id="customerStatusFilter" class="form-select"><option value="all">All statuses</option><option value="active">Active</option><option value="inactive">Inactive</option></select></div>
                <div class="col-12 col-lg-1"><button type="button" id="resetCustomerFilters" class="btn btn-light border w-100">Reset</button></div>
            </div>
        </section>

        <section class="lux-card overflow-hidden">
            <div class="px-3 px-lg-4 py-3 border-bottom d-flex justify-content-between align-items-center"><div><h2 class="h6 fw-bold mb-1">Accounts</h2><p class="small text-muted mb-0">Passwords are never displayed or included in this list.</p></div><span class="badge text-bg-light border rounded-pill">Account directory</span></div>
            <div class="table-responsive"><table class="table table-hover align-middle mb-0 customer-table">
                <thead><tr><th class="ps-4">Account</th><th>Email</th><th>Phone</th><th>Role</th><th>Status</th><th class="text-end pe-4">Action</th></tr></thead>
                <tbody>
                <c:forEach items="${users}" var="account">
                    <tr class="customer-row" data-id="${account.id}" data-name="<c:out value='${account.name}'/>" data-email="<c:out value='${account.email}'/>" data-phone="<c:out value='${account.phone}'/>" data-role="<c:out value='${account.role}'/>" data-enabled="${account.enabled}">
                        <td class="ps-4"><div class="d-flex align-items-center gap-3"><span class="customer-avatar"><c:out value="${empty account.name ? '?' : account.name.substring(0,1)}"/></span><span><strong class="d-block"><c:out value="${account.name}"/></strong><small class="text-muted">Account #${account.id}</small></span></div></td>
                        <td><c:out value="${account.email}"/></td><td><c:out value="${empty account.phone ? '—' : account.phone}"/></td>
                        <td><span class="badge rounded-pill bg-light text-dark border text-capitalize"><c:out value="${account.role}"/></span></td>
                        <td><c:choose><c:when test="${account.enabled}"><span class="account-status active"><span></span>Active</span></c:when><c:otherwise><span class="account-status inactive"><span></span>Inactive</span></c:otherwise></c:choose></td>
                        <td class="text-end pe-4"><a href="${pageContext.request.contextPath}/admin-users?mode=edit&amp;id=${account.id}" class="btn btn-sm btn-outline-success rounded-3"><i class="bi bi-pencil me-1"></i>Manage</a></td>
                    </tr>
                </c:forEach>
                <tr id="noCustomerMatches" style="display:none"><td colspan="6" class="text-center py-5"><i class="bi bi-people fs-2 text-muted d-block mb-2"></i><strong>No matching accounts</strong><p class="small text-muted mb-0">Change the filters or reset your search.</p></td></tr>
                <c:if test="${empty users}"><tr><td colspan="6" class="text-center py-5"><i class="bi bi-person-plus fs-2 text-muted d-block mb-2"></i><strong>No accounts found</strong></td></tr></c:if>
                </tbody>
            </table></div>
        </section>
    </main>
</div>
<jsp:include page="../includes/scripts.jsp" />
<script>
(function(){
 const search=document.getElementById('customerSearch'), role=document.getElementById('customerRoleFilter'), status=document.getElementById('customerStatusFilter'), reset=document.getElementById('resetCustomerFilters');
 const rows=Array.from(document.querySelectorAll('.customer-row')), count=document.getElementById('customerVisibleCount'), empty=document.getElementById('noCustomerMatches');
 if(!search||!role||!status)return;
 function filter(){const q=search.value.trim().toLowerCase(), r=role.value, st=status.value;let shown=0;
 rows.forEach(row=>{const text=[row.dataset.id,row.dataset.name,row.dataset.email,row.dataset.phone].join(' ').toLowerCase();const rr=(row.dataset.role||'').toLowerCase();const active=row.dataset.enabled==='true';const ok=(!q||text.includes(q))&&(r==='all'||rr===r)&&(st==='all'||(st==='active'&&active)||(st==='inactive'&&!active));row.hidden=!ok;if(ok)shown++;});
 if(count)count.textContent=shown;if(empty)empty.style.display=shown===0&&rows.length>0?'':'none';}
 [search,role,status].forEach(el=>el.addEventListener(el===search?'input':'change',filter));
 if(reset)reset.addEventListener('click',()=>{search.value='';role.value='all';status.value='all';filter();search.focus();});filter();
})();
</script>
<style>
.customer-total{padding:.7rem 1rem;border:1px solid var(--lux-border);background:#fff;border-radius:12px;color:var(--lux-text-muted);font-size:.88rem}.customer-total strong{color:var(--lux-emerald)}.customer-table thead th{padding:1rem .8rem;background:#fafcfb;color:#7b847e;font-size:.68rem;letter-spacing:.08em;text-transform:uppercase;white-space:nowrap}.customer-row[hidden]{display:none!important}.customer-avatar{width:38px;height:38px;display:grid;place-items:center;border-radius:12px;background:rgba(27,67,50,.09);color:var(--lux-emerald);font-weight:800;text-transform:uppercase}.account-status{display:inline-flex;align-items:center;gap:.45rem;font-size:.78rem;font-weight:700}.account-status>span{width:7px;height:7px;border-radius:50%;background:#198754}.account-status.inactive>span{background:#dc3545}.account-status.inactive{color:#b02a37}.account-status.active{color:#198754}
</style>
</body></html>
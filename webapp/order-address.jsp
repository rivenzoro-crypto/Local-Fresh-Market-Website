<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Shipping Address — Fresh Market</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>body{background:#f7f8f5;color:#20352d}.address-wrap{max-width:760px}.address-card{border:0;border-radius:22px;box-shadow:0 12px 36px rgba(25,50,38,.08)}.btn-market{background:#2c4a3e;color:#fff;border-radius:50rem;padding:.8rem 1.4rem;font-weight:650}.btn-market:hover{background:#1c3228;color:#fff}.form-control,.form-select{border-radius:12px;padding:.75rem}</style>
</head><body>
<jsp:include page="components/menuBar.jsp" />
<main class="container py-5 address-wrap">
  <a href="${pageContext.request.contextPath}/carts?mode=view" class="text-decoration-none text-secondary small"><i class="bi bi-arrow-left me-1"></i>Back to cart</a>
  <div class="mt-3 mb-4"><div class="text-uppercase small fw-bold text-success" style="letter-spacing:2px">Delivery information</div><h1 class="h2 fw-bold mb-1">Shipping Address</h1><p class="text-secondary mb-0">Enter where you want your order delivered. Delivery is currently available in Mandalay only.</p></div>
  <div class="card address-card"><div class="card-body p-4 p-md-5">
    <c:if test="${not empty addressError}"><div class="alert alert-danger rounded-3"><c:out value="${addressError}"/></div></c:if>
    <form action="${pageContext.request.contextPath}/orders" method="post">
      <input type="hidden" name="mode" value="create"><input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
      <div class="mb-3"><label class="form-label fw-semibold" for="city">City <span class="text-danger">*</span></label><select class="form-select" id="city" name="city" required><option value="">Select city</option><option value="Mandalay" selected>Mandalay</option></select><div class="form-text">Only Mandalay is supported at this time.</div></div>
      <div class="mb-3"><label class="form-label fw-semibold" for="township">Township <span class="text-danger">*</span></label><input class="form-control" id="township" name="township" maxlength="100" value="<c:out value='${township}'/>" placeholder="Enter township" required></div>
      <div class="mb-3"><label class="form-label fw-semibold" for="street">Street / Road / Building <span class="text-danger">*</span></label><input class="form-control" id="street" name="street" maxlength="255" value="<c:out value='${street}'/>" placeholder="House no., street, road, ward or landmark" required></div>
      <div class="mb-4"><label class="form-label fw-semibold" for="description">Additional Description</label><textarea class="form-control" id="description" name="description" rows="3" maxlength="500" placeholder="Delivery instructions, nearby landmark, etc."><c:out value="${description}"/></textarea><div class="form-text">Optional, up to 500 characters.</div></div>
      <div class="d-flex flex-column flex-sm-row gap-2 justify-content-between"><a href="${pageContext.request.contextPath}/carts?mode=view" class="btn btn-outline-secondary rounded-pill px-4 py-3">Back to Cart</a><button type="submit" class="btn btn-market"><i class="bi bi-bag-check-fill me-2"></i>Confirm Address & Place Order</button></div>
    </form>
  </div></div>
</main><script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script></body></html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Product unavailable — Fresh Market</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <jsp:include page="components/menuBar.jsp" />
    <main class="container py-5 text-center">
        <div class="bg-white rounded-4 shadow-sm p-5 mx-auto" style="max-width:560px">
            <i class="bi bi-box-seam display-3 text-secondary" aria-hidden="true"></i>
            <h1 class="h3 mt-3">Product unavailable</h1>
            <p class="text-secondary"><c:out value="${msg}"/></p>
            <a class="btn btn-success rounded-pill px-4" href="${pageContext.request.contextPath}/home">Back to shopping</a>
        </div>
    </main>
    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>

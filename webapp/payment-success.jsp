<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Payment Result</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>


<body class="bg-light">

<c:import url="components/menuBar.jsp" />


<div class="container py-5">

    <div class="row justify-content-center">

        <div class="col-md-7">

            <div class="card shadow border-0 text-center">

                <div class="card-body p-5">


                    <c:choose>


                        <c:when test="${payment.paymentStatus == 'COMPLETED'}">

                            <i
                                class="bi bi-check-circle-fill text-success"
                                style="font-size: 5rem;">

                            </i>


                            <h2 class="mt-3">

                                Payment Successful!

                            </h2>


                            <p class="text-muted">

                                Your payment has been completed successfully.

                            </p>

                        </c:when>


                        <c:otherwise>

                            <i
                                class="bi bi-clock-history text-warning"
                                style="font-size: 5rem;">

                            </i>


                            <h2 class="mt-3">

                                Payment Pending

                            </h2>


                            <p class="text-muted">

                                Your payment will be completed later.

                            </p>

                        </c:otherwise>


                    </c:choose>


                    <hr class="my-4">


                    <p>

                        <strong>Order ID:</strong>

                        #${order.id}

                    </p>


                    <p>

                        <strong>Payment Method:</strong>

                        ${payment.paymentMethod}

                    </p>


                    <p>

                        <strong>Amount:</strong>

                        $<fmt:formatNumber
                            value="${payment.amount}"
                            pattern="#,##0.00" />

                    </p>


                    <p>

                        <strong>Status:</strong>

                        ${payment.paymentStatus}

                    </p>


                    <a
                        href="orders?mode=detail&id=${order.id}"
                        class="btn btn-success mt-3">

                        View Order

                    </a>

                </div>

            </div>

        </div>

    </div>

</div>

</body>

</html>
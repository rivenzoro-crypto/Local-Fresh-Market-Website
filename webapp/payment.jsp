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

    <title>Payment</title>

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

        <div class="col-md-8 col-lg-6">

            <div class="card shadow border-0">

                <div class="card-header bg-success text-white p-4">

                    <h3 class="mb-0">

                        <i class="bi bi-credit-card"></i>

                        Payment

                    </h3>

                </div>


                <div class="card-body p-4">


                    <!-- ERROR MESSAGE -->

                    <c:if test="${not empty msg}">

                        <div class="alert alert-danger">

                            ${msg}

                        </div>

                    </c:if>


                    <!-- ORDER SUMMARY -->

                    <div class="mb-4">

                        <h5>Order Summary</h5>

                        <hr>

                        <div class="d-flex justify-content-between">

                            <span>Order ID</span>

                            <strong>#${order.id}</strong>

                        </div>


                        <div class="d-flex justify-content-between mt-2">

                            <span>Total Amount</span>

                            <strong class="text-success fs-4">

                                $<fmt:formatNumber
                                    value="${order.totalAmount}"
                                    pattern="#,##0.00" />

                            </strong>

                        </div>

                    </div>


                    <!-- PAYMENT FORM -->

                    <form action="payments" method="post">

                        <input
                            type="hidden"
                            name="orderId"
                            value="${order.id}" />


                        <h5 class="mb-3">

                            Select Payment Method

                        </h5>


                        <!-- KBZ PAY -->

                        <div class="form-check border rounded p-3 mb-3">

                            <input
                                class="form-check-input"
                                type="radio"
                                name="paymentMethod"
                                id="kbzpay"
                                value="KBZPAY"
                                required>

                            <label
                                class="form-check-label fw-bold"
                                for="kbzpay">

                                KBZPay

                            </label>

                        </div>


                        <!-- WAVE PAY -->

                        <div class="form-check border rounded p-3 mb-3">

                            <input
                                class="form-check-input"
                                type="radio"
                                name="paymentMethod"
                                id="wavepay"
                                value="WAVEPAY">

                            <label
                                class="form-check-label fw-bold"
                                for="wavepay">

                                WavePay

                            </label>

                        </div>


                        <!-- CASH ON DELIVERY -->

                        <div class="form-check border rounded p-3 mb-4">

                            <input
                                class="form-check-input"
                                type="radio"
                                name="paymentMethod"
                                id="cod"
                                value="CASH_ON_DELIVERY">

                            <label
                                class="form-check-label fw-bold"
                                for="cod">

                                Cash on Delivery

                                <small class="d-block text-muted">

                                    Pay when your order arrives.

                                </small>

                            </label>

                        </div>


                        <button
                            type="submit"
                            class="btn btn-success w-100 py-2">

                            <i class="bi bi-lock-fill"></i>

                            Confirm Payment

                        </button>


                        <a
                            href="orders?mode=detail&id=${order.id}"
                            class="btn btn-outline-secondary w-100 mt-2">

                            Cancel

                        </a>

                    </form>

                </div>

            </div>

        </div>

    </div>

</div>

</body>

</html>
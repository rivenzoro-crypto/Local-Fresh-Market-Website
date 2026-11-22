<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">

<!-- Head Section -->
<jsp:include page="../includes/head.jsp" />

<body>


    <!-- Sidebar Component -->
    <jsp:include page="../includes/sidebar.jsp" />

    <!-- Main Content Wrapper -->
    <div id="content" class="d-flex flex-column">
        
        <!-- Top Navigation Bar -->
        <jsp:include page="../includes/navbar.jsp" />

        <!-- Main Body Content -->
        <main class="container-fluid p-4">
        
	        
	
	    <!-- Success / Error Notification -->
	    <c:if test="${not empty msg}">
	        <div class="alert alert-info alert-dismissible fade show rounded-3 shadow-sm"
	             role="status">
	            <c:out value="${msg}"/>
	
	            <button type="button"
	                    class="btn-close"
	                    data-bs-dismiss="alert"
	                    aria-label="Close">
	            </button>
	        </div>
	    </c:if>

   
            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 fw-bold m-0" style="color: var(--lux-text-primary);">Product Catalog</h1>
                    <p class="text-muted small m-0">Manage fresh items, pricing, and stock levels</p>
                </div>
                <button class="btn btn-lux-primary rounded-pill px-4 py-2 text-white fw-semibold shadow-sm" style="background: var(--lux-emerald); border: none;" data-bs-toggle="modal" data-bs-target="#addProductModal">
                    <i class="bi bi-plus-lg me-2"></i>Add New Product
                </button>
            </div>

            <!-- Inventory filters -->
            <section class="lux-card p-3 p-lg-4 mb-3 product-filter-panel" aria-label="Filter products">
                <div class="row g-3 align-items-end">
                    <div class="col-12 col-lg-5">
                        <label for="productSearch" class="form-label small fw-semibold text-secondary">Search products</label>
                        <div class="input-group"><span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span><input id="productSearch" type="search" class="form-control" placeholder="Name, product ID or description" autocomplete="off"></div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <label for="productCategoryFilter" class="form-label small fw-semibold text-secondary">Category</label>
                        <select id="productCategoryFilter" class="form-select"><option value="all">All categories</option><c:forEach var="category" items="${categories}"><option value="<c:out value='${category.name}'/>"><c:out value="${category.name}"/></option></c:forEach></select>
                    </div>
                    <div class="col-6 col-lg-2">
                        <label for="productStockFilter" class="form-label small fw-semibold text-secondary">Stock</label>
                        <select id="productStockFilter" class="form-select"><option value="all">All stock</option><option value="available">Healthy stock (&gt;10)</option><option value="low">Low stock (1–10)</option><option value="out">Out of stock</option></select>
                    </div>
                    <div class="col-6 col-lg-2">
                        <label for="productStatusFilter" class="form-label small fw-semibold text-secondary">Status</label>
                        <select id="productStatusFilter" class="form-select"><option value="all">All statuses</option><option value="true">Active</option><option value="false">Inactive</option></select>
                    </div>
                    <div class="col-6 col-lg-2 d-flex flex-column justify-content-end gap-2">
                        <button type="button" id="resetProductFilters" class="btn btn-light border">Reset filters</button>
                        <span class="small text-muted text-nowrap text-center" aria-live="polite"><strong id="productVisibleCount">0</strong> shown</span>
                    </div>
                </div>
            </section>

            <!-- Products Table Card -->
            <div class="lux-card border-0">
                <div class="card-header bg-white py-3 border-bottom border-light d-flex justify-content-between align-items-center">
                    <h5 class="card-title m-0 fw-bold">Inventory List</h5>
                    <span class="small text-muted">Manage active and inactive catalog items</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" style="font-size: 0.875rem;">
                            <thead class="text-uppercase text-muted" style="font-size: 0.7rem; letter-spacing: 1px; background-color: rgba(0,0,0,0.015);">
                                <tr>
                                    <th scope="col" class="ps-4 py-3">ID</th>
                                    <th scope="col" class="py-3">Visual</th>
                                    <th scope="col" class="py-3">Product Name</th>
                                    <th scope="col" class="py-3">Category</th>
                                    <th scope="col" class="py-3">Description</th>
                                    <th scope="col" class="py-3">Price</th>
                                    <th scope="col" class="py-3">Stock</th>
                                    <th scope="col" class="py-3">Status</th>
                                    <th scope="col" class="text-end pe-4 py-3">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${products}">
                                    <tr class="product-row"
                                        data-id="${product.id}"
                                        data-name="<c:out value='${product.name}'/>"
                                        data-description="<c:out value='${product.description}'/>"
                                        data-category="<c:out value='${not empty product.categoryName ? product.categoryName : "Uncategorized"}'/>"
                                        data-stock="${product.stock}"
                                        data-active="${product.active}">
                                        <td class="ps-4 text-muted">#${product.id}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty product.imageUrl}">
                                                    <img src="${pageContext.request.contextPath}/<c:out value='${product.imageUrl}'/>" alt="<c:out value='${product.name}'/>" class="rounded-3 border" style="width: 42px; height: 42px; object-fit: cover;" />
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="bg-light rounded-3 border d-flex align-items-center justify-content-center text-muted" style="width: 42px; height: 42px;">
                                                        <i class="bi bi-flower1"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><span class="fw-semibold text-dark"><c:out value="${product.name}"/></span></td>
                                        <td><span class="badge bg-light text-success border"><c:out value="${not empty product.categoryName ? product.categoryName : 'Uncategorized'}"/></span></td>
                                        <td>
                                            <span class="text-truncate d-inline-block text-muted" style="max-width: 180px;" title="<c:out value='${product.description}'/>">
                                                <c:out value="${product.description}"/>
                                            </span>
                                        </td>
                                        <td class="fw-bold text-dark"><fmt:formatNumber value="${product.price}" pattern="#,##0.00"/> MMK</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${product.stock > 10}">
                                                    <span class="badge rounded-pill px-2.5 py-1.5 fw-medium" style="background: rgba(108, 117, 125, 0.1); color: #495057;">${product.stock} in stock</span>
                                                </c:when>
                                                <c:when test="${product.stock > 0}">
                                                    <span class="badge rounded-pill px-2.5 py-1.5 fw-medium" style="background: rgba(212, 175, 55, 0.15); color: #9E7D0A;">Low Stock (${product.stock})</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge rounded-pill px-2.5 py-1.5 fw-medium" style="background: rgba(220, 53, 69, 0.1); color: #dc3545;">Out of Stock</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${product.active}">
                                                    <span class="badge rounded-pill px-2.5 py-1.5 fw-medium" style="background: rgba(27, 67, 50, 0.1); color: var(--lux-emerald);">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge rounded-pill px-2.5 py-1.5 fw-medium" style="background: rgba(220, 53, 69, 0.1); color: #dc3545;">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end pe-4">
                                            <button class="btn btn-sm btn-outline-success me-1 rounded-circle p-1" style="width: 28px; height: 28px; display: inline-flex; align-items: center; justify-content: center;" title="Edit Product" data-bs-toggle="modal" data-bs-target="#editProductModal${product.id}">
                                                <i class="bi bi-pencil" style="font-size: 0.75rem;"></i>
                                            </button>
                                            <form action="admin-products" method="post" class="d-inline" onsubmit="return confirm('Deactivate this product? It will no longer appear in the customer catalog.');">
                                                <input type="hidden" name="mode" value="delete">
                                                <input type="hidden" name="id" value="${product.id}">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-circle p-1" style="width:28px;height:28px" title="Deactivate product" aria-label="Deactivate product"><i class="bi bi-trash" style="font-size:.75rem"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <tr id="noProductMatches" style="display:none"><td colspan="9" class="text-center py-5"><i class="bi bi-search fs-2 text-muted d-block mb-2"></i><strong>No products match these filters</strong><div class="small text-muted mt-1">Try another keyword or reset the filters.</div></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <!-- OUTSIDE THE TABLE: Edit Product Modals rendered cleanly per item -->
    <c:forEach var="product" items="${products}">
        <div class="modal fade" id="editProductModal${product.id}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                    <div class="modal-header border-0 px-4 pt-4 pb-2" style="background: rgba(27, 67, 50, 0.04);">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-3 p-2 bg-success bg-opacity-10 text-success d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                <i class="bi bi-pencil-square fs-5"></i>
                            </div>
                            <div>
                                <h5 class="modal-title fw-bold m-0" style="color: var(--lux-emerald);">Edit Product Item</h5>
                                <span class="text-muted small">Reference Code: #${product.id}</span>
                            </div>
                        </div>
                        <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    
                    <form action="admin-products" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <input type="hidden" name="mode" value="update">
                        <input type="hidden" name="id" value="${product.id}" />
                        <input type="hidden" name="existingImageUrl" value="<c:out value='${product.imageUrl}'/>" />

                        <div class="modal-body p-4">
                            <div class="row g-3">
                                <div class="col-md-8">
                                    <label class="form-label fw-semibold small text-secondary">Product Name</label>
                                    <input type="text" class="form-control rounded-3 py-2" name="name" value="<c:out value='${product.name}'/>" required />
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold small text-secondary">Price (MMK)</label>
                                    <input type="number" step="0.01" class="form-control rounded-3 py-2" name="price" value="${product.price}" required />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-secondary">Stock Quantity</label>
                                    <input type="number" class="form-control rounded-3 py-2" name="stock" value="${product.stock}" required />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-secondary">Status</label>
                                    <select class="form-select rounded-3 py-2" name="active">
                                        <option value="true" ${product.active ? 'selected' : ''}>Active</option>
                                        <option value="false" ${!product.active ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-semibold small text-secondary" for="editCategory${product.id}">Category</label>
                                    <select class="form-select rounded-3 py-2" id="editCategory${product.id}" name="categoryId" required>
                                        <option value="">Choose category</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.id}" ${product.categoryId eq category.id ? 'selected' : ''}><c:out value="${category.name}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-semibold small text-secondary">Description</label>
                                    <textarea class="form-control rounded-3" name="description" rows="3"><c:out value="${product.description}"/></textarea>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-semibold small text-secondary">Product Image File</label>
                                    <input type="file" class="form-control rounded-3 py-2" name="imageFile" accept="image/*" />
                                    <c:if test="${not empty product.imageUrl}">
                                        <div class="d-flex align-items-center gap-2 mt-2 p-2 rounded-3 bg-light border border-light">
                                            <img src="${pageContext.request.contextPath}/<c:out value='${product.imageUrl}'/>" alt="Current product image" class="rounded border" style="width: 32px; height: 32px; object-fit: cover;" />
                                            <small class="text-muted text-truncate">Current: <code><c:out value="${product.imageUrl}"/></code></small>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Special Sale Settings (Edit Modal) -->
                                <div class="col-12">
                                    <div class="special-sale-section">
                                        <h4 class="fs-6 fw-bold mb-3" style="color: var(--lux-emerald);"> Special Sale Settings</h4>

                                        <div class="form-check form-switch mb-3 special-sale-toggle">
                                            <input class="form-check-input special-sale-checkbox" type="checkbox" id="editSpecialSale${product.id}" name="specialSale" value="true" ${product.specialSale ? 'checked' : ''}>
                                            <label class="form-check-label fw-semibold text-secondary" for="editSpecialSale${product.id}">Enable Special Sale</label>
                                        </div>

                                        <div class="sale-settings-container" style="display: ${product.specialSale ? 'block' : 'none'};">
                                            <div class="mb-3">
                                                <label class="form-label small text-secondary">Discount Type</label>
                                                <select class="form-select rounded-3 py-2" name="discountType">
                                                    <option value="">Select discount type</option>
                                                    <option value="PERCENT" ${product.discountType eq 'PERCENT' ? 'selected' : ''}>Percentage (%)</option>
                                                    <option value="FIXED" ${product.discountType eq 'FIXED' ? 'selected' : ''}>Fixed Amount (MMK)</option>
                                                </select>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label small text-secondary">Discount Value</label>
                                                <input type="number" class="form-control rounded-3 py-2" name="discountValue" min="0" step="0.01" placeholder="Enter discount" value="${product.discountValue}">
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label small text-secondary">Sale Start Date</label>
                                                <input type="datetime-local" class="form-control rounded-3 py-2" name="saleStartDate" value="${product.saleStartDate}">
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label small text-secondary">Sale End Date</label>
                                                <input type="datetime-local" class="form-control rounded-3 py-2" name="saleEndDate" value="${product.saleEndDate}">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <div class="modal-footer border-0 px-4 pb-4 pt-0">
                            <button type="button" class="btn btn-light rounded-pill px-4 py-2" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn rounded-pill px-4 py-2 text-white fw-semibold shadow-sm" style="background: var(--lux-emerald);">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </c:forEach>

    <!-- Add New Product Modal -->
    <div class="modal fade" id="addProductModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header border-0 px-4 pt-4 pb-2" style="background: rgba(27, 67, 50, 0.04);">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rounded-3 p-2 bg-success bg-opacity-10 text-success d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                            <i class="bi bi-plus-circle fs-5"></i>
                        </div>
                        <div>
                            <h5 class="modal-title fw-bold m-0" style="color: var(--lux-emerald);">Add New Product Item</h5>
                            <span class="text-muted small">Insert fresh inventory item into catalog</span>
                        </div>
                    </div>
                    <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <form action="admin-products" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="mode" value="save">
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-8">
                                <label for="addName" class="form-label fw-semibold small text-secondary">Product Name</label>
                                <input type="text" class="form-control rounded-3 py-2" id="addName" name="name" placeholder="e.g. Organic Heirloom Tomatoes" required />
                            </div>
                            <div class="col-md-4">
                                <label for="addPrice" class="form-label fw-semibold small text-secondary">Price (MMK)</label>
                                <input type="number" step="0.01" class="form-control rounded-3 py-2" id="addPrice" name="price" placeholder="0.00" required />
                            </div>
                            <div class="col-md-6">
                                <label for="addStock" class="form-label fw-semibold small text-secondary">Stock Quantity</label>
                                <input type="number" class="form-control rounded-3 py-2" id="addStock" name="stock" placeholder="0" required />
                            </div>
                            <div class="col-md-6">
                                <label for="addActive" class="form-label fw-semibold small text-secondary">Status</label>
                                <select class="form-select rounded-3 py-2" id="addActive" name="active">
                                    <option value="true" selected>Active</option>
                                    <option value="false">Inactive</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label for="addCategory" class="form-label fw-semibold small text-secondary">Category</label>
                                <select class="form-select rounded-3 py-2" id="addCategory" name="categoryId" required>
                                    <option value="">Choose category</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.id}"><c:out value="${category.name}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-12">
                                <label for="addDescription" class="form-label fw-semibold small text-secondary">Description</label>
                                <textarea class="form-control rounded-3" id="addDescription" name="description" rows="3" placeholder="Enter harvest notes or origins..."></textarea>
                            </div>
                            <div class="col-12">
                                <label for="addImage" class="form-label fw-semibold small text-secondary">Product Image File</label>
                                <input type="file" class="form-control rounded-3 py-2" id="addImage" name="imageFile" accept="image/*" />
                            </div>

                            <!-- Special Sale Settings (Add Modal) -->
                            <div class="col-12">
                                <div class="special-sale-section">
                                    <h4 class="fs-6 fw-bold mb-3" style="color: var(--lux-emerald);"> Special Sale Settings</h4>

                                    <div class="form-check form-switch mb-3 special-sale-toggle">
                                        <input class="form-check-input special-sale-checkbox" type="checkbox" id="addSpecialSale" name="specialSale" value="true">
                                        <label class="form-check-label fw-semibold text-secondary" for="addSpecialSale">Enable Special Sale</label>
                                    </div>

                                    <div class="sale-settings-container" style="display: none;">
                                        <div class="mb-3">
                                            <label class="form-label small text-secondary">Discount Type</label>
                                            <select class="form-select rounded-3 py-2" name="discountType">
                                                <option value="">Select discount type</option>
                                                <option value="PERCENT">Percentage (%)</option>
                                                <option value="FIXED">Fixed Amount (MMK)</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small text-secondary">Discount Value</label>
                                            <input type="number" class="form-control rounded-3 py-2" name="discountValue" min="0" step="0.01" placeholder="Enter discount">
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small text-secondary">Sale Start Date</label>
                                            <input type="datetime-local" class="form-control rounded-3 py-2" name="saleStartDate">
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small text-secondary">Sale End Date</label>
                                            <input type="datetime-local" class="form-control rounded-3 py-2" name="saleEndDate">
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="modal-footer border-0 px-4 pb-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 py-2" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn rounded-pill px-4 py-2 text-white fw-semibold shadow-sm" style="background: var(--lux-emerald);">Create Product</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts Component -->
    <jsp:include page="../includes/scripts.jsp" />
    <script>
    (function () {
        const search = document.getElementById('productSearch');
        const category = document.getElementById('productCategoryFilter');
        const stock = document.getElementById('productStockFilter');
        const status = document.getElementById('productStatusFilter');
        const reset = document.getElementById('resetProductFilters');
        const count = document.getElementById('productVisibleCount');
        const rows = Array.from(document.querySelectorAll('.product-row'));
        const empty = document.getElementById('noProductMatches');
        if (!search || !category || !stock || !status) return;
        function applyFilters() {
            const term = search.value.trim().toLowerCase();
            const selectedCategory = category.value.toLowerCase();
            const selectedStock = stock.value;
            const selectedStatus = status.value;
            let visible = 0;
            rows.forEach(row => {
                const haystack = [row.dataset.id, row.dataset.name, row.dataset.description].join(' ').toLowerCase();
                const rowCategory = (row.dataset.category || '').toLowerCase();
                const qty = Number(row.dataset.stock || 0);
                const matchesTerm = !term || haystack.includes(term);
                const matchesCategory = selectedCategory === 'all' || rowCategory === selectedCategory;
                const matchesStock = selectedStock === 'all'
                    || (selectedStock === 'available' && qty > 10)
                    || (selectedStock === 'low' && qty > 0 && qty <= 10)
                    || (selectedStock === 'out' && qty <= 0);
                const matchesStatus = selectedStatus === 'all' || row.dataset.active === selectedStatus;
                const show = matchesTerm && matchesCategory && matchesStock && matchesStatus;
                row.hidden = !show;
                if (show) visible++;
            });
            if (empty) empty.style.display = visible === 0 ? '' : 'none';
            if (count) count.textContent = visible;
        }
        [search, category, stock, status].forEach(el => el.addEventListener(el === search ? 'input' : 'change', applyFilters));
        if (reset) reset.addEventListener('click', () => { search.value = ''; category.value = 'all'; stock.value = 'all'; status.value = 'all'; applyFilters(); search.focus(); });
        applyFilters();
    })();
    </script>
    
    <style>
    .product-filter-panel { border: 1px solid var(--lux-border); }
    .product-row[hidden] { display: none !important; }
    .special-sale-section {
        margin-top: 15px;
        padding: 18px;
        border: 1px solid #e5e7eb;
        border-radius: 10px;
        background: #fafafa;
    }
    </style>

    <script>
    document.addEventListener("DOMContentLoaded", function () {
        // Handle toggling for all special sale checkboxes across Add and Edit modals
        document.querySelectorAll(".special-sale-checkbox").forEach(function (checkbox) {
            const container = checkbox.closest(".special-sale-section").querySelector(".sale-settings-container");
            
            function toggleContainer() {
                if (checkbox.checked) {
                    container.style.display = "block";
                } else {
                    container.style.display = "none";
                }
            }

            checkbox.addEventListener("change", toggleContainer);
            toggleContainer(); // Run on load to respect pre-checked edit states
        });
    });
    </script>

</body>
</html>
package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import dao.CategoryDAO;
import dao.ProductDAO;
import entity.Category;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import util.CsrfUtil;

@WebServlet("/admin-products")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15)
public class AdminProductController extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String mode = req.getParameter("mode");
        if (mode != null && !"all".equals(mode)) {
            resp.sendRedirect(req.getContextPath() + "/admin-products?mode=all");
            return;
        }
        showAdminProductPage(req, resp);
    }

    private void showAdminProductPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        CsrfUtil.ensureToken(session);
        List<Product> products = productDAO.getAllProducts();
        List<Category> categories = categoryDAO.getActiveCategories();
        req.setAttribute("products", products);
        req.setAttribute("categories", categories);

        Object message = session.getAttribute("msg");
        if (message != null) {
            req.setAttribute("msg", message.toString());
            session.removeAttribute("msg");
        }
        req.setAttribute("currentPage", "products");
        req.getRequestDispatcher("admin/admin-products.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !CsrfUtil.isValid(req, session)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or expired form token.");
            return;
        }

        String mode = req.getParameter("mode");
        try {
            switch (mode == null ? "" : mode) {
                case "save" -> saveProduct(req, session);
                case "update" -> updateProduct(req, session);
                case "delete" -> deleteProduct(req, session);
                default -> session.setAttribute("msg", "Unsupported product action.");
            }
        } catch (NumberFormatException ex) {
            session.setAttribute("msg", "Please enter a valid product ID, price, stock and category.");
        } catch (IllegalArgumentException ex) {
            session.setAttribute("msg", ex.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin-products?mode=all");
    }

    private void saveProduct(HttpServletRequest req, HttpSession session)
            throws IOException, ServletException {
        Product product = readProduct(req, null);
        Part filePart = req.getPart("imageFile");
        product.setImageUrl(filePart != null && filePart.getSize() > 0 ? saveUploadedImage(filePart) : null);
        boolean saved = productDAO.createProduct(product);
        session.setAttribute("msg", saved ? "Product created successfully." : "Could not create product. Check the database log.");
    }

    private void updateProduct(HttpServletRequest req, HttpSession session)
            throws IOException, ServletException {
        Long id = parsePositiveLong(req.getParameter("id"));
        Product product = readProduct(req, id);
        String existingImageUrl = req.getParameter("existingImageUrl");
        Part filePart = req.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            product.setImageUrl(saveUploadedImage(filePart));
        } else {
            product.setImageUrl(existingImageUrl == null || existingImageUrl.isBlank() ? null : existingImageUrl.trim());
        }
        boolean updated = productDAO.updateProduct(product);
        session.setAttribute("msg", updated ? "Product updated successfully." : "Could not update product. Check the database log.");
    }

    private void deleteProduct(HttpServletRequest req, HttpSession session) {
        Long id = parsePositiveLong(req.getParameter("id"));
        boolean deleted = productDAO.softDelete(id);
        session.setAttribute("msg", deleted ? "Product deactivated successfully." : "Could not deactivate product.");
    }

    private Product readProduct(HttpServletRequest req, Long id) {
        String name = trim(req.getParameter("name"));
        
        boolean specialSale =
                "true".equals(req.getParameter("specialSale"));

        String discountType =
                req.getParameter("discountType");

        String discountValueStr =
                req.getParameter("discountValue");

        String saleStartDateStr =
                req.getParameter("saleStartDate");

        String saleEndDateStr =
                req.getParameter("saleEndDate");
        
        String description = trim(req.getParameter("description"));
        double price = Double.parseDouble(req.getParameter("price"));
        int stock = Integer.parseInt(req.getParameter("stock"));
        long categoryId = Long.parseLong(req.getParameter("categoryId"));
        boolean active = Boolean.parseBoolean(req.getParameter("active"));

        if (name.isBlank() || name.length() > 150) {
            throw new IllegalArgumentException("Product name is required and must be 150 characters or fewer.");
        }
        if (!Double.isFinite(price) || price <= 0) {
            throw new IllegalArgumentException("Price must be greater than zero.");
        }
        if (stock < 0) {
            throw new IllegalArgumentException("Stock cannot be negative.");
        }
        Category category = categoryDAO.getActiveCategoryById(categoryId);
        if (category == null) {
            throw new IllegalArgumentException("Please choose a valid product category.");
        }

        Product product = new Product();
        if (id != null) product.setId(id);
        product.setName(name);
        product.setDescription(description);
        product.setPrice(price);
        product.setStock(stock);
        product.setActive(active);
        product.setCategoryId(categoryId);
        product.setCategoryName(category.getName());
        product.setCategorySlug(category.getSlug());
       
        product.setSpecialSale(specialSale);
        if (specialSale) {
            product.setDiscountType(discountType);

            if (discountValueStr != null && !discountValueStr.isBlank()) {
                product.setDiscountValue(Double.parseDouble(discountValueStr));
            }

            if (saleStartDateStr != null && !saleStartDateStr.isBlank()) {
                product.setSaleStartDate(java.time.LocalDateTime.parse(saleStartDateStr));
            }

            if (saleEndDateStr != null && !saleEndDateStr.isBlank()) {
                product.setSaleEndDate(java.time.LocalDateTime.parse(saleEndDateStr));
            }

            // ⚠️ Special Sale Validations
            if (discountType == null || discountType.isBlank()) {
                throw new IllegalArgumentException("Please select a discount type for the special sale.");
            }
            if (product.getDiscountValue() == null || product.getDiscountValue() <= 0) {
                throw new IllegalArgumentException("Discount value must be greater than zero.");
            }
            if ("PERCENT".equals(discountType) && product.getDiscountValue() > 100) {
                throw new IllegalArgumentException("Percentage discount must be between 1 and 100.");
            }
            if ("FIXED".equals(discountType) && product.getDiscountValue() >= price) {
                throw new IllegalArgumentException("Fixed discount must be less than the product price.");
            }
            if (product.getSaleStartDate() != null && product.getSaleEndDate() != null
                    && product.getSaleEndDate().isBefore(product.getSaleStartDate())) {
                throw new IllegalArgumentException("Sale end date must be after start date.");
            }

        } else {
            // Clear sale information
            product.setDiscountType(null);
            product.setDiscountValue(null);
            product.setSaleStartDate(null);
            product.setSaleEndDate(null);
        }
        
        return product;
    }

    private String saveUploadedImage(Part filePart) throws IOException, ServletException {
        String contentType = filePart.getContentType();
        String extension;
        if ("image/jpeg".equalsIgnoreCase(contentType)) extension = ".jpg";
        else if ("image/png".equalsIgnoreCase(contentType)) extension = ".png";
        else if ("image/webp".equalsIgnoreCase(contentType)) extension = ".webp";
        else throw new IllegalArgumentException("JPG, PNG and WEBP images only are allowed.");

        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmssSSS").format(new Date());
        String fileName = "product_" + timestamp + extension;
        File uploadDirectory = new File(System.getProperty("user.home"), "online-order-uploads");
        if (!uploadDirectory.exists() && !uploadDirectory.mkdirs()) {
            throw new IOException("Cannot create product image upload folder.");
        }
        File target = new File(uploadDirectory, fileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, target.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }
        return "product-images/" + fileName;
    }

    private Long parsePositiveLong(String value) {
        long parsed = Long.parseLong(value);
        if (parsed <= 0) throw new NumberFormatException("Value must be positive");
        return parsed;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}

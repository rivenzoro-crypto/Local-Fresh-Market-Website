package controller;

import dao.CartServiceDAO;
import dao.ProductDAO;
import dao.WholesaleApplicationDAO;
import dao.WholesalePricingDAO;
import entity.Product;
import entity.User;
import entity.WholesaleApplication;
import entity.WholesalePricing;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.CsrfUtil;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Approved wholesale customers can quickly select quantities for multiple products. */
@WebServlet("/wholesale/quick-order")
public class WholesaleQuickOrderController extends HttpServlet {
    private final WholesaleApplicationDAO applicationDAO = new WholesaleApplicationDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final WholesalePricingDAO pricingDAO = new WholesalePricingDAO();
    private final CartServiceDAO cartServiceDAO = new CartServiceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = getLoggedInUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/users?mode=login");
            return;
        }
        if (!isApproved(user)) {
            resp.sendRedirect(req.getContextPath() + "/wholesale");
            return;
        }

        CsrfUtil.ensureToken(req.getSession());
        req.setAttribute("products", productDAO.getAllActiveProducts());
        req.setAttribute("tiersByProduct", groupTiers(pricingDAO.getAll()));
        req.getRequestDispatcher("/wholesale-quick-order.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = getLoggedInUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/users?mode=login");
            return;
        }
        if (!isApproved(user)) {
            resp.sendRedirect(req.getContextPath() + "/wholesale");
            return;
        }
        if (!CsrfUtil.isValid(req, session)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or expired form token.");
            return;
        }

        String[] productValues = req.getParameterValues("productId");
        String[] quantityValues = req.getParameterValues("quantity");
        if (productValues == null || quantityValues == null || productValues.length != quantityValues.length) {
            session.setAttribute("wholesaleQuickOrderMsg", "No valid products were selected.");
            resp.sendRedirect(req.getContextPath() + "/wholesale/quick-order");
            return;
        }

        int added = 0;
        String warning = null;
        for (int i = 0; i < productValues.length; i++) {
            Long productId = parsePositiveLong(productValues[i]);
            int quantity = parseQuantity(quantityValues[i]);
            if (productId == null || quantity <= 0) continue;

            CartServiceDAO.AddResult result = cartServiceDAO.addQuantityToCart(user.getId(), productId, quantity);
            if (result == CartServiceDAO.AddResult.ADDED) {
                added++;
            } else if (warning == null) {
                warning = resultMessage(result);
            }
        }

        if (added > 0) {
            session.setAttribute("cartMessage", added + " wholesale product" + (added == 1 ? " was" : "s were") + " added to your cart. Pricing was calculated securely on the server.");
            session.setAttribute("cartMessageType", "success");
            if (warning != null) session.setAttribute("wholesaleQuickOrderMsg", warning);
            resp.sendRedirect(req.getContextPath() + "/carts?mode=view");
        } else {
            session.setAttribute("wholesaleQuickOrderMsg", warning == null
                    ? "Enter a quantity for at least one product." : warning);
            resp.sendRedirect(req.getContextPath() + "/wholesale/quick-order");
        }
    }

    private User getLoggedInUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session == null ? null : (User) session.getAttribute("loginUser");
    }

    private boolean isApproved(User user) {
        WholesaleApplication application = applicationDAO.getLatestByUserId(user.getId());
        return application != null && "APPROVED".equalsIgnoreCase(application.getStatus());
    }

    private Map<Long, List<WholesalePricing>> groupTiers(List<WholesalePricing> all) {
        Map<Long, List<WholesalePricing>> map = new HashMap<>();
        for (WholesalePricing tier : all) {
            if (tier.isActive()) {
                map.computeIfAbsent(tier.getProductId(), k -> new java.util.ArrayList<>()).add(tier);
            }
        }
        return map;
    }

    private Long parsePositiveLong(String value) {
        try {
            long parsed = Long.parseLong(value);
            return parsed > 0 ? parsed : null;
        } catch (Exception e) { return null; }
    }

    private int parseQuantity(String value) {
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : 0;
        } catch (Exception e) { return 0; }
    }

    private String resultMessage(CartServiceDAO.AddResult result) {
        switch (result) {
            case PRODUCT_NOT_FOUND: return "One selected product could not be found.";
            case PRODUCT_INACTIVE: return "One selected product is currently unavailable.";
            case OUT_OF_STOCK: return "One selected product is out of stock.";
            case STOCK_LIMIT_REACHED: return "One requested quantity exceeds the available stock.";
            default: return "Some products could not be added. Please try again.";
        }
    }
}

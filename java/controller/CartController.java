package controller;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import dao.CartDAO;
import dao.CartItemDAO;
import dao.CartServiceDAO;
import dao.CategoryDAO;
import entity.Cart;
import entity.CartItem;
import entity.Category;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.CsrfUtil;

@WebServlet("/carts")
public class CartController extends HttpServlet {
    private static final String UNDO_PRODUCT_ID = "cartUndoProductId";
    private static final String UNDO_QUANTITY = "cartUndoQuantity";
    private static final String UNDO_USER_ID = "cartUndoUserId";

    private final CartDAO cartDAO = new CartDAO();
    private final CartItemDAO cartItemDAO = new CartItemDAO();
    private final CartServiceDAO cartServiceDAO = new CartServiceDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String mode = req.getParameter("mode");
        if (mode == null || mode.isBlank() || "view".equals(mode)) {
            viewCart(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/carts?mode=view");
    }

    private void viewCart(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("loginUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/users?mode=login");
            return;
        }

        CsrfUtil.ensureToken(session);
        Cart cart = cartDAO.getCartByUserId(user.getId());
        List<CartItem> items = Collections.emptyList();
        int itemCount = 0;
        if (cart != null) {
            List<CartItem> loaded = cartItemDAO.getAllCartItemsByCartId(cart.getId());
            if (loaded != null) items = loaded;
//            for (CartItem item : items) {
//                if (item.getQty() != null && item.getQty() > 0) itemCount += item.getQty();
//                if (item.getProduct() != null) item.setPrice(item.getProduct().getPrice());
//            }
            for (CartItem item : items) {
                if (item.getQty() != null && item.getQty() > 0) itemCount += item.getQty();
                //if (item.getProduct() != null) 
                if (item.getPrice() == null && item.getProduct() != null) {
                    // Use server-side secure effective sale price instead of raw base price
                    item.setPrice(item.getProduct().getEffectivePrice());
                }
            }
            session.setAttribute("cart", cart);
        } else {
            session.removeAttribute("cart");
        }

        session.setAttribute("itemCount", itemCount);
        req.setAttribute("items", items);
        req.setAttribute("categories", categoryDAO.getActiveCategories());
        Object undoOwner = session.getAttribute(UNDO_USER_ID);
        boolean canUndo = session.getAttribute(UNDO_PRODUCT_ID) != null
                && session.getAttribute(UNDO_QUANTITY) != null
                && undoOwner instanceof Number
                && ((Number) undoOwner).longValue() == user.getId();
        req.setAttribute("canUndoRemoval", canUndo);

        Object flashMessage = session.getAttribute("cartMessage");
        if (flashMessage != null) {
            req.setAttribute("msg", flashMessage.toString());
            Object flashType = session.getAttribute("cartMessageType");
            req.setAttribute("msgType", flashType == null ? "info" : flashType.toString());
            session.removeAttribute("cartMessage");
            session.removeAttribute("cartMessageType");
        }
        req.getRequestDispatcher("cartView.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("loginUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/users?mode=login");
            return;
        }
        if (!CsrfUtil.isValid(req, session)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or expired form token.");
            return;
        }

        String mode = req.getParameter("mode");
        if ("addItem".equals(mode)) {
            addItem(req, resp, session, user);
            return;
        }
        if ("undoRemove".equals(mode)) {
            undoRemoval(req, resp, session, user);
            return;
        }

        Long itemId = parsePositiveLong(req.getParameter("cartItemId"));
        if (itemId == null) {
            setMessage(session, "That cart item could not be found.", "warning");
            redirectToCart(req, resp);
            return;
        }

        CartServiceDAO.MutationResult result;
        switch (mode == null ? "" : mode) {
            case "increaseItem":
                result = cartServiceDAO.changeQuantity(user.getId(), itemId, 1);
                clearUndo(session);
                handleMutationMessage(session, result, "Quantity increased.");
                break;
            case "decreaseItem":
                result = cartServiceDAO.changeQuantity(user.getId(), itemId, -1);
                if (result.getStatus() == CartServiceDAO.MutationStatus.REMOVED) {
                    saveUndo(session, result);
                    setMessage(session, "Item removed from your cart.", "success");
                } else {
                    clearUndo(session);
                    handleMutationMessage(session, result, "Quantity decreased.");
                }
                break;
            case "removeItem":
                result = cartServiceDAO.removeItem(user.getId(), itemId);
                if (result.getStatus() == CartServiceDAO.MutationStatus.REMOVED) {
                    saveUndo(session, result);
                    setMessage(session, "Item removed from your cart.", "success");
                } else {
                    handleMutationMessage(session, result, "");
                }
                break;
            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported cart action.");
                return;
        }
        redirectToCart(req, resp);
    }

    private void addItem(HttpServletRequest req, HttpServletResponse resp,
            HttpSession session, User user) throws IOException {
        Long productId = parsePositiveLong(req.getParameter("id"));
        if (productId == null) {
            setMessage(session, "Invalid product selection.", "warning");
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        clearUndo(session);
        CartServiceDAO.AddResult result = cartServiceDAO.addOneToCart(user.getId(), productId);
        switch (result) {
            case ADDED -> setMessage(session, "Product added to your cart.", "success");
            case PRODUCT_NOT_FOUND -> setMessage(session, "This product could not be found.", "warning");
            case PRODUCT_INACTIVE -> setMessage(session, "This product is currently unavailable.", "warning");
            case OUT_OF_STOCK -> setMessage(session, "This product is out of stock.", "warning");
            case STOCK_LIMIT_REACHED -> setMessage(session, "You have reached the available stock limit for this product.", "warning");
            default -> setMessage(session, "Could not update your cart. Please try again.", "danger");
        }

        String returnTo = req.getParameter("returnTo");
        if ("detail".equals(returnTo)) {
            resp.sendRedirect(req.getContextPath() + "/products?mode=view&id=" + productId);
        } else if ("cart".equals(returnTo)) {
            redirectToCart(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    private void undoRemoval(HttpServletRequest req, HttpServletResponse resp,
            HttpSession session, User user) throws IOException {
        Object productValue = session.getAttribute(UNDO_PRODUCT_ID);
        Object quantityValue = session.getAttribute(UNDO_QUANTITY);
        Object undoUserValue = session.getAttribute(UNDO_USER_ID);
        if (!(productValue instanceof Number) || !(quantityValue instanceof Number)
                || !(undoUserValue instanceof Number)
                || ((Number) undoUserValue).longValue() != user.getId()) {
            clearUndo(session);
            setMessage(session, "There is no recent cart removal to undo.", "warning");
            redirectToCart(req, resp);
            return;
        }

        Long productId = ((Number) productValue).longValue();
        int quantity = ((Number) quantityValue).intValue();
        CartServiceDAO.MutationResult result = cartServiceDAO.restoreRemovedItem(user.getId(), productId, quantity);
        if (result.getStatus() == CartServiceDAO.MutationStatus.RESTORED) {
            clearUndo(session);
            setMessage(session, "Item restored to your cart.", "success");
        } else {
            setMessage(session, mutationError(result.getStatus()), "warning");
        }
        redirectToCart(req, resp);
    }

    private void saveUndo(HttpSession session, CartServiceDAO.MutationResult result) {
        if (result.getProductId() != null && result.getQuantity() != null) {
            session.setAttribute(UNDO_PRODUCT_ID, result.getProductId());
            session.setAttribute(UNDO_QUANTITY, result.getQuantity());
            // Prevent an Undo action from carrying over if another account uses this session.
            Object currentUser = session.getAttribute("loginUser");
            if (currentUser instanceof User) {
                session.setAttribute(UNDO_USER_ID, ((User) currentUser).getId());
            }
        }
    }

    private void setMessage(HttpSession session, String message, String type) {
        session.setAttribute("cartMessage", message);
        session.setAttribute("cartMessageType", type);
    }

    private void clearUndo(HttpSession session) {
        session.removeAttribute(UNDO_PRODUCT_ID);
        session.removeAttribute(UNDO_QUANTITY);
        session.removeAttribute(UNDO_USER_ID);
    }

    private void handleMutationMessage(HttpSession session, CartServiceDAO.MutationResult result, String success) {
        if (result.getStatus() == CartServiceDAO.MutationStatus.UPDATED) {
            setMessage(session, success, "success");
        } else {
            setMessage(session, mutationError(result.getStatus()), "warning");
        }
    }

    private String mutationError(CartServiceDAO.MutationStatus status) {
        return switch (status) {
            case PRODUCT_INACTIVE -> "This product is no longer available.";
            case STOCK_LIMIT_REACHED -> "You cannot add more than the available stock.";
            case OUT_OF_STOCK -> "This product is currently out of stock.";
            case NOT_FOUND -> "That cart item could not be found.";
            default -> "We could not update your cart. Please try again.";
        };
    }

    private Long parsePositiveLong(String value) {
        try {
            long parsed = Long.parseLong(value);
            return parsed > 0 ? parsed : null;
        } catch (Exception ex) {
            return null;
        }
    }

    private void redirectToCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/carts?mode=view");
    }
}

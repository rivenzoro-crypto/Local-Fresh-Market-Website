package filter;

import java.io.IOException;
import entity.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {
    "/admin/*", 
    "/dashboard",
    "/admin-dashboard",
    "/admin-search",
    "/admin-products",
    "/admin-orders",
    "/admin-payments",
    "/admin-users",
    "/admin-wholesale",
    "/admin-wholesale-pricing",
    "/carts",        // Added exact path
    "/carts/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Safe null-check for login mode parameter
        if ("login".equals(request.getParameter("mode")) || 
        		"valid".equals(request.getParameter("mode"))
        		|| "check".equals(request.getParameter("mode"))) {
            chain.doFilter(httpRequest, httpResponse);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("loginUser") != null);
        
        if (isLoggedIn) {
            User user = (User) session.getAttribute("loginUser");
            String uri = httpRequest.getRequestURI();

            // Admin access check
            if ("admin".equalsIgnoreCase(user.getRole())) {
                chain.doFilter(httpRequest, httpResponse);
                return;
            }
            
            // Standard User access check for cart endpoints
            if ("user".equalsIgnoreCase(user.getRole()) && uri.contains("carts")) {
                chain.doFilter(httpRequest, httpResponse);
                return;
            }

            // Redirect logged-in users attempting unauthorized admin routes back home
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home?msg=Unauthorized access");
            
        } else {
            // Cart mutations are POST requests. Redirect them to login instead of
            // forwarding a POST into the read-only HomeController.
            if (uriIsCartRequest(httpRequest)) {
                HttpSession guestSession = httpRequest.getSession(true);
                guestSession.setAttribute("cartMessage", "Please log in before using your shopping cart.");
                guestSession.setAttribute("cartMessageType", "warning");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/users?mode=login");
                return;
            }

            // Preserve the existing behavior for other protected routes.
            httpRequest.setAttribute("msg", "Please Login First");
            httpRequest.getRequestDispatcher("/home").forward(httpRequest, httpResponse);
        }
    }

    private boolean uriIsCartRequest(HttpServletRequest request) {
        String path = request.getRequestURI().substring(request.getContextPath().length());
        return "/carts".equals(path) || path.startsWith("/carts/");
    }

    @Override
    public void destroy() {}
}
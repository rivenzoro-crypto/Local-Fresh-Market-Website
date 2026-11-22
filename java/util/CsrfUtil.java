package util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.UUID;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/** Small session-based CSRF token helper for state-changing form submissions. */
public final class CsrfUtil {

    public static final String SESSION_KEY = "csrfToken";
    private static final String PARAMETER_NAME = "csrfToken";

    private CsrfUtil() {
    }

    public static String ensureToken(HttpSession session) {
        String token = (String) session.getAttribute(SESSION_KEY);
        if (token == null || token.isEmpty()) {
            token = UUID.randomUUID().toString();
            session.setAttribute(SESSION_KEY, token);
        }
        return token;
    }

    public static boolean isValid(HttpServletRequest request, HttpSession session) {
        if (session == null) {
            return false;
        }

        String expected = (String) session.getAttribute(SESSION_KEY);
        String actual = request.getParameter(PARAMETER_NAME);
        if (expected == null || actual == null) {
            return false;
        }

        return MessageDigest.isEqual(
                expected.getBytes(StandardCharsets.UTF_8),
                actual.getBytes(StandardCharsets.UTF_8));
    }
}

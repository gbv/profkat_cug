package de.gbv.profkat.servlets;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;

import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.mycore.common.MCRSession;
import org.mycore.common.config.MCRConfiguration2;
import org.mycore.frontend.servlets.MCRErrorServlet;
import org.mycore.frontend.servlets.MCRServlet;
import org.mycore.services.i18n.MCRTranslation;
import org.mycore.util.concurrent.MCRTransactionableCallable;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Extends {@link MCRErrorServlet} to render error pages using JSP templates
 * instead of the default XSLT-based layout service.
 * <p>
 * The JSP view to use is configured via:
 * <pre>MCR.JSPDocportal.ErrorServlet.View=error</pre>
 * The view is resolved relative to {@code /WEB-INF/views/}, e.g.
 * {@code /WEB-INF/views/error.jsp}.
 */
public class MCRJSPErrorServlet extends MCRErrorServlet {

    private static final Logger LOGGER = LogManager.getLogger();

    private static final String GENERATE_ERROR_PAGE_ATTR_NAME = "MCRErrorServlet.generateErrorPage";

    private static final String ERROR_VIEW
        = MCRConfiguration2.getStringOrThrow("MCR.JSPDocportal.ErrorServlet.View");

    @Override
    protected void generateErrorPage(HttpServletRequest req, HttpServletResponse resp, String msg, Throwable ex,
        Integer statusCode, Class<? extends Throwable> exceptionType, String requestURI, String servletName) {
        int status = Objects.requireNonNullElse(statusCode, 500);
        LOGGER.log(ex != null ? Level.ERROR : Level.WARN,
            String.format(Locale.ENGLISH, "%s: Error %d occurred. The following message was given: %s",
                requestURI, status, msg), ex);

        if (resp.isCommitted() || req.getAttribute(GENERATE_ERROR_PAGE_ATTR_NAME) != null) {
            return;
        }
        resp.setStatus(status);
        req.setAttribute(GENERATE_ERROR_PAGE_ATTR_NAME, msg);

        try {
            new MCRTransactionableCallable<>(() -> {
                Map<String, Object> it = new HashMap<>();
                it.put("errorInfo", buildErrorInfo(msg, status, ex));
                req.setAttribute("it", it);
                req.getRequestDispatcher("/WEB-INF/views/" + ERROR_VIEW + ".jsp").forward(req, resp);
                return null;
            }, getSession(req)).call();
        } catch (Exception e) {
            LOGGER.error("Error generating error page", e);
        }
    }

    /**
     * Builds the error info model passed to the JSP template.
     *
     * @param msg the error message, may be {@code null}
     * @param statusCode the HTTP status code
     * @param ex the exception that caused the error, may be {@code null}
     * @return a map containing {@code message}, {@code headline} and {@code exception}
     */
    protected Map<String, Object> buildErrorInfo(String msg, int statusCode, Throwable ex) {
        Map<String, Object> errorInfo = new HashMap<>();
        errorInfo.put("message", msg);
        errorInfo.put("headline", MCRTranslation.translate("titles.pageTitle.error", statusCode));
        errorInfo.put("exception", ex);
        return errorInfo;
    }

    private MCRSession getSession(HttpServletRequest req) {
        return req.getSession(false) != null ? MCRServlet.getSession(req) : null;
    }
}

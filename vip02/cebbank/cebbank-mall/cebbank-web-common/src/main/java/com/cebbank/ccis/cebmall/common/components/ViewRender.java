package com.cebbank.ccis.cebmall.common.components;

import com.google.common.base.*;
import com.google.common.net.MediaType;
import com.spirit.common.utils.CommonConstants;
import com.spirit.core.exception.NotFound404Exception;
import com.spirit.core.render.PageRender;
import com.spirit.core.render.RenderConstants;
import com.spirit.exception.UserNotLoginException;
import com.spirit.user.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

/**
 * @author changji.zhang
 */
@Component
@Slf4j
public class ViewRender {

    private final static String REQUEST_REGION = "regionId";
    private final static String RID = "rid";

    @Autowired
    private PageRender pageRender;

    @Autowired
    private CommonConstants commonConstants;

    public void view(final String domain, final String path, HttpServletRequest request, HttpServletResponse response,
                     final Map<String, Object> context) {
        prepareContext(request, context);
        Supplier<String> getHtml = new Supplier<String>() {
            @Override
            public String get() {
                return pageRender.render(domain, path, context);
            }
        };
        render(response, getHtml);
    }

    public void view(final String domain, final String secContext, final String path, HttpServletRequest request, HttpServletResponse response,
                     final Map<String, Object> context) {
        prepareContext(request, context);
        Supplier<String> getHtml = new Supplier<String>() {
            @Override
            public String get() {
                return pageRender.renderContext(domain,secContext,path,context);
            }
        };
        render(response, getHtml);
    }

    public void layoutView(final String path, HttpServletRequest request, HttpServletResponse response,
                           final Map<String, Object> context) {
        prepareContext(request, context);
        Supplier<String> getHtml = new Supplier<String>() {
            @Override
            public String get() {
                return pageRender.nativeRender(path, context);
            }
        };
        render(response, getHtml);
    }

    public void viewTemplate(final Long instanceId, final String path, HttpServletRequest request,
                             HttpServletResponse response, final Map<String, Object> context) {
        prepareContext(request, context);
        Supplier<String> getHtml = new Supplier<String>() {
            @Override
            public String get() {
                return pageRender.renderTemplate(instanceId, path, context);
            }
        };
        render(response, getHtml);
    }

    public void viewSite(final Long instanceId, final String path, HttpServletRequest request,
                         HttpServletResponse response, final boolean isDesign, final Map<String, Object> context) {
        prepareContext(request, context);
        Supplier<String> getHtml = new Supplier<String>() {
            @Override
            public String get() {
                return pageRender.renderSite(instanceId, path, context, isDesign);
            }
        };
        render(response, getHtml);
    }

    private void prepareContext(HttpServletRequest request, Map<String, Object> context) {
        if (request != null) {
            for (Object name : request.getParameterMap().keySet()) {
                context.put((String) name, request.getParameter((String) name));
            }
            Cookie[] cookies = request.getCookies();
            Integer region = null;
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (Objects.equal(cookie.getName(), REQUEST_REGION)) {
                        try {
                            region = Integer.valueOf(cookie.getValue());
                        } catch (NumberFormatException e) {
                            log.warn("error region id: {}", cookie.getValue());
                        }
                    }
                }
            }
            if (region != null) {
                context.put(RID, region);
            }
        }
        context.put(RenderConstants.USER, UserUtil.getUser());
    }

    private void render(HttpServletResponse response, Supplier<String> getHtml) {
        String html = null;
        try {
            html = MoreObjects.firstNonNull(getHtml.get(), "");
        } catch (UserNotLoginException e) {
            try {
                response.sendRedirect("http://" + commonConstants.getMainsite() + "/login");
            } catch (IOException e1) {
            }
        } catch (Exception e) {
            Throwables.propagateIfInstanceOf(e, NotFound404Exception.class);
            log.error("render failed, cause:{}", Throwables.getStackTraceAsString(Throwables.getRootCause(e)));
        }
        try {
            response.setContentType(MediaType.HTML_UTF_8.toString());
            response.setContentLength(html.getBytes(Charsets.UTF_8).length);
            response.getWriter().write(html);
        } catch (IOException e) {
        }
    }

}

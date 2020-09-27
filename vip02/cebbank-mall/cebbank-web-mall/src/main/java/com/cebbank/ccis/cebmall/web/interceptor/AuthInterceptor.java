package com.cebbank.ccis.cebmall.web.interceptor;

import com.google.common.base.Charsets;
import com.google.common.base.Objects;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import com.google.common.io.LineProcessor;
import com.google.common.io.Resources;
import com.google.common.net.HttpHeaders;
import com.spirit.common.utils.CommonConstants;
import com.spirit.exception.ResponseException;
import com.spirit.exception.UserUnauthorizedException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URI;
import java.util.List;
import java.util.Set;
import java.util.regex.Pattern;

import static com.google.common.base.Preconditions.checkState;

public class AuthInterceptor extends HandlerInterceptorAdapter {

    private final Set<WhiteItem> whiteList;
    private final String mainSite;
    private final String context;
    private final String mode;

    public AuthInterceptor(final String mainSite, final String context,final String mode) throws Exception {
        this.mainSite = mainSite;
        this.mode = mode;
        this.context = context;
        whiteList = Sets.newHashSet();
        Resources.readLines(Resources.getResource("/white_list"), Charsets.UTF_8, new LineProcessor<Void>() {
            @Override
            public boolean processLine(String line) throws IOException {
                if (!nullOrComment(line)) {
                    line = Splitter.on("#").trimResults().splitToList(line).get(0);
                    List<String> parts = Splitter.on(':').trimResults().splitToList(line);
                    checkState(parts.size() == 2, "illegal white_list configuration [%s]", line);
                    Pattern urlPattern = Pattern.compile("^" + parts.get(0) + "$");
                    String methods = parts.get(1).toLowerCase();
                    ImmutableSet.Builder<String> httpMethods = ImmutableSet.builder();
                    for (String method : Splitter.on(',').omitEmptyStrings().trimResults().split(methods)) {
                        httpMethods.add(method);
                    }
                    whiteList.add(new WhiteItem(urlPattern, httpMethods.build()));
                }
                return true;
            }

            @Override
            public Void getResult() {
                return null;
            }
        });

    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String requestURI = request.getRequestURI().substring(request.getContextPath().length());
        User user = UserUtil.getUser();
        // admin
        if ((user != null)) {
            if (requestURI.startsWith("/login")) {
                response.sendRedirect(this.context + "/index");
            }
        }
        String method = request.getMethod().toLowerCase();
        for (WhiteItem whiteItem : whiteList) { // method and uri matches with white list, ok
            if (whiteItem.httpMethods.contains(method) && whiteItem.pattern.matcher(requestURI).matches()) {
                return true;
            }
        }

        if (user == null) { // write operation need login
            redirectToLogin(request, response);
            return false;
        }
        boolean isProtect = false;
        if ("dev".equals(this.mode)) {
            return true;
        }
//        for (AuthContainer.AuthItem authItem : AuthContainer.getAuth()) {
//            if (authItem.pattern.matcher(requestURI).matches()) {
//                isProtect = true;
//                return true;
//            }
//        }
        if ("/".equals(requestURI) || Strings.isNullOrEmpty(requestURI)) {
            return true;
        }

        if (!isProtect) {
            throw new UserUnauthorizedException("没有权限"+requestURI);
        }

        return false;
    }

    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (isAjaxRequest(request)) {
            throw new ResponseException(HttpStatus.UNAUTHORIZED.value(), "没有权限");
        }

        String currentUrl = request.getRequestURI();

        if (!Strings.isNullOrEmpty(request.getQueryString())) {
            currentUrl = currentUrl + "?" + request.getQueryString();
        }
        request.getSession().setAttribute(CommonConstants.PREVIOUS_URL, currentUrl);

        UriComponents uriComponents = UriComponentsBuilder
                .fromUriString("http://" + mainSite + context + "/login?target={target}").build();
        URI uri = uriComponents.expand(currentUrl).encode().toUri();
        response.sendRedirect(uri.toString());
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        return Objects.equal(request.getHeader(HttpHeaders.X_REQUESTED_WITH), "XMLHttpRequest");
    }

    private boolean nullOrComment(String line) {
        return (Strings.isNullOrEmpty(line) || line.startsWith("#"));
    }


    public static class WhiteItem {
        public final Pattern pattern;

        public final Set<String> httpMethods;

        public WhiteItem(Pattern pattern, Set<String> httpMethods) {
            this.pattern = pattern;
            this.httpMethods = httpMethods;
        }
    }

}

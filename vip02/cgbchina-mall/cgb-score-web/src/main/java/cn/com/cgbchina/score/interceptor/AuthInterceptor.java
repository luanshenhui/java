package cn.com.cgbchina.score.interceptor;

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
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import lombok.ToString;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;
import org.yaml.snakeyaml.Yaml;

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
	private final Set<AuthItem> protectList;
	private final String mainSite;

	public AuthInterceptor(final String mainSite) throws Exception {
		this.protectList = Sets.newHashSet();
		this.mainSite = mainSite;
		Yaml yaml = new Yaml();
		Auths auths = yaml.loadAs(Resources.toString(Resources.getResource("authorize.yaml"), Charsets.UTF_8),
				Auths.class);
		for (Auth auth : auths.auths) {
			Pattern urlPattern = Pattern.compile("^" + auth.url + "$");
			Set<Integer> types = Sets.newHashSet();
			if (auth.types != null && !auth.types.isEmpty()) {
				for (String type : auth.types) {
					if (Objects.equal("ALL", type.toUpperCase())) { // if all, means everyone(if login in) can access
																	// this url
						for (User.TYPE t : User.TYPE.values()) {
							types.add(t.toNumber());
						}
					} else {
						types.add(User.TYPE.fromName(type).toNumber());
					}
				}
			}

			Set<String> roles = Sets.newHashSet();
			if (auth.roles != null && !auth.roles.isEmpty()) {
				roles.addAll(auth.roles);
			}

			AuthItem authItem = new AuthItem(urlPattern, types, roles);
			protectList.add(authItem);

		}
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
		if ((user != null && user.getEnumType() == User.TYPE.ADMIN)) {
			return true;
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
		return true;
	}

	private boolean typeMatch(Set<Integer> expectedType, Integer actualType) {
		return expectedType.contains(actualType);
	}

	private boolean roleMatch(Set<String> expectedRoles, List<String> actualRoles) {
		for (String actualRole : actualRoles) {
			if (expectedRoles.contains(actualRole)) {
				return true;
			}
		}
		return false;
	}

	private void redirectToLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		if (isAjaxRequest(request)) {
			throw new ResponseException(HttpStatus.UNAUTHORIZED.value(), "用户未登录");
		}

		String currentUrl = request.getRequestURI();

		if (currentUrl.startsWith(request.getContextPath())) {
			currentUrl = currentUrl.substring(request.getContextPath().length());
		}

		if (!Strings.isNullOrEmpty(request.getQueryString())) {
			currentUrl = currentUrl + "?" + request.getQueryString();
		}
		request.getSession().setAttribute(CommonConstants.PREVIOUS_URL, currentUrl);

		UriComponents uriComponents = UriComponentsBuilder
				.fromUriString("http://" + mainSite + "/login?target={target}").build();
		URI uri = uriComponents.expand(currentUrl).encode().toUri();
		response.sendRedirect(uri.toString());
	}

	private boolean isAjaxRequest(HttpServletRequest request) {
		return Objects.equal(request.getHeader(HttpHeaders.X_REQUESTED_WITH), "XMLHttpRequest");
	}

	private boolean nullOrComment(String line) {
		return (Strings.isNullOrEmpty(line) || line.startsWith("#"));
	}

	@ToString
	private static class Auth {
		public String url;

		public List<String> types;

		public List<String> roles;
	}

	@ToString
	private static class Auths {
		public List<Auth> auths;
	}

	public static class AuthItem {
		public final Pattern pattern;

		public final Set<Integer> types;

		public final Set<String> roles;

		public AuthItem(Pattern pattern, Set<Integer> types, Set<String> roles) {
			this.pattern = pattern;
			this.types = types;
			this.roles = roles;
		}

		@Override
		public boolean equals(Object o) {
			if (this == o)
				return true;
			if (o == null || getClass() != o.getClass())
				return false;

			AuthItem authItem = (AuthItem) o;

			if (pattern != null ? !pattern.equals(authItem.pattern) : authItem.pattern != null)
				return false;

			return true;
		}

		@Override
		public int hashCode() {
			return pattern != null ? pattern.hashCode() : 0;
		}
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

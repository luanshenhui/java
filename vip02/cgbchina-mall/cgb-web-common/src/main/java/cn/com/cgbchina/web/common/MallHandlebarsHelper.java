package cn.com.cgbchina.web.common;

import static com.spirit.util.Arguments.isNull;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URL;
import java.net.URLEncoder;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.github.jknack.handlebars.Handlebars;
import com.github.jknack.handlebars.Helper;
import com.github.jknack.handlebars.Options;
import com.github.kevinsawicki.http.HttpRequest;
import com.spirit.core.handlebars.HandlebarsEngine;

@Component
public class MallHandlebarsHelper {
	@Autowired
	private HandlebarsEngine handlebarEngine;

	@PostConstruct
	private void init() {
		handlebarEngine.registerHelper("urlEncode", new Helper<Object>() {
			@Override
			public CharSequence apply(Object param, Options options) throws IOException {
				String charset = options.param(0, "utf-8");
				return URLEncoder.encode(param.toString(), charset);
			}
		});

		handlebarEngine.registerHelper("shtml", new Helper<Object>() {
			@Override
			public CharSequence apply(Object param, Options options) throws IOException {
				String src = null;
				if (param != null && param instanceof String && !((String) param).isEmpty()) {
					src = (String) param;
				}
				String body = "";
				if (src != null && !src.isEmpty() && src.startsWith("http")) {
					try {
						if (options.params.length > 0 && isSafeUrl((String) options.params[0])) {
							src += options.params[0];
						}
						HttpRequest request = HttpRequest.get(new URL(src));
						if (request.ok())
							body = request.body();
					} catch (Throwable t) {
						// Ignore possible error on purpose.
					}
				}
				return new Handlebars.SafeString(body);
			}

			private boolean isSafeUrl(String url) {
				// TODO always return true for test only.
				return true;
			}
		});

		handlebarEngine.registerHelper("divide", new Helper<Integer>() {
			@Override
			public CharSequence apply(Integer dividend, Options options) throws IOException {
				if (isNull(dividend) || isNull(options.param(0))) {
					return dividend == null ? "" : dividend.toString();
				}

				Integer divisor = options.param(0, 1);
				if (divisor == 0) {
					divisor = 1;
				}

				BigDecimal a = new BigDecimal(dividend);
				BigDecimal b = new BigDecimal(divisor);
				return a.divide(b).toString();
			}
		});
	}

}

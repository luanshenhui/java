package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.web.view.CGBCage;
import com.github.cage.Cage;
import com.github.cage.image.EffectConfig;
import com.github.cage.image.Painter;
import com.github.cage.token.RandomTokenGenerator;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;

@Component
public class CaptchaGenerator {
	public static final String CAPTCHA_TOKEN = "captchaToken";
	private final Cage cage;

	public CaptchaGenerator() {
		Painter painter = new Painter(108, 35, null, null, new EffectConfig(true, true, true, true, null), null);
		RandomTokenGenerator tokenGenerator = new RandomTokenGenerator(null, 4, 0);
		cage = new CGBCage();
	}

	public byte[] captcha(HttpSession session) {
		String token = cage.getTokenGenerator().next();
		session.setAttribute(CAPTCHA_TOKEN, token);
		return cage.draw(token);
	}

	public BufferedImage serialize(String vtext) {
		BufferedImage image = cage.drawImage(vtext);
		return image;
	}

	public String getGeneratedText(HttpSession session) {
		String token = (String) session.getAttribute(CAPTCHA_TOKEN);
		return token;
	}

	public String getGeneratedKey(HttpSession session) {
		String token = (String) session.getAttribute(CAPTCHA_TOKEN);
		session.removeAttribute(CAPTCHA_TOKEN);
		return token;
	}

	public void images(OutputStream images, String vtext) {
		try {
			cage.draw(vtext, images);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}

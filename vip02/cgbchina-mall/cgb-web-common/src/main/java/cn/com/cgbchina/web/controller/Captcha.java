package cn.com.cgbchina.web.controller;

import com.spirit.exception.ResponseException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.IOException;

/**
 * Created by yanjie.cao on 16-4-19.
 */
@Controller
@Slf4j
@RequestMapping("/api/captcha")
public class Captcha {

    @Autowired
    CaptchaGenerator captchaGenerator;

    /**
     * 生成验证码
     *
     * @param request
     * @return
     */
    @RequestMapping(method = RequestMethod.GET)
    public void captcha(HttpServletRequest request, HttpServletResponse response) {
        byte[] data = captchaGenerator.captcha(request.getSession());
        String vtext = captchaGenerator.getGeneratedText(request.getSession());
        BufferedImage images = captchaGenerator.serialize(vtext);
        ServletOutputStream outPut = null;
        try {
            outPut = response.getOutputStream();
            captchaGenerator.images(outPut, vtext);
        } catch (Exception e) {
            throw new ResponseException(e);
        } finally {
            if (outPut != null)
                try {
                    outPut.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
        }
    }

}

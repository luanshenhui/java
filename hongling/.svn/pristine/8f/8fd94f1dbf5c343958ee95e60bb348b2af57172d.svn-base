package chinsoft.service.core;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import chinsoft.core.Utility;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

public class GetCaptcha extends HttpServlet {

	private static final long serialVersionUID = 5183931736237376700L;
	
	// 验证码图片的宽度。
	private int width = 60;
	// 验证码图片的高度。
	private int height = 20;
	// 验证码字符个数
	private int codeCount = 6;
	private int x = 0;
	// 字体高度
	private int fontHeight;
	private int codeY;
	char[] codeSequence = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
			'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
			'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
	public void init() throws ServletException {
		// 从web.xml中获取初始信息
		// 宽度
		String strWidth = this.getInitParameter("width");
		// 高度
		String strHeight = this.getInitParameter("height");
		// 字符个数
		String strCodeCount = this.getInitParameter("codeCount");
		// 将配置的信息转换成数值
		try {
			if (strWidth != null && strWidth.length() != 0) {
				width = Integer.parseInt(strWidth);
			}
			if (strHeight != null && strHeight.length() != 0) {
				height = Integer.parseInt(strHeight);
			}
			if (strCodeCount != null && strCodeCount.length() != 0) {
				codeCount = Integer.parseInt(strCodeCount);
			}
		} catch (NumberFormatException e) {
		}
		x = width / (codeCount + 1);
		fontHeight = height;
		codeY = height;
	}
	
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 定义图像buffer
		BufferedImage buffImg = new BufferedImage(width, height,
				BufferedImage.TYPE_INT_RGB);
		Graphics2D g = buffImg.createGraphics();
		// 创建一个随机数生成器类
		Random random = new Random();
		// 将图像填充为白色0, 0, idCode.getWidth() , idCode.getHeight()
		g.setColor(getRandColor(200, 250));
		g.fillRect(0, 0, width, height);
		// 创建字体，字体的大小应该根据图片的高度来定。
		Font font = new Font("Arial Bold", Font.PLAIN, 18);
		// 设置字体。
		g.setFont(font);
		// 画边框。
		 g.setColor(Color.BLACK);
		 g.drawRect(0, 0, width - 1, height - 1);
		// 随机产生150条干扰线，使图象中的认证码不易被其它程序探测到。
		
//		g.setColor(getRandColor(120, 200));
//		for (int i = 0; i < 10; i++) {
//			int x = random.nextInt(width);
//			int y = random.nextInt(height);
//			int xl = random.nextInt(10);
//			int yl = random.nextInt(10);
//			g.drawLine(x, y,x+xl,y+yl);
//		}
		
		// 随机产生450个干扰点，使图象中的认证码不易被其它程序探测到。
		g.setColor(getRandColor(120,200));
		for(int i=0;i<300;i++){
		   int x=random.nextInt(width);
		   int y=random.nextInt(height);
		   g.drawOval(x,y,0,0);  
		}

		// randomCode用于保存随机产生的验证码，以便用户登录后进行验证。
		StringBuffer strNumber = new StringBuffer();
		// 随机产生codeCount数字的验证码。
		for (int i = 0; i < codeCount; i++) {
			// 得到随机产生的验证码数字。
			String strRand = String.valueOf(codeSequence[random.nextInt(codeSequence.length)]);
			// 产生随机的颜色分量来构造颜色值，这样输出的每位数字的颜色值都将不同。
			g.setColor(getRandColor(20, 130));
			// 用随机产生的颜色将验证码绘制到图像中。
			g.drawString(strRand, (i + 1) * x - 7, codeY - 5);
			// 将产生的四个随机数组合在一起。
			strNumber.append(strRand);
		}
		// 将数字的验证码保存到Session中。
		HttpSession session=request.getSession();
		session.setAttribute(Utility.SESSION_CAPTCHA, strNumber.toString().toLowerCase());
		// 禁止图像缓存。
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("image/jpeg");
		// 将图像输出到Servlet输出流中。
		OutputStream os=response.getOutputStream();
		JPEGImageEncoder encoder=JPEGCodec.createJPEGEncoder(os);
		encoder.encode(buffImg);
	
	}
	
	/** 
     * 生成随机颜色 
     * @param fc    前景色 
     * @param bc    背景色 
     * @return  Color对象，此Color对象是RGB形式的。 
     */  
    public Color getRandColor(int fc, int bc) {  
    	Random random = new Random();	
        if (fc > 255)  
            fc = 200;  
        if (bc > 255)  
            bc = 255;  
        int r = fc + random.nextInt(bc - fc);  
        int g = fc + random.nextInt(bc - fc);  
        int b = fc + random.nextInt(bc - fc);  
        return new Color(r, g, b);  
    }  

}

package web;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CheckCodeServlet extends HttpServlet {
	private int height = 30;
	private int width = 80;
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//һ����ͼ
		//step1, ����(�ڴ�ӳ�����)
		BufferedImage image = 
			new BufferedImage(width,height,
					BufferedImage.TYPE_INT_RGB);
		//step2,���� (Graphics����)
		Graphics g = image.getGraphics();
		//step3, ��������ɫ
		Random r = new Random();
		g.setColor(new Color(r.nextInt(255),
				r.nextInt(255),r.nextInt(255)));
		//step4, ����������һ��������ɫ  
		g.fillRect(0, 0, width, height);
		//step5,��ͼ
		//String number = r.nextInt(10000) + "";
		String number = getNumber(5);
		//��number�󶩵�session������
		HttpSession session = request.getSession();
		session.setAttribute("number", number);
		g.setColor(new Color(0,0,0));
		g.setFont(new Font(null,Font.BOLD,24));
		g.drawString(number, 5, 25);
		//step6,��һЩ������
		for(int i=0;i<5;i++){
			g.drawLine(r.nextInt(width), r.nextInt(height), 
					r.nextInt(width), r.nextInt(height));
		}
		//������ͼƬѹ����Ȼ��������ͻ��ˡ�
		response.setContentType("image/jpeg");
		OutputStream output = 
			response.getOutputStream();
		//write��������ԭʼͼƬ(image)����
		//ָ����ѹ���㷨(jpeg)����ѹ����Ȼ��
		//��ѹ��֮������ݻ��浽response�����ϡ�
		javax.imageio.ImageIO
		.write(image, "jpeg", output);
		
	}
	//A~Z,0~9
	private String getNumber(int size) {
		String chars = "ABCDEFGHIJKLMNOPQ" +
				"RSTUVWXYZ0123456789";
		String number = "";
		Random r = new Random();
		for(int i=0;i<size;i++){
			number += chars.charAt(
					r.nextInt(chars.length()));
		}
		return number;
	}

}

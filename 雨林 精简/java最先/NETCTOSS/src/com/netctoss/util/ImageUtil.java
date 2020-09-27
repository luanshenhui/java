package com.netctoss.util;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.imageio.ImageIO;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

public final class ImageUtil {

	private static final int SIZE=4;
	private static final int WIDTH = 100;
	private static final int HEIGHT = 30;
	private static final int FONT_SIZE = 20;
	private static final int X=15;
	private static final int Y=20;
	
	public static Map<String,BufferedImage> createImage(){
		Map<String,BufferedImage> map=new HashMap<String,BufferedImage>();
		BufferedImage image=new BufferedImage
		(WIDTH,HEIGHT,BufferedImage.TYPE_INT_RGB);
		Graphics g=image.getGraphics();
		g.setColor(Color.lightGray);
		g.fillRect(0, 0, WIDTH, HEIGHT);
		//画干扰线
		Random r=new Random();
		for (int i = 0; i < 3; i++) {
			g.setColor(getRandomColor());
			g.drawLine(r.nextInt(WIDTH), r.nextInt(HEIGHT),
					r.nextInt(WIDTH), r.nextInt(HEIGHT));
		}
		String num=getNumber(SIZE);
		g.setColor(getRandomColor());
		g.setFont(new Font(null,Font.BOLD+Font.ITALIC,FONT_SIZE));
		g.drawString(num, X, Y);
		map.put(num, image);
		return map;
	}
	  public static InputStream getInputStream(BufferedImage image) throws IOException{
	        ByteArrayOutputStream bos =
	            new ByteArrayOutputStream();
//	        JPEGImageEncoder encoder =
//	            JPEGCodec.createJPEGEncoder(bos);
//	        encoder.encode(image);
	        ImageIO.write(image, "jpg", bos);
	        byte[] imageBts = bos.toByteArray();
	        InputStream in =
	            new ByteArrayInputStream(imageBts);
	        return in;
	
	    }
	  
	private static Color getRandomColor() {
		Random r=new Random();
		Color c=new Color(r.nextInt(256),r.nextInt(256),r.nextInt(256));
	
		return c;
	}

	private static String getNumber(int size) {
		String num="";
		String str="ABCDEFGHIJLKMNOPQRSTUVWXYZ1234567890";
		Random r=new Random();
		for(int i=0;i<size;i++){
			num+=str.charAt(r.nextInt(str.length()));
	
		}
		return num;
	}
	
	public static void main(String[] args) {
		ImageUtil a=new ImageUtil();
		String s="b";
		String d="b";
		System.out.println(s==d);
		
	}
}

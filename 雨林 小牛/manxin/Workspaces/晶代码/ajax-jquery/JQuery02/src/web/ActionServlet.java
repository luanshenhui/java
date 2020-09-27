package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import bean.Stock;

public class ActionServlet extends HttpServlet {

		public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		String uri = request.getRequestURI();
		String action = uri.substring(uri.lastIndexOf("/"),
				uri.lastIndexOf("."));
		if(action.equals("/getPriceInfo")){
			String flight = request.getParameter("flight");
			if("CA1234".equals(flight)){
				out.println("ͷ�Ȳ�:��2400<br/>�����:��2200");
			}else{
				out.println("ͷ�Ȳ�:��1600<br/>�����:��1400");
			}
		}else if(action.equals("/quoto")){
			//ģ�����ɼ�ֻ��Ʊ��Ϣ
			List<Stock> stocks = 
				new ArrayList<Stock>();
			Random r = new Random();
			DecimalFormat df = 
				new DecimalFormat("#.##");
			for(int i=0;i<6;i++){
				Stock s = new Stock();
				s.setCode("60001"+r.nextInt(10));
				s.setName("ɽ������" + r.nextInt(10));
				String price = df.format(
						r.nextDouble() * 100);
				s.setPrice(Double.parseDouble(price));
				stocks.add(s);
			}
			JSONArray jsonArr = 
				JSONArray.fromObject(stocks);
			String jsonStr = jsonArr.toString();
			System.out.println(jsonArr);
			out.println(jsonStr);
		}else if(action.equals("/keyInfo")){
			String key = request.getParameter("key");
			if("С".equals(key)){
				out.println("Сʱ��,Сѧ��,С����," +
						"С־,Сѧ������");
			}else if("Сѧ".equals(key)){
				out.println("Сѧ��,Сѧ������");
			}
		}
		out.close();
	}

}

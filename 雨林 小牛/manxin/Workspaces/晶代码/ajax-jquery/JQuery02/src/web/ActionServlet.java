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
				out.println("头等舱:￥2400<br/>商务舱:￥2200");
			}else{
				out.println("头等舱:￥1600<br/>商务舱:￥1400");
			}
		}else if(action.equals("/quoto")){
			//模拟生成几只股票信息
			List<Stock> stocks = 
				new ArrayList<Stock>();
			Random r = new Random();
			DecimalFormat df = 
				new DecimalFormat("#.##");
			for(int i=0;i<6;i++){
				Stock s = new Stock();
				s.setCode("60001"+r.nextInt(10));
				s.setName("山东高速" + r.nextInt(10));
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
			if("小".equals(key)){
				out.println("小时代,小学生,小月月," +
						"小志,小学生语文");
			}else if("小学".equals(key)){
				out.println("小学生,小学生语文");
			}
		}
		out.close();
	}

}

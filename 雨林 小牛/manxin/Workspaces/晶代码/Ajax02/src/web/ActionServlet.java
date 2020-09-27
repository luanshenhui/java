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
		if(action.equals("/check_username")){
			String username = 
				request.getParameter("username");
			System.out.println("username:" 
					+ username);
			if("张三".equals(username)){
				out.println("用户名已经被占用");
			}else{
				out.println("可以使用");
			}
		}else if(action.equals("/regist")){
			//仍然要检查用户名是否存在
			String username = 
				request.getParameter("username");
			if("zs".equals(username)){
				request.setAttribute("regist_error",
						"用户名已经存在");
				request.getRequestDispatcher("regist.jsp")
				.forward(request, response);
			}else{
				System.out.println("插入用户注册的信息...");
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
		}else if(action.equals("/getNumber")){
			Random r = new Random();
			int number = r.nextInt(1000);
			System.out.println(number);
			out.println(number);
		}
		
	}

}

/**
 * 
 */
package com.f.action;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.f.domain.Sell;
import com.f.domain.Stock;
import com.f.service.StockService;
import com.f.service.StockServiceImpl;



/**
 * @author 冯学明
 *配置销售控制器
 * 2015-2-12下午2:08:29
 */
public class StockList extends BaseAction {
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//获取类别对象
		StockService service =new StockServiceImpl();
		//获取所有类别的 集合
		List<Stock> list=service.getAll();
		//存储		
		request.setAttribute("stocklist",list);

		//跳转页面
		request.getRequestDispatcher("web/page/stocklist.jsp").forward(request, response);
		
	}
}

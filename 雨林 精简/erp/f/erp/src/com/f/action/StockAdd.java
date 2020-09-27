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
import javax.servlet.http.HttpSession;

import com.f.domain.Person;
import com.f.domain.Product;
import com.f.domain.Repertory;
import com.f.domain.Stock;
import com.f.service.ProductServiceImpl;
import com.f.service.RepertoryService;
import com.f.service.RepertoryServiceImpl;
import com.f.service.StockService;
import com.f.service.StockServiceImpl;


/**
 * @author 冯学明
 * 进货控制器
 *
 * 2015-2-12下午4:47:48
 */
public class StockAdd extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//获取数据
		long pid=Long.parseLong(request.getParameter("pid"));
		int stockmount =Integer.parseInt(request.getParameter("stockmount"));
		//创建进货对象
		Stock stock=new Stock();
		//拿到当前操作人
		HttpSession session=request.getSession();
		Person person =(Person)session.getAttribute("person");
		
		stock.setPerson(person);
		//拿到商品
		Product product=new ProductServiceImpl().getByID(pid);		
		stock.setProduct(product);
		stock.setStockmount(stockmount);
	
		//添加操作
		StockService stockservice=new StockServiceImpl();
		//如果添加进货对象成功
		if(stockservice.add(stock)){
		//添加到库存 
			
			RepertoryService repertoryservice=new RepertoryServiceImpl();
				
			//需要判断 库存中是否存在
			List<Repertory> list=repertoryservice.getAll();
			boolean boo=false;
			Repertory repertory=null;
			for(Repertory re:list){
				if(product.getCode().equals(re.getProduct().getCode())){	
				 
					repertory=repertoryservice.getByID(re.getId());	
					boo=true;
				}
			}
				
			if(boo){
				//库存数量
				long storge=repertory.getStorge()+stockmount;
				repertory.setStorge(storge);
				
				
				//修改库存数量
				repertoryservice.update(repertory);
				
				
				response.sendRedirect("StockList");
				
				System.out.println(repertory);
					
			}else{
				repertory=new Repertory();
				repertory.setProduct(product);
				repertory.setStorge(stockmount);
				
				repertoryservice.add(repertory);
			
				response.sendRedirect("StockList");
			}
			
		
	}}
}

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
 * @author ��ѧ��
 * ����������
 *
 * 2015-2-12����4:47:48
 */
public class StockAdd extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//��ȡ����
		long pid=Long.parseLong(request.getParameter("pid"));
		int stockmount =Integer.parseInt(request.getParameter("stockmount"));
		//������������
		Stock stock=new Stock();
		//�õ���ǰ������
		HttpSession session=request.getSession();
		Person person =(Person)session.getAttribute("person");
		
		stock.setPerson(person);
		//�õ���Ʒ
		Product product=new ProductServiceImpl().getByID(pid);		
		stock.setProduct(product);
		stock.setStockmount(stockmount);
	
		//��Ӳ���
		StockService stockservice=new StockServiceImpl();
		//�����ӽ�������ɹ�
		if(stockservice.add(stock)){
		//��ӵ���� 
			
			RepertoryService repertoryservice=new RepertoryServiceImpl();
				
			//��Ҫ�ж� ������Ƿ����
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
				//�������
				long storge=repertory.getStorge()+stockmount;
				repertory.setStorge(storge);
				
				
				//�޸Ŀ������
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

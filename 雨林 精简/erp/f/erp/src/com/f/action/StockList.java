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
 * @author ��ѧ��
 *�������ۿ�����
 * 2015-2-12����2:08:29
 */
public class StockList extends BaseAction {
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//��ȡ������
		StockService service =new StockServiceImpl();
		//��ȡ�������� ����
		List<Stock> list=service.getAll();
		//�洢		
		request.setAttribute("stocklist",list);

		//��תҳ��
		request.getRequestDispatcher("web/page/stocklist.jsp").forward(request, response);
		
	}
}

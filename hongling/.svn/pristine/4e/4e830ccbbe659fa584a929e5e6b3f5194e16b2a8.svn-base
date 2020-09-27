package hongling.service.orden;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CustomerManager;
import chinsoft.business.DictManager;
import chinsoft.business.MemberManager;
import chinsoft.business.OrdenManager;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;

public class GetClothingBodyInfo extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String orderNo=request.getParameter("ordenNo");
		Orden orden=new OrdenManager().getordenByOrderId(orderNo);
		Member member=new MemberManager().getMemberByID(orden.getPubMemberID());
		String pumname="";
		if(member!=null){
			pumname=member.getName();
		}
		Map map=new HashMap();
		map.put("量体类型", new DictManager().getDictByID(orden.getSizeCategoryID()).getName());
		map.put("客户",new CustomerManager().getCustomerByID(orden.getCustomerID()).getName());
		map.put("量体人",pumname);
		map.put("量体时间", orden.getPubDate());
		request.setCharacterEncoding("UTF-8");
		System.out.println(map);
		request.setAttribute("clothmap",map);
	}

}

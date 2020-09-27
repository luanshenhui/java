package chinsoft.service.orden;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import chinsoft.business.AlipayNotify;
import chinsoft.business.CDict;
import chinsoft.business.OrdenManager;
import chinsoft.business.SubmitToOrden;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Customer;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class AlipayNotifyUrl extends BaseServlet {

	private static final long serialVersionUID = -3752715900648015793L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
//			super.service();
			//获取系统订单信息
			String strOrdenId = HttpContext.getSessionValue("SESSION_ORDENID").toString();
			String strPrice = HttpContext.getSessionValue("SESSION_ORDENFEE").toString();
			
			//获取支付宝POST过来反馈信息
			Map<String,String> params = new HashMap<String,String>();
			Map requestParams = request.getParameterMap();
			for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
				String name = (String) iter.next();
				String[] values = (String[]) requestParams.get(name);
				String valueStr = "";
				for (int i = 0; i < values.length; i++) {
					valueStr = (i == values.length - 1) ? valueStr + values[i]
							: valueStr + values[i] + ",";
				}
				//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
			    valueStr = new String(valueStr.getBytes("ISO-8859-1"), "UTF-8");
				params.put(name, valueStr);
			}
			
			//商户订单号
			String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");
			//交易状态
			String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"),"UTF-8");
			//交易金额
			String total_fee = new String(request.getParameter("total_fee").getBytes("ISO-8859-1"),"UTF-8");
			
			response.setCharacterEncoding("UTF-8");//设置编码
			response.setContentType("text/html");//服务器响应类型
			PrintWriter out = response.getWriter();
			String strResult = "";
			if(new AlipayNotify().verify(params)){//验证成功

				//支付宝返回信息与订单信息相等，支付状态为成功，返回true
				if(strOrdenId.equals(out_trade_no) && strPrice.equals(total_fee) && 
						(trade_status.equals("WAIT_SELLER_SEND_GOODS"))){
					//该判断表示买家已在支付宝交易管理中产生了交易记录且付款成功，但卖家没有发货
					//检查订单
					String[] strOrdenid = strOrdenId.split("&");
					List<Orden> ordens = new ArrayList<Orden>();
					for(int i=0; i<strOrdenid.length; i++){
						Orden orden = this.getOrdenByID(strOrdenid[i]);
						ordens.add(orden);
					}
					String str = new OrdenManager().checkEmbroidery(ordens);
					str = this.checkProcessBiao(ordens);
					str = new OrdenManager().checkLapelWidth(ordens);
					if("".equals(str)){
						for (Orden orden : ordens) {//提交订单
							orden.setStatusID(CDict.OrdenStatusPlateMaking.getID());
							orden.setIsAlipay(CDict.YES.getID());
							strResult += new SubmitToOrden().submitToERP(orden);
						}
					}else{
						strResult = str ;
					}
				}
				String strDom = "";
				if(!"".equals(strResult)){
					strDom ="alert('"+ strResult +"');";
				}
				System.out.println("AlipayNotifyUrl:trade_status"+trade_status);
				System.out.println("AlipayNotifyUrl:success");
//				out.print("<script>alert('支付成功！');"+ strDom + "document.location.href='/hongling/pages/common/orden.jsp';</script>");
				out.println("success");	//请不要修改或删除
				out.close();
				return;
			}else{//验证失败			
				System.out.println("AlipayNotifyUrl:fail");
//				out.print("<script>alert('支付失败，已保存订单！');document.location.href='/hongling/pages/common/orden.jsp';</script>");
				out.println("fail");  //请不要修改或删除
				out.close();
				return;
			}
//			response.sendRedirect("/hongling/pages/common/orden.htm");
		} catch (Exception err) {
			System.out.println("AlipayNotifyUrl:error");
			LogPrinter.debug(err.getMessage());
			System.out.println(err.getMessage());
		}
	}
}
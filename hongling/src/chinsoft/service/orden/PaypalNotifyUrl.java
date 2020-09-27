package chinsoft.service.orden;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Enumeration;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.AlipayConfig;
import chinsoft.business.CDict;
import chinsoft.business.SubmitToOrden;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class PaypalNotifyUrl extends BaseServlet {

	private static final long serialVersionUID = -3752715900648015793L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			//获取系统订单信息
			String strOrdenId = HttpContext.getSessionValue("SESSION_ORDENID").toString();
			String strPrice = HttpContext.getSessionValue("SESSION_ORDENFEE").toString();
			AlipayConfig pay = new AlipayConfig();
			
			//获取Paypal POST过来反馈信息
			Enumeration en = request.getParameterNames();
			StringBuffer strBuffer = new StringBuffer("cmd=_notify-validate");
			String paramName;
			String paramValue;
			while (en.hasMoreElements()) {
				paramName = (String) en.nextElement();
				paramValue = request.getParameter(paramName);
				strBuffer.append("&").append(paramName).append("=")
						.append(URLEncoder.encode(paramValue));
			}

			// post back to PayPal system to validate  回传给paypal
			//URL u = new URL("https://www.sandbox.paypal.com/cgi-bin/webscr");//测试路径
			URL u = new URL("https://www.paypal.com/cgi-bin/webscr");
			HttpsURLConnection uc = (HttpsURLConnection) u.openConnection();
			uc.setDoOutput(true);
			uc.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
			uc.setRequestProperty("Host", "www.paypal.com");
			PrintWriter pw = new PrintWriter(uc.getOutputStream());
			pw.println(strBuffer.toString());
			pw.close();

			BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream()));
			String res = in.readLine();
			in.close();

			// assign posted variables to local variables
			String itemNumber = request.getParameter("item_number");//订单号
			String paymentStatus = request.getParameter("payment_status");//订单状态
			String paymentCurrency = request.getParameter("mc_currency");//货币类型
			String paymentAmount = request.getParameter("mc_gross");//支付金额
			String receiverEmail = request.getParameter("receiver_email");//账户Email==账号

			
			response.setCharacterEncoding("UTF-8");//设置编码
			response.setContentType("text/html");//服务器响应类型
			PrintWriter out = response.getWriter();
			String strResult = "";
			// check notification validation
			if (res.equals("VERIFIED")) {//成功
				if("Completed".equals(paymentStatus)){//状态=完成
					if(pay.business.equals(receiverEmail)){//账号=红领账号
						if(pay.currency_code.equals(paymentCurrency) && strPrice.equals(paymentAmount)){//货币类型=USD && 金额=需支付金额
							if(strOrdenId.equals(itemNumber)){//订单号是否一致
								//提交订单
								String[] strOrdenid = strOrdenId.split("&");
								for(int i=0; i<strOrdenid.length; i++){
									Orden orden = this.getOrdenByID(strOrdenid[i]);
									orden.setStatusID(CDict.OrdenStatusPlateMaking.getID());
									orden.setIsAlipay(CDict.YES.getID());
									strResult += new SubmitToOrden().submitToERP(orden);
								}
							}
						}
					}
					String strDom ="alert('"+ strResult +"');";
					out.print("<script>alert('支付成功！');"+ strDom + "document.location.href='/hongling/pages/common/orden.htm';</script>");
					//如果确认收到paypal发来的客户付款信息，则返回"200 OK"
					out.print("200 OK");
					out.close();
					return;
				}
			} else if (res.equals("INVALID")) {//失败
				// log for investigation
				out.print("<script>alert('支付失败，已保存订单！');document.location.href='/hongling/pages/common/orden.htm';</script>");
				out.print("fail");
				out.close();
				return;
			} else {//错误
				// error
				out.print("<script>alert('支付失败，已保存订单！');document.location.href='/hongling/pages/common/orden.htm';</script>");
				out.print("fail");
				out.close();
				return;
			}
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
			System.out.println(err.getMessage());
		}
	}
}
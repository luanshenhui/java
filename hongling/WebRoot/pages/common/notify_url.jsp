<%@page import="javax.sound.midi.SysexMessage"%>
<%@page import="chinsoft.wsdl.IServiceToBxppServiceLocator"%>
<%@page import="chinsoft.entity.Errors"%>
<%@page import="chinsoft.business.XmlManager"%>
<%@page import="chinsoft.entity.ErrorMessage"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="chinsoft.core.DataAccessObject"%>

<%
/* *
 功能：支付宝服务器异步通知页面
 版本：3.3
 日期：2012-08-17
 说明：
 以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
 该代码仅供学习和研究支付宝接口使用，只是提供一个参考。

 //***********页面功能说明***********
 创建该页面文件时，请留心该页面文件中无任何HTML代码及空格。
 该页面不能在本机电脑测试，请到服务器上做测试。请确保外部可以访问该页面。
 该页面调试工具请使用写文本函数logResult，该函数在com.alipay.util文件夹的AlipayNotify.java类文件中
 如果没有收到该页面返回的 success 信息，支付宝会在24小时内按一定的时间策略重发通知
 //********************************
 * */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="chinsoft.business.AlipayNotify"%>
<%@ page import="chinsoft.business.CDict"%>
<%@ page import="chinsoft.entity.Orden"%>
<%@ page import="chinsoft.business.OrdenManager"%>
<%@ page import="chinsoft.service.core.BaseServlet"%>
<%@ page import="chinsoft.business.SubmitToOrden"%>
<%
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
		//valueStr = new String(valueStr.getBytes("ISO-8859-1"), "gbk");
		params.put(name, valueStr);
	}
	
	//获取支付宝的通知返回参数
	//商户订单号
	String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");
	//支付宝交易号
	String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"UTF-8");
	//交易状态
	String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"),"UTF-8");
	
	System.out.println("out_trade_no:"+out_trade_no+";trade_no:"+trade_no+";trade_status:"+trade_status);
	
	if(new AlipayNotify().verify(params)){//验证成功
		 if(trade_status.equals("WAIT_SELLER_SEND_GOODS")){ 
			//该判断表示买家已在支付宝交易管理中产生了交易记录且付款成功，但卖家没有发货
			
				//判断该笔订单是否在商户网站中已经做过处理
					//如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
					//如果有做过处理，不执行商户的业务程序
					//String out_trade_no="XXXX13052304";
					String[] strOrdenid = out_trade_no.split("&");
					List<Orden> ordens = new ArrayList<Orden>();
					for(int i=0; i<strOrdenid.length; i++){
						Orden orden = new OrdenManager().getOrdenByID(strOrdenid[i].toString());
						if(!CDict.YES.getID().equals(orden.getIsAlipay())){
							orden.setStatusID(CDict.OrdenStatusPlateMaking.getID()); //制版
							orden.setIsAlipay(CDict.YES.getID());
							String strCode = "";
							String strContent = "";
							try {
								String strXml =new IServiceToBxppServiceLocator().getIServiceToBxppPort().doPaymentOrder(orden.getSysCode(),null);
								Errors errors=(Errors) XmlManager.doStrXmlToObject(strXml, Errors.class);
								for(ErrorMessage error : errors.getList()){
									strCode = error.getCode();
									strContent = error.getContent();
									if("1".equals(strCode)){//成功，返回code=1，Content=交期
										try {
											SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
											Date date = sf.parse(strContent);
											orden.setJhrq(date);
											DataAccessObject dao = new DataAccessObject();
											dao.saveOrUpdate(orden);
										} catch (Exception e) {
											e.printStackTrace();
										}
									}else{
										System.out.println("订单："+strOrdenid[i]+"解锁失败，Code:"+strCode+",Content:"+strContent);
									}
										
								}
				
							} catch (Exception e) {
								e.printStackTrace();
							}	
						}
					}
					
				out.println("success");	//请不要修改或删除
			}
		}else{//验证失败
			out.println("fail");
	} 
%> 
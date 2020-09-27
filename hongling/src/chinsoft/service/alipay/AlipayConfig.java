package chinsoft.service.alipay;

public class AlipayConfig {
	//支付宝必要参数***
//	public String service = "create_direct_pay_by_user";//接口名称,必填
//	public String partner = "2088301365987350";//合作身份者ID，以2088开头由16位纯数字组成的字符串,必填*
//	public String input_charset = "UTF-8";// 字符编码格式 utf-8,必填
//	public String sign_type = "MD5";// 签名方式 ,必填
//	public String payment_type = "1";//支付类型,1为商品购买,必填
//	public String name ="红领服饰";//订单名称
//	
//	public String key = "avhpnwlbvj20f6t620tqggid1vycaf3j";//交易安全检验码，由数字和字母组成的32位字符串*
//	public String seller_email = "rprince@yahoo.cn";//卖家收款支付宝帐户*
//	public String notify_url = "http://www.rcmtm.cn/hongling/service/orden/alipaynotifyurl";//支付宝服务器通知的页面
//	public String ALIPAY_GATEWAY_NEW = "https://mapi.alipay.com/gateway.do?";//支付宝提供给商户的服务接入网关URL
	
	public String payment_type = "1";
	public String ALIPAY_GATEWAY_NEW = "https://mapi.alipay.com/gateway.do?";//支付宝提供给商户的服务接入网关URL
	public String service = "create_partner_trade_by_buyer";//接口名称,必填
	public String partner = "2088301365987350";// 合作身份者ID，以2088开头由16位纯数字组成的字符串
	public String key = "avhpnwlbvj20f6t620tqggid1vycaf3j";// 商户的私钥
	public String input_charset = "utf-8";// 字符编码格式 目前支持 gbk 或 utf-8
	public String sign_type = "MD5";// 签名方式 不需修改
	public String seller_email = "rprince@yahoo.cn";//卖家收款支付宝帐户
	public String quantity = "1";//必填，建议默认为1，不改变值，把一次交易看成是一次下订单而非购买一件商品
	public String logistics_fee = "0.00";//必填，即运费
	public String logistics_type = "EXPRESS";//必填，三个值可选：EXPRESS（快递）、POST（平邮）、EMS（EMS）
	public String logistics_payment = "SELLER_PAY";//必填，两个值可选：SELLER_PAY（卖家承担运费）、BUYER_PAY（买家承担运费）
//	public String notify_url = "http://www.rcmtm.cn/hongling/service/orden/alipaynotifyurl.java";//支付宝异步服务器通知的页面
//	public String return_url = "http://www.rcmtm.cn/hongling/service/orden/alipayreturnurl.java";//支付宝同步服务器通知的页面
//	public String return_url = "http://219.147.16.133/hongling/pages/common/orden.jsp";
//	public String notify_url = "http://219.147.16.133/hongling/pages/common/notify_url.jsp";
	public String return_url = "http://www.rcmtm.cn/hongling/pages/common/orden.jsp";
	public String notify_url = "http://www.rcmtm.cn/hongling/pages/common/notify_url.jsp";
	public String name ="红领服饰";//订单名称
	public String log_path ="D:\\ApalyLog\\";
	
	
	
	//Paypal必要参数***
	public String cmd = "_xclick";//支付类型
	public String business = "paypal@yoursite.com";//paypal账号*
	public String currency_code = "USD";//货币类型
	public String cancel_return = "http://172.16.6.37:8080/hongling/pages/common/orden.jsp";//取消支付返回页面
//	public String cancel_return = "rcmtm.com/hongling/pages/common/orden.htm";//取消支付返回页面
	public String paypal_notify_url = "http://172.16.6.37:8080/hongling/service/orden/paypalnotifyurl";//paypal服务器通知的页面
//	public String paypal_notify_url = "rcmtm.com/hongling/service/orden/paypalnotifyurl";//paypal服务器通知的页面
	public String PAYPAL_URL = "https://www.paypal.com/cgi-bin/webscr";//paypal接口
//	public String PAYPAL_URL = "https://www.sandbox.paypal.com/cgi-bin/webscr";//测试paypal接口
	public String item_name = "Redcollar dress";//订单名称
}

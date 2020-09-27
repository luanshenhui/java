package rcmtm.business;

public class ConfigSR{
	
	//善融路径  测试121.32.89.133:85    正式mall.ccb.com
	public static final String URL_BIND = "http://mall.ccb.com/alliance/alliance_bind.php";//账号绑定
	public static final String URL_ORDER = "http://mall.ccb.com/alliance/order.php";//订单支付
	public static final String URL_TRADESET = "http://mall.ccb.com/alliance/alliance_tradeset.php";//订单明细发送
	public static final String URL_DELETENO = "http://mall.ccb.com/alliance/alliance_annultrade.php";//订单撤销
	public static final String URL_SENDORDER = "http://mall.ccb.com/alliance/consignment.php";//订单发货
	public static final String URL_RECEIVEORDER = "http://mall.ccb.com/alliance/alliance_RCTradeStatus.php";//订单收到
	
//	public static final String URL_BIND = "http://121.32.89.133:85/alliance/alliance_bind.php";//账号绑定
//	public static final String URL_ORDER = "http://121.32.89.133:85/alliance/order.php";//订单支付
//	public static final String URL_TRADESET = "http://121.32.89.133:85/alliance/alliance_tradeset.php";//订单明细发送
//	public static final String URL_DELETENO = "http://121.32.89.133:85/alliance/alliance_annultrade.php";//订单撤销
//	public static final String URL_SENDORDER = "http://121.32.89.133:85/alliance/consignment.php";//订单发货
//	public static final String URL_RECEIVEORDER = "http://121.32.89.133:85/alliance/alliance_RCTradeStatus.php";//订单收到
//	public static final String URL_ORDERACCOUNT = "http://121.32.89.133:85/member/alliance_tradeVerif.php";//对账单
	//私钥
	public static final String PRIVATE_KEY = "redcollar_priv";
	//红领编码
//	public static final String CPCODE = "1002";
	//key
//	public static final String KEY = "redcollar";//公司名称 CAMEO
}
package cn.com.cgbchina.rest.common.util;

import com.google.common.collect.Maps;

import java.util.Map;

public class MallReturnCode {
	public static  String RETURN_SUCCESS_CODE="000000";
	public static  String RETURN_SYSERROR_CODE="000009";
	public static  String RETURN_SYSERROR_MSG="系统异常";

	public static String NotFound_Des="找不到订单";
	public static String NotFound_Code="000013";
	public static String CHANNELCN_CCAG="CCAG";

	public static String NotFound_Goods_Des = "找不到礼品";
	public static String NotFound_Goods_Code = "000010";

	public static String Not_Cell_Up_Des = "此商品不是手机上架状态";
	public static String Not_Cell_Up_Code = "000036";

	public static String No_Cell_PiontType_Des = "该客户积分类型不满足购买此礼品条件";
	public static String No_Cell_PiontType_Code = "000072";

	public static String No_Rigth_CardFormat_Des = "该客户卡板不满足购买此礼品条件" ;
	public static String No_Rigth_CardFormat_Code = "000071" ;

	public static String REQUEST_PARAMETERERROR_CODE = "000008";
	public static String REQUEST_PARAMETERERROR_DES = "报文参数错误";

	public static String NotFound_Gift_Msg = "找不到商品";
	public static String NotFound_Gift_Code = "000031";

	public static String NotMatch_Format_Msg = "该卡卡板不满足购买此礼品条件";
	public static String NotMatch_Format_Code = "000062";

	public static String Bought_Goods_Msg = "在限定时间内该卡号已购买过该产品";
	public static String Bought_Goods_Code = "000059";

	public static Map<String, String> codes;

	public static void initCodes(){
		codes = Maps.newHashMap();
		codes.put("000000", "正常");
		codes.put("000001", "未知交易指令");
		codes.put("000002", "非法请求");
		codes.put("000003", "报文编码失败");
		codes.put("000004", "报文头解析失败");
		codes.put("000005", "报文体解析失败");
		codes.put("000006", "交易超时");
		codes.put("000007", "交易网关异常");
		codes.put("000008", "报文参数错误");
		codes.put("000009", "系统异常");
		codes.put("000010", "找不到礼品");
		codes.put("000011", "支付失败");
		codes.put("000012", "支付状态未明");
		codes.put("000013", "找不到订单");
		codes.put("000014", "订单无法修改");
		codes.put("000015", "该商品不允许兑换");
		codes.put("000016", "传入支付方式不存在");
		codes.put("000017", "订单商品数量总数不能超过99个");
		codes.put("000018", "金额转换异常");
		codes.put("000019", "积分转换异常");
		codes.put("000020", "订单金额不匹配");
		codes.put("000021", "订单积分不匹配");
		codes.put("000022", "商品数量达到警戒值，无法下单");
		codes.put("000023", "地址格式不正确");
		codes.put("000024", "CC渠道不允许支付");
		codes.put("000025", "IVR渠道不允许支付");
		codes.put("000026", "超过180天不能撤单、退货、删除订单、催货");
		codes.put("000027", "数据库操作异常");
		codes.put("000028", "验签失败");
		codes.put("000029", "订单类型错误");
		codes.put("000030", "订单信息串有误");
		codes.put("000031", "找不到商品");
		codes.put("000032", "商品与支付方式不匹配");
		codes.put("000033", "现在日期不在商品有效期之内");
		codes.put("000034", "找不到相应的供应商");
		codes.put("000035", "商品数量低于警戒值");
		codes.put("000036", "商品不是上架状态");
		codes.put("000037", "活动已过期");
		codes.put("000038", "参加活动人数已满");
		codes.put("000039", "加签失败");
		codes.put("000040", "订单类型与支付方式不匹配");
		codes.put("000041", "总价格不相等");
		codes.put("000042", "验签异常");
		codes.put("000043", "该商品已经存在于收藏夹");
		codes.put("000044", "用户添加地址超过了6条");
		codes.put("000045", "该商品已经存在于购物车中");
		codes.put("000046", "发票抬头不能为空");
		codes.put("000047", "商品数目不能大于99");
		codes.put("000048", "商品总数不相等");
		codes.put("000049", "手机商城渠道不允许支付");
		codes.put("000050", "调用个人网银接口查询客户号失败");
		codes.put("000051", "该订单已发货不能修改投递方式");
		codes.put("000052", "订单当前状态不能撤单");
		codes.put("000053", "现有订单状态不能退货");
		codes.put("000054", "处理中订单不能生成报表");
		codes.put("000055", "支付成功订单需要生成报表");
		codes.put("000056", "已经存在重复的受理号");
		codes.put("000057", "虚拟礼品暂时只能购买一种");
		codes.put("000058", "虚拟礼品一次购买不能超过100000个");
		codes.put("000059", "在限定时间内该卡号已经购买过该产品");
		codes.put("000060", "限购产品一次只能购买一件");
		codes.put("000061", "虚拟礼品不能采用指定多卡支付");
		codes.put("000062", "该卡卡板不满足购买此礼品条件");
		codes.put("000063", "虚拟礼品不支持退货");
		codes.put("000064", "年费、签帐额只支持当天18:00之前撤单");
		codes.put("000065", "虚拟礼品只能在出报表之前才能撤单");
		codes.put("000066", "此礼品不是附属卡礼品");
		codes.put("000067", "不符合附属卡的规则");
		codes.put("000068", "支付网关拒绝撤单");
		codes.put("000069", "找不到对应积分区间");
		codes.put("000070", "存在礼品不在上架状态");
		codes.put("000071", "保单号校验失败");
		codes.put("000100", "暂不支持此功能");
		codes.put("000101", "卡片无法兑换此礼品");
		codes.put("000102", "生日当月已兑换过生日礼品，本次兑换不成功");
		codes.put("000103", "兑换生日礼品数量超过最大限制数量，本次兑换不成功");
		codes.put("000104", "活动不存在");
		codes.put("000105", "已添加提醒");
		codes.put("000106", "无提醒记录");
		codes.put("100000", "其他异常");
	}

	public static String getReturnDes(String key){
		if(codes == null){
			initCodes();
		}
		return codes.get(key)==null?"": codes.get(key);
	}
}

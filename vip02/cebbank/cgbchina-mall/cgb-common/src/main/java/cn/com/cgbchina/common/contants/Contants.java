package cn.com.cgbchina.common.contants;

/**
 * Created by zhangshiqiang on 2016/4/22.
 */
public class Contants {

	// ######################################################add by zhangshiqiang#######商品审核状态
	// modify tanliang
	/**
	 * 商品审核状态 00编辑中
	 ***/
	public static final String GOODS_APPROVE_STATUS_00 = "00";
	public static final String GOODS_EDITING = "编辑中";
	/**
	 * 商品审核状态 01待初审
	 ***/
	public static final String GOODS_APPROVE_STATUS_01 = "01";
	public static final String GOODS_PENDING_TRIAL = "待初审";

	/**
	 * 商品审核状态 02待复审
	 ***/
	public static final String GOODS_APPROVE_STATUS_02 = "02";
	public static final String GOODS_PENDING_REVIEW = "待复审";
	/**
	 * 商品审核状态 03商品变更审核
	 **/
	public static final String GOODS_APPROVE_STATUS_03 = "03";
	public static final String GOODS_CHANGE_AUDIT = "商品变更审核";
	/**
	 * 商品审核状态 04价格变更审核
	 **/
	public static final String GOODS_APPROVE_STATUS_04 = "04";
	public static final String PRICE_CHANGE_AUDIT = "价格变更审核";
	/**
	 * 商品审核状态 05下架申请审核
	 **/
	public static final String GOODS_APPROVE_STATUS_05 = "05";
	public static final String NEXT_APPLICATION_AUDIT = "下架申请审核";
	/**
	 * 商品审核状态 06审核通过
	 **/
	public static final String GOODS_APPROVE_STATUS_06 = "06";
	public static final String GOODS_REVIEWED_PASS = "审核通过";
	/**
	 * 商品审核状态 07待定价
	 **/
	public static final String GOODS_APPROVE_STATUS_07 = "07";
	public static final String GOODS_PENDING_PRICED = "待定价";

	/**
	 * 商品审核状态 08定价审核
	 **/
	public static final String GOODS_APPROVE_STATUS_08 = "08";
	public static final String GOODS_PRICED_AUDIT = "定价审核";
	/**
	 * 商品审核状态 70初审拒绝
	 **/
	public static final String GOODS_APPROVE_STATUS_70 = "70";
	public static final String GOODS_PRELIMINARY_REJECTION = "初审拒绝";
	/**
	 * 商品审核状态 71复审拒绝
	 **/
	public static final String GOODS_APPROVE_STATUS_71 = "71";
	public static final String GOODS_REVIEW_REJECT = "复审拒绝";
	/**
	 * 商品审核状态 72商品变更审核拒绝
	 **/
	public static final String GOODS_APPROVE_STATUS_72 = "72";
	public static final String CHANGE_AUDIT_REJECT = "商品变更审核拒绝";
	/**
	 * 商品审核状态 73价格变更审核拒绝
	 **/
	public static final String GOODS_APPROVE_STATUS_73 = "73";
	public static final String PRICE_CHANGE_REVIEW = "价格变更审核拒绝";
	/**
	 * 商品审核状态 74下架申请审核拒绝
	 **/
	public static final String GOODS_APPROVE_STATUS_74 = "74";
	public static final String NEXT_FRAME_TO_REVIEW = "下架申请审核拒绝";
	/**
	 * 商品审核状态 75下架定价审核拒绝
	 **/
	public static final String GOODS_APPROVE_STATUS_75 = "75";
	public static final String NEXT_PRICED_PRICED_REVIEW = "定价审核拒绝";

	// ######################################################add by zhangshiqiang#######品牌审核状态 待审核00 审核通过01 审核拒绝02
	/**
	 * 品牌管理审核状态 -- 待审核
	 **/
	public static final String BRAND_APPROVE_STATUS_00 = "00";
	/**
	 * 品牌管理审核状态 -- 审核通过
	 **/
	public static final String BRAND_APPROVE_STATUS_01 = "01";
	/**
	 * 品牌管理审核状态 -- 审核拒绝
	 **/
	public static final String BRAND_APPROVE_STATUS_02 = "02";

	// ######################################################add by yuminglei#######订单发货标记 未发货0 已发货1 已签收2
	public static final String GOODS_SEND_FLAG_0 = "0";
	public static final String GOODS_SEND_FLAG_1 = "1";
	public static final String GOODS_SEND_FLAG_2 = "2";

	// ######################################################add by yuminglei#######请款标记 未请款0 已请款1
	public static final String GOODS_ASKFOR_FLAG_0 = "0";
	public static final String GOODS_ASKFOR_FLAG_1 = "1";
	// ######################################################add by zhangshiqiang#######逻辑删除标识
	/**
	 * 0未删除
	 **/
	public static final String DEL_FLAG_0 = "0";
	public static final Integer DEL_INTEGER_FLAG_0 = 0;
	/**
	 * 1删除
	 **/
	public static final String DEL_FLAG_1 = "1";
	public static final Integer DEL_INTEGER_FLAG_1 = 1;

	// #######################################################add by zhangshiqiang#######错误code
	public static final int ERROR_CODE_500 = 500;
	public static final int ERROR_CODE_400 = 400;
	public static final int ERROR_CODE_404 = 404;
	public static final int ERROR_CODE_405 = 405;

	// ######################################################add by zhangshiqiang#######子订单状态
	/**
	 * 0301--待付款
	 **/
	public static final String SUB_ORDER_STATUS_0301 = "0301";
	public static final String SUB_ORDER_WITHOUT_PAYMENT = "待付款";
	/**
	 * 0316--订单状态未明
	 **/
	public static final String SUB_ORDER_STATUS_0316 = "0316";
	public static final String SUB_ORDER_UNCLEAR = "订单状态未明";
	/**
	 * 0308--支付成功
	 **/
	public static final String SUB_ORDER_STATUS_0308 = "0308";
	public static final String SUB_ORDER_PAYMENT_SUCCEED = "支付成功";
	/**
	 * 0307--支付失败
	 **/
	public static final String SUB_ORDER_STATUS_0307 = "0307";
	public static final String SUB_ORDER_PAYMENT_FAILED = "支付失败";
	/**
	 * 0305--处理中
	 **/
	public static final String SUB_ORDER_STATUS_0305 = "0305";
	public static final String SUB_ORDER_HANDLING = "处理中";
	/**
	 * 0309--已发货
	 **/
	public static final String SUB_ORDER_STATUS_0309 = "0309";
	public static final String SUB_ORDER_DELIVERED = "已发货";
	/**
	 * 0306--发货处理中
	 **/
	public static final String SUB_ORDER_STATUS_0306 = "0306";
	public static final String SUB_ORDER_DELIVER_HANDLING = "发货处理中";
	/**
	 * 0310--已签收
	 **/
	public static final String SUB_ORDER_STATUS_0310 = "0310";
	public static final String SUB_ORDER_SIGNED = "已签收";
	/**
	 * 0312--已撤单
	 **/
	public static final String SUB_ORDER_STATUS_0312 = "0312";
	public static final String SUB_ORDER_REVOKED = "已撤单";
	/**
	 * 0304--已废单
	 **/
	public static final String SUB_ORDER_STATUS_0304 = "0304";
	public static final String SUB_ORDER_SCRAPED = "已废单";
	/**
	 * 0334--退货申请
	 **/
	public static final String SUB_ORDER_STATUS_0334 = "0334";
	public static final String SUB_ORDER_RETURN_APPLICATION = "退货申请";
	/**
	 * 0327--退货成功
	 **/
	public static final String SUB_ORDER_STATUS_0327 = "0327";
	public static final String SUB_ORDER_RETURN_SUCCEED = "退货成功";
	/**
	 * 0335--拒绝退货申请
	 **/
	public static final String SUB_ORDER_STATUS_0335 = "0335";
	public static final String SUB_ORDER__RETURN_APPLICATION_REFUSED = "拒绝退货申请";
	/**
	 * 0380--拒绝签收
	 **/
	public static final String SUB_ORDER_STATUS_0380 = "0380";
	public static final String SUB_ORDER_SIGNED_REFUSED = "拒绝签收";
	/**
	 * 0381--无人签收
	 **/
	public static final String SUB_ORDER_STATUS_0381 = "0381";
	public static final String SUB_ORDER_SIGNED_NONE = "无人签收";
	/**
	 * 0382--订单推送失败
	 **/
	public static final String SUB_ORDER_STATUS_0382 = "0382";
	public static final String SUB_ORDER_PUSH_FAILED = "订单推送失败";

	// 以下三种状态码未明确，为使业务进行顺利暂定 需根据业务重新确定

	/**
	 * (可用)已取消
	 **/
	public static final String SUB_ORDER_STATUS_7777 = "0360";
	public static final String SUB_ORDER_CANCELED = "已取消";

	/**
	 * (待定)已发码
	 **/
	// TODO: 2016/4/26
	@Deprecated
	public static final String SUB_ORDER_STATUS_8888 = "8888";
	public static final String SUB_ORDER_CODE_SENT = "已发码";
	/**
	 * (待定)已过期
	 **/
	// TODO: 2016/4/26
	@Deprecated
	public static final String SUB_ORDER_STATUS_9999 = "9999";
	public static final String SUB_ORDER_CODE_EXPIRED = "已过期";

	// ######################################################add by zhangshiqiang#######子订单请款状态
	/**
	 * 0332--请款申请
	 **/
	public static final String SUB_SIN_STATUS_0332 = "0332";
	/**
	 * 0350--同意请款
	 **/
	public static final String SUB_SIN_STATUS_0350 = "0350";
	/**
	 * 0351--请款中
	 **/
	public static final String SUB_SIN_STATUS_0351 = "0351";
	/**
	 * 0311--请款成功
	 **/
	public static final String SUB_SIN_STATUS_0311 = "0311";
	/**
	 * 0333--拒绝请款
	 **/
	public static final String SUB_SIN_STATUS_0333 = "0333";
	/**
	 * 0352--请款失败
	 **/
	public static final String SUB_SIN_STATUS_0352 = "0352";
	/**
	 * 0300--未请款
	 **/
	public static final String SUB_SIN_STATUS_0300 = "0000";

	public static final String SUB_SIN_STATUS_Nm_0333 = "拒绝请款";

	public static final String SUB_SIN_STATUS_Nm_0350 = "同意请款";

	public static final String SUB_SIN_STATUS_Nm_0332 = "请款申请";

	// ######################################################add by zhangshiqiang#######子订单类型
	/**
	 * 实物 -- 00
	 **/
	public static final String SUB_ORDER_TYPE_00 = "00";
	/**
	 * 虚拟 -- 01
	 **/
	public static final String SUB_ORDER_TYPE_01 = "01";
	/**
	 * O2O -- 02
	 **/
	public static final String SUB_ORDER_TYPE_02 = "02";

	// ######################################################add by zhangshiqiang#######产品状态0启用1禁用
	/**
	 * 0启用
	 **/
	public static final String USEING_COMMON_STATUS_0 = "0";
	/**
	 * 1禁用
	 **/
	public static final String USEING_COMMON_STATUS_1 = "1";

	// ######################################################add by
	// zhangshiqiang#######业务类型代码YG:广发商城(一期)JF:积分商城FQ:广发商城(分期)
	/**
	 * YG:广发商城
	 **/
	public static final String BUSINESS_TYPE_YG = "YG";
	public static final String BUSINESS_TYPE_NM_YG = "广发商城(一期)";
	/**
	 * JF:积分商城
	 **/
	public static final String BUSINESS_TYPE_JF = "JF";
	public static final String BUSINESS_TYPE_NM_JF = "积分商城";
	/**
	 * FQ:分期
	 **/
	public static final String BUSINESS_TYPE_FQ = "FQ";
	public static final String BUSINESS_TYPE_NM_FQ = "广发商城(分期)";

	// ######################################################add by chenle#######各种渠道上下架状态 0：已上架 1：未上架
	/**
	 * 广发商城上架状态 00：处理中
	 **/
	public static final String CHANNEL_MALL_00 = "00";
	/**
	 * 广发商城上架状态 01：在库
	 **/
	public static final String CHANNEL_MALL_01 = "01";
	/**
	 * 广发商城上架状态 02：上架
	 **/
	public static final String CHANNEL_MALL_02 = "02";
	/**
	 * CC上架状态 00：处理中
	 **/
	public static final String CHANNEL_CC_00 = "00";
	/**
	 * CC上架状态 01：在库
	 **/
	public static final String CHANNEL_CC_01 = "01";
	/**
	 * CC上架状态 02：上架
	 **/
	public static final String CHANNEL_CC_02 = "02";
	/**
	 * 广发商城微信上架状态 00:处理中
	 **/
	public static final String CHANNEL_MALL_WX_00 = "00";
	public static final String CHANNEL_MALL_WX_00_NAME = "处理中";
	/**
	 * 广发商城微信上架状态 01：在库
	 **/
	public static final String CHANNEL_MALL_WX_01 = "01";
	public static final String CHANNEL_MALL_WX_01_NAME = "在库";
	/**
	 * 广发商城微信上架状态 02：上架
	 **/
	public static final String CHANNEL_MALL_WX_02 = "02";
	public static final String CHANNEL_MALL_WX_02_NAME = "已上架";
	/**
	 * 信用卡中心微信上架状态 00:处理中
	 **/
	public static final String CHANNEL_CREDIT_WX_00 = "00";
	public static final String CHANNEL_CREDIT_WX_00_NAME = "处理中";
	/**
	 * 信用卡中心微信上架状态 01：在库
	 **/
	public static final String CHANNEL_CREDIT_WX_01 = "01";
	public static final String CHANNEL_CREDIT_WX_01_NAME = "在库";
	/**
	 * 信用卡中心微信上架状态 02：上架
	 **/
	public static final String CHANNEL_CREDIT_WX_02 = "02";
	public static final String CHANNEL_CREDIT_WX_02_NAME = "已上架";
	/**
	 * 手机商城上架状态 00:已上架
	 **/
	public static final String CHANNEL_PHONE_00 = "00";
	/**
	 * 手机商城上架状态 01：在库
	 **/
	public static final String CHANNEL_PHONE_01 = "01";
	/**
	 * 手机商城上架状态 02：上架
	 **/
	public static final String CHANNEL_PHONE_02 = "02";
	/**
	 * APP上架状态 00:已上架
	 **/
	public static final String CHANNEL_APP_00 = "00";
	/**
	 * APP上架状态 01：在库
	 **/
	public static final String CHANNEL_APP_01 = "01";
	/**
	 * APP上架状态 02：上架
	 **/
	public static final String CHANNEL_APP_02 = "02";
	/**
	 * 短信上架状态 00:已上架
	 **/
	public static final String CHANNEL_SMS_00 = "00";
	/**
	 * 短信上架状态 01：在库
	 **/
	public static final String CHANNEL_SMS_01 = "01";
	/**
	 * 短信上架状态 02：上架
	 **/
	public static final String CHANNEL_SMS_02 = "02";
	/**
	 * 积分商城状态 00：已上架
	 */
	public static final String CHANNEL_POINTS_00 = "00";
	/**
	 * 积分商城状态 01：已上架
	 */
	public static final String CHANNEL_POINTS_01 = "01";
	/**
	 * 积分商城状态 02：已上架
	 */
	public static final String CHANNEL_POINTS_02 = "02";
	/**
	 * ivr状态 00：已上架
	 */
	public static final String CHANNEL_IVR_00 = "00";
	/**
	 * ivr状态 01：已上架
	 */
	public static final String CHANNEL_IVR_01 = "01";
	/**
	 * ivr状态 02：已上架
	 */
	public static final String CHANNEL_IVR_02 = "02";

	// ######################################################add by yuxinxin#######默认搜索词启用状态 0启用 1禁用
	/**
	 * 默认搜索词状态 0：启用
	 **/
	public static final String DEFAULT_SEAR_0 = "0";

	/**
	 * 默认搜索词状态 1：禁用
	 **/
	public static final String DEFAULT_SEAR_1 = "1";
	/**
	 * 退货单状态值
	 **/
	public static final String CURSTAUSID_0335 = "0335";// 拒绝退货
	public static final String CURSTAUSID_0327 = "0327";// 同意退货
	public static final String CURSTATUSID_0334 = "0334";// 待处理退货
	/**
	 * 退货状态 1 撤单状态 0
	 **/
	public static final String OPERATIONTYPE_1 = "1";
	public static final String OPERATIONTYPE_0 = "0";

	/**
	 * tab页区分 type等于2时是待处理退货
	 **/
	public static final String TYPE_2 = "2";

	/** 删除状态 **/
	/**
	 * 0未删除
	 **/
	public static final Integer DEL_FG_0 = 0;
	// ######################################################add by 张成#######新消息未读已读 0：未读 1：已读
	/**
	 * 供应商消息状态 0：未读
	 **/
	public static final String VENDOR_MESSAGE_READ_0 = "0";
	/**
	 * 供应商消息状态 0：未读
	 **/
	public static final String VENDOR_MESSAGE_READ_1 = "1";

	// ######################################################add by tanliang #######//产品--创建类型0平台创建1自动创建
	/**
	 * 0平台创建
	 **/
	public static final String CERATE_TYPE_ADMIN_0 = "0";
	/**
	 * 1自动创建
	 **/
	public static final String CREATE_TYPE_AUTO_1 = "1";

	// ######################################################add by zhangshiqiang #######//商品是否内销
	/**
	 * 0是 内销
	 **/
	public static final String IS_INNER_0 = "0";
	/**
	 * 1否 不是内销
	 **/
	public static final String IS_INNER_1 = "1";

	// ######################################################add by liuhan #######//审核记录
	// 审核记录-业务类型
	/**
	 * PPSH 品牌审核
	 **/
	public static final String PPSH = "品牌审核";
	/**
	 * SPSH_FIRST 商品初审
	 **/
	public static final String SPSH_FIRST = "商品初审";
	/**
	 * SPSH_SECOND 商品复审
	 **/
	public static final String SPSH_SECOND = "商品复审";
	/**
	 * SPSH_CHANGE 商品变更审核
	 **/
	public static final String SPSH_CHANGE = "商品变更审核";
	/**
	 * SPSH_PRICE 价格变更审核
	 **/
	public static final String SPSH_PRICE = "价格变更审核";
	/**
	 * SPSH_OFFSHELF 下架申请审核
	 **/
	public static final String SPSH_OFFSHELF = "下架申请审核";
	/**
	 * SPSH_PRICED 待定价审核
	 **/
	public static final String SPSH_PRICED = "待定价审核";

	public static final String SQXJ ="申请下架";

	// 审核记录-审核结果类型
	/**
	 * PASS 通过
	 **/
	public static final String PASS = "通过";
	/**
	 * REJECT 拒绝
	 **/
	public static final String REJECT = "拒绝";

	// ######################################################add by chenle #######//商品审核类型
	/**
	 * GOODS_APPROVE_TYPE_1 商品初审
	 **/
	public static final String GOODS_APPROVE_TYPE_2 = "2";
	/**
	 * GOODS_APPROVE_TYPE_2 商品复审
	 **/
	public static final String GOODS_APPROVE_TYPE_3 = "3";

	// ######################################################add by niufw#######供应商审核状态
	/**
	 * 供应商审核状态 0待审核（新增）
	 ***/
	public static final String VENDOR_APPROVE_STATUS_0 = "0";
	/**
	 * 供应商审核状态 1已审核
	 ***/
	public static final String VENDOR_APPROVE_STATUS_1 = "1";
	/**
	 * 供应商审核状态 2待审核(编辑)
	 ***/
	public static final String VENDOR_APPROVE_STATUS_2 = "2";
	/**
	 * 供应商审核状态 3已拒绝（新增）
	 **/
	public static final String VENDOR_APPROVE_STATUS_3 = "3";
	/**
	 * 供应商审核状态 4已拒绝（编辑）
	 **/
	public static final String VENDOR_APPROVE_STATUS_4 = "4";
	// ######################################################add by niufw#######供应商启用状态
	/**
	 * 供应商启用状态 0101未启用
	 ***/
	public static final String VENDOR_COMMON_STATUS_0101 = "0101";
	/**
	 * 供应商启用状态 0102已启用
	 ***/
	public static final String VENDOR_COMMON_STATUS_0102 = "0102";
	// ######################################################add by niufw#######商城收货地址默认状态
	/**
	 * 收货地址默认 0默认地址
	 ***/
	public static final String MALL_ADDRESS_STATUS_0 = "0";
	/**
	 * 收货地址设为默认 1设为默认
	 ***/
	public static final String MALL_ADDRESS_STATUS_1 = "1";

	// ######################################################add by chenle #######//商品审核类型
	/**
	 * CREATE_TYPE_0 平台创建
	 **/
	public static final String CREATE_TYPE_0 = "0";
	/**
	 * CREATE_TYPE_1 供应商创建
	 **/
	public static final String CREATE_TYPE_1 = "1";

	// ######################################################add by wangqi#######供应商订单发货
	/**
	 * 用户类型0：系统用户[批量]
	 ***/
	public static final String VENDOR_USER_TYPE_0 = "0";
	/**
	 * 用户类型1：内部用户
	 ***/
	public static final String VENDOR_USER_TYPE_1 = "1";
	/**
	 * 用户类型2：供应商
	 ***/
	public static final String VENDOR_USER_TYPE_2 = "2";
	/**
	 * 用户类型3：持卡人
	 ***/
	public static final String VENDOR_USER_TYPE_3 = "3";

	// ######################################################add by yanjie.cao#######供应商tab切换type类型值
	/**
	 * 所有订单
	 ***/
	public static final String VENDOR_ORDER_TYPE_1 = "1";
	/**
	 * 发货处理中订单
	 ***/
	public static final String VENDOR_ORDER_TYPE_2 = "2";
	/**
	 * 代发货订单
	 ***/
	public static final String VENDOR_ORDER_TYPE_3 = "3";
	/**
	 * 已发货订单
	 ***/
	public static final String VENDOR_ORDER_TYPE_4 = "4";
	/**
	 * 已发码及已签收订单
	 ***/
	public static final String VENDOR_ORDER_TYPE_5 = "5";

	// ######################################################add by yanjie.cao#######供应商订单更新状态码
	/**
	 * 未付款"状态置为"已取消"状态订单
	 ***/
	public static final String VENDOR_ORDER_UPDATE_TYPE_CANCELED = "001";
	/**
	 * "已发货"状态置为"已签收"状态订单
	 ***/
	public static final String VENDOR_ORDER_UPDATE_TYPE_SIGNED = "010";
	/**
	 * "已发货"状态置为"拒绝签收"状态订单
	 ***/
	public static final String VENDOR_ORDER_UPDATE_TYPE__SIGNED_REFUSED = "011";
	/**
	 * "已发货"状态置为"无人签收"状态订单
	 ***/
	public static final String VENDOR_ORDER_UPDATE_TYPE_SIGNED_NONE = "100";
	/**
	 * "已发码"状态置为"已过期"状态订单
	 ***/
	public static final String VENDOR_ORDER_UPDATE_TYPE_CODE_EXPIRED = "101";
	// ######################################################add by minglei.yu#######订单活动类型
	/**
	 * 订单活动类型 团购
	 */
	public static final String ORDER_ACT_TYPE_TEAM = "1";
	/**
	 * 订单活动类型 秒杀
	 */
	public static final String ORDER_ACT_TYPE_SECOND = "2";
	// ######################################################add by yanjie.cao#######订单撤单退货区分标识
	/***
	 * 订单操作类型 撤单
	 **/
	public static final Integer ORDER_INTEGER_PARTBACK_OPERATIONTYPE_REVOKE = 0;
	public static final String ORDER_PARTBACK_OPERATIONTYPE_REVOKE = "0";
	/***
	 * 订单操作类型 退货
	 **/
	public static final String ORDER_PARTBACK_OPERATIONTYPE_RETURN = "1";
	public static final Integer ORDER_INTEGER_PARTBACK_OPERATIONTYPE_RETURN = 1;
	// ######################################################add by Tanliang 消息类型0交易动态1售后信息2促销活动
	public static final String USER_MESSAGE_TYEP_0 = "交易动态";
	public static final String USER_MESSAGE_TYEP_1 = "售后信息";
	public static final String USER_MESSAGE_TYEP_2 = "促销活动";
	// ######################################################add by Wujiao 订单来源渠道id00: 商城01: callcenter02: ivr渠道03: 手机商城
	public static final String ORDER_SOURCE_ID_MALL = "00";
	public static final String ORDER_SOURCE_NM_MALL = "广发商城";
	public static final String ORDER_SOURCE_ID_CC = "01";
	public static final String ORDER_SOURCE_NM_CC = "callcenter";
	public static final String ORDER_SOURCE_ID_IVR = "02";
	public static final String ORDER_SOURCE_NM_IVR = "ivr渠道";
	public static final String ORDER_SOURCE_ID_MOBILE = "03";
	public static final String ORDER_SOURCE_NM_MOBILE = "手机商城";
	// 支付方式代码0001: 现金0002: 积分0003: 积分+现金0004: 手续费0005: 现金+手续费0006: 积分+手续费0007: 积分+现金+手续费
	public static final String PAY_WAY_CODE_XJ = "0001";
	public static final String PAY_WAY_NM_XJ = "现金";
	public static final String PAY_WAY_CODE_JF = "0002";
	public static final String PAY_WAY_NM_JF = "积分";
	public static final String PAY_WAY_CODE_JFXJ = "0003";
	public static final String PAY_WAY_NM_JFXJ = "积分+现金";
	public static final String PAY_WAY_CODE_FEE = "0004";
	public static final String PAY_WAY_NM_FEE = "手续费";
	public static final String PAY_WAY_CODE_XJFEE = "0005";
	public static final String PAY_WAY_NM_XJFEE = "现金+手续费";
	public static final String PAY_WAY_CODE_JFFEE = "0006";
	public static final String PAY_WAY_NM_JFFEE = "积分+手续费";
	public static final String PAY_WAY_CODE_JFXJFEE = "0007";
	public static final String PAY_WAY_NM_JFXJFEE = "积分+现金+手续费";
	// 商品类型（00实物01虚拟02O2O）
	public static final String GOODS_TYPE_NM_00 = "实物";
	public static final String GOODS_TYPE_NM_01 = "虚拟";
	public static final String GOODS_TYPE_NM_02 = "O2O";

	// ######################################################add by yanjie.cao#######订单撤单退货类型
	/**
	 * 退货（撤单）类型00用户
	 ***/
	public static final String ORDER_RETURN_OR_REVOKE_TYPE_USER = "00";
	/**
	 * "退货（撤单）类型01商城
	 ***/
	public static final String ORDER_RETURN_OR_REVOKE_TYPE_VENDOR = "01";
	/**
	 * "退货（撤单）类型02CC端
	 ***/
	public static final String ORDER_RETURN_OR_REVOKE_TYPE_CC = "02";

	// ######################################################add by qi.wang#######加入购物车支付类型
	/**
	 * 立即支付
	 ***/
	public static final String CART_PAY_TYPE_1 = "1";
	/**
	 * 分1期信用卡支付
	 ***/
	public static final String CART_PAY_TYPE_2 = "2";

	// ######################################################add by tanliang####### 日志平台类型
	public static final String LOGS_TYPE_YG = "广发商城";
	public static final String LOGS_TYPE_JF = "积分商城";
	public static final String LOGS_TYPE_NG = "内管系统";
	public static final String LOGS_TYPE_VD = "供应商系统";
	public static final String LOGS_TYPE_CC = "CallCenter";
	// ######################################################add by tanliang####### 日志操作动作
	public static final String ACTION_TYPE_0401 = "登录成功";
	public static final String ACTION_TYPE_0402 = "登录失败";
	public static final String ACTION_TYPE_0403 = "注销";

	// ######################################################add by wushiyi####### 调用接口返回码

	/**
	 * 登录状态0成功 1失败
	 ***/
	public static final String LOGIN_STATUS_TRUE = "0";
	public static final String LOGIN_STATUS_FALSE = "1";

	/**
	 * 登录第一次 0第一次 1不是
	 ***/
	public static final String LOGIN_ISFIRST_0 = "0";
	public static final String LOGIN_ISFIRST_1 = "1";

	/**
	 * 供应商平台登录用户级别 0管理员 1普通用户
	 ***/
	public static final String LOGIN_LEVEL_0 = "0";
	public static final String LOGIN_LEVEL_1 = "1";

	/**
	 * 验证渠道码0不校验 2手机 6电话
	 ***/
	public static final String IS_CHECK_PASSWORD_NULL = "0";
	public static final String IS_CHECK_PASSWORD_MOBILE = "2";
	public static final String IS_CHECK_PASSWORD_PHONE = "6";

	/**
	 * 返回码 000000成功
	 ***/
	public static final String RETRUN_CODE_000000 = "000000";
	/**
	 * 登录返回码
	 ***/
	public static final String LOGIN_RETRUN_CODE_00000000 = "00000000";
	public static final String LOGIN_RETRUN_CODE_00000001 = "00000001";
	public static final String LOGIN_RETRUN_CODE_00000002 = "00000002";
	public static final String LOGIN_RETRUN_CODE_PA020100 = "PA020100";
	public static final String LOGIN_RETRUN_CODE_PA020101 = "PA020101";
	public static final String LOGIN_RETRUN_CODE_PA020102 = "PA020102";
	public static final String LOGIN_RETRUN_CODE_PA020103 = "PA020103";
	public static final String LOGIN_RETRUN_CODE_PA020104 = "PA020104";
	public static final String LOGIN_RETRUN_CODE_PA020105 = "PA020105";
	public static final String LOGIN_RETRUN_CODE_PA020106 = "PA020106";
	public static final String LOGIN_RETRUN_CODE_PA020107 = "PA020107";
	public static final String LOGIN_RETRUN_CODE_PA020108 = "PA020108";
	public static final String LOGIN_RETRUN_CODE_PA020109 = "PA020109";
	public static final String LOGIN_RETRUN_CODE_PA020110 = "PA020110";
	public static final String LOGIN_RETRUN_CODE_PA020111 = "PA020111";
	public static final String LOGIN_RETRUN_CODE_PA020112 = "PA020112";
	public static final String LOGIN_RETRUN_CODE_PA020113 = "PA020113";
	public static final String LOGIN_RETRUN_CODE_PA020114 = "PA020114";
	public static final String LOGIN_RETRUN_CODE_PA020115 = "PA020115";

	/**
	 * 交易渠道 BC商城 CC电话银行
	 ***/
	public static final String CHANNEL_BC = "BC";
	public static final String CHANNEL_CC = "CC";

	/**
	 * 优惠卷发放种类 1:商城首次登录 2:CC补发
	 ***/
	public static final Byte GRANT_TYPE_1 = new Byte("1");
	public static final Byte GRANT_TYPE_2 = new Byte("2");

	/**
	 * 密码长度
	 ***/
	public static final int RSA_2048_LENGTH = 512;

	/**
	 * 限定
	 ***/
	public static final String delim = ",";
	public static final String delim2 = "/";
	public static final String delim3 = ".xls";
	public static final String delim4 = " ";

	// ######################################################add by tanliang####### 公告类型
	public static final String PUBLISH_TYPE_CODE_00 = "00";
	public static final String PUBLISH_TYPE_NAME_00 = "最新公告";
	// ######################################################add by tanliang####### 公告启用状态 0101：未启用 0102：已启用
	public static final String PUBLISH_STATUS_CODE_0101 = "0101";
	public static final String PUBLISH_STATUS_NAME_0101 = "停用";
	public static final String PUBLISH_STATUS_CODE_0102 = "0102";
	public static final String PUBLISH_STATUS_NAME_0102 = "启用";

	// ######################################################add by wangqi####### 活动有效状态 0：无效 1：有效
	public static final Integer IS_VALID_0 = 0;
	public static final Integer IS_VALID_1 = 1;
	// ######################################################add by wangqi####### 活动是否需要报名 0：不需要 1：需要
	public static final Integer PROMOTION_IS_SIGNUP_0 = 0;
	public static final Integer PROMOTION_IS_SIGNUP_1 = 1;
	// ######################################################add by wangqi####### 活动状态 0：待审核 1：通过审核 2:未通过审核
	/** 添加(未提交审批) */
	public static final Integer PROMOTION_STATE_0 = 0;
	/** 编辑(未提交审批) */
	public static final Integer PROMOTION_STATE_1 = 1;
	/** 已提交(待初审) */
	public static final Integer PROMOTION_STATE_2 = 2;
	/** 已提交(已初审通过) */
	public static final Integer PROMOTION_STATE_3 = 3;
	/** 已提交(未初审通过) */
	public static final Integer PROMOTION_STATE_4 = 4;
	/** 已提交(待复审) */
	public static final Integer PROMOTION_STATE_5 = 5;
	/** 已提交(未通过) */
	public static final Integer PROMOTION_STATE_6 = 6;
	/** 已提交(已通过) */
	public static final Integer PROMOTION_STATE_7 = 7;
	/** 已提交(部分通过) */
	public static final Integer PROMOTION_STATE_8 = 8;
	/** 正在进行 */
	public static final Integer PROMOTION_STATE_9 = 9;
	/** 已停止[活动执行过&结束时间小于当前时间] */
	public static final Integer PROMOTION_STATE_10 = 10;
	/** 已取消 */
	public static final Integer PROMOTION_STATE_11 = 11;
	/** 已失效[结束时间小于当前时间] */
	public static final Integer PROMOTION_STATE_12 = 12;
	/** 已删除 */
	public static final Integer PROMOTION_STATE_13 = 13;

	/** 活动创建人类型 1：平台 */
	public static final Integer PROMOTION_CREATE_OPER_TYPE_0 = 0;
	/** 活动创建人类型 2：供应商 */
	public static final Integer PROMOTION_CREATE_OPER_TYPE_1 = 1;

	/** 活动创建人类型 1：平台 */
	public static final String PROMOTION_CREATE_OPER_TYPE_NAME_0 = "平台";
	/** 活动创建人类型 2：供应商 */
	public static final String PROMOTION_CREATE_OPER_TYPE_NAME_1 = "供应商";

	/** 活动类型名称 1：折扣 */
	public static final Integer PROMOTION_PROM_TYPE_1 = 10;
	/** 活动类型名称 2：满减 */
	public static final Integer PROMOTION_PROM_TYPE_2 = 20;
	/** 活动类型名称 3：秒杀 */
	public static final Integer PROMOTION_PROM_TYPE_3 = 30;
	/** 活动类型名称 4：团购 */
	public static final Integer PROMOTION_PROM_TYPE_4 = 40;
	/** 活动类型名称 5：荷兰拍 */
	public static final Integer PROMOTION_PROM_TYPE_5 = 50;

	/** 活动类型名称 1：折扣 */
	public static final String PROMOTION_PROM_TYPE_NAME_1 = "折扣";
	/** 活动类型名称 2：满减 */
	public static final String PROMOTION_PROM_TYPE_NAME_2 = "满减";
	/** 活动类型名称 3：秒杀 */
	public static final String PROMOTION_PROM_TYPE_NAME_3 = "秒杀";
	/** 活动类型名称 4：团购 */
	public static final String PROMOTION_PROM_TYPE_NAME_4 = "团购";
	/** 活动类型名称 5：荷兰拍 */
	public static final String PROMOTION_PROM_TYPE_NAME_5 = "荷兰拍";

	/** 活动循环执行 按天 */
	public static final String PROMOTION_LOOP_TYPE_D = "d";
	/** 活动循环执行 按周 */
	public static final String PROMOTION_LOOP_TYPE_W = "w";
	/** 活动循环执行 按月 */
	public static final String PROMOTION_LOOP_TYPE_M = "m";

	/** 是否可以使用优惠券 0：不可以 */
	public static final Integer PROMOTION_COUPONENABLE_0 = 0;
	/** 是否可以使用优惠券 1：可以 */
	public static final Integer PROMOTION_COUPONENABLE_1 = 1;

	/** 选品状态 0：未审核 */
	public static final String PROMOTION_RANGE_CHECK_STATUS_0 = "0";
	/** 选品状态 1：已通过 */
	public static final String PROMOTION_RANGE_CHECK_STATUS_1 = "1";
	/** 选品状态 2：已拒绝 */
	public static final String PROMOTION_RANGE_CHECK_STATUS_2 = "2";

	/** 销售渠道 code 00商城 */
	public static final String PROMOTION_SOURCE_ID_00 = "00";
	/** 销售渠道 名称 00商城 */
	public static final String PROMOTION_SOURCE_NAME_00 = "商城";
	/** 销售渠道 code 01CC */
	public static final String PROMOTION_SOURCE_ID_01 = "01";
	/** 销售渠道 名称 01CC */
	public static final String PROMOTION_SOURCE_NAME_01 = "商城";
	/** 销售渠道 code 02IVR */
	public static final String PROMOTION_SOURCE_ID_02 = "02";
	/** 销售渠道 名称 02IVR */
	public static final String PROMOTION_SOURCE_NAME_02 = "IVR";
	/** 销售渠道 ocde 03手机商城 */
	public static final String PROMOTION_SOURCE_ID_03 = "03";
	/** 销售渠道 名称 03手机商城 */
	public static final String PROMOTION_SOURCE_NAME_03 = "手机商城";
	/** 销售渠道 code 04短信 */
	public static final String PROMOTION_SOURCE_ID_04 = "04";
	/** 销售渠道 名称 04短信 */
	public static final String PROMOTION_SOURCE_NAME_04 = "短信";
	/** 销售渠道 code 05微信广发银行 */
	public static final String PROMOTION_SOURCE_ID_05 = "05";
	/** 销售渠道 名称 05微信广发银行 */
	public static final String PROMOTION_SOURCE_NAME_05 = "微信广发银行";
	/** 销售渠道 code 06微信广发信用卡 */
	public static final String PROMOTION_SOURCE_ID_06 = "06";
	/** 销售渠道 名称 00微信广发信用卡 */
	public static final String PROMOTION_SOURCE_NAME_06 = "微信广发信用卡";
	/** 销售渠道 code 09 APP */
	public static final String PROMOTION_SOURCE_ID_09 = "09";
	/** 销售渠道 名称 09 APP */
	public static final String PROMOTION_SOURCE_NAME_09 = "APP";

	// ######################################################add by chenle####### 品牌发布状态 00已发布01等待审核21等待发布
	public static final String BRAND_PUBLIST_STATUS_00 = "00";
	public static final String BRAND_PUBLIST_STATUS_01 = "01";
	public static final String BRAND_PUBLIST_STATUS_02 = "02";

	// ######################################################add by chenle####### 单品置顶状态 0非置顶 1置顶
	public static final Integer STICK_FLAG_0 = 0;
	public static final Integer STICK_FLAG_1 = 1;
	// ######################################################add by wujiao####### 信用卡借记卡类型 Ｙ：借记卡 Ｃ：信用卡
	public static final String CARD_TYPE_C = "C";
	public static final String CARD_TYPE_Y = "Y";
	public static final int CARD_TYPE_CREDIT = 30;

	// 数据集市提供等级 - 普卡
	public static final String LEVEL_CODE_0 = "01";
	// 数据集市提供等级 - 金卡
	public static final String LEVEL_CODE_1 = "02";
	// 数据集市提供等级 - 钛金卡
	public static final String LEVEL_CODE_2 = "03";
	// 数据集市提供等级 - 白金卡
	public static final String LEVEL_CODE_3 = "04";
	// 数据集市提供等级 - 顶级卡
	public static final String LEVEL_CODE_4 = "05";

	// 类型 0：普卡/金卡 1：钛金卡/臻享白金卡 2：顶级/增值白金卡 3：vip 4：生日
	public static final String MEMBER_LEVEL_JP = "0";
	public static final String MEMBER_LEVEL_TJ = "1";
	public static final String MEMBER_LEVEL_DJ = "2";
	public static final String MEMBER_LEVEL_VIP = "3";
	public static final String MEMBER_LEVEL_BIRTH = "4";
	public static final String MEMBER_LEVEL_JP_NM = "普卡/金卡";
	public static final String MEMBER_LEVEL_TJ_NM = "钛金卡/臻享白金卡";
	public static final String MEMBER_LEVEL_DJ_NM = "顶级/增值白金卡";
	public static final String MEMBER_LEVEL_VIP_NM = "vip";
	public static final String MEMBER_LEVEL_BIRTH_NM = "生日";
	// 增值白金
	public static final String INCREMENT_BJ = "2";

	// ************************************************微信商品EXCEL模板名称****************/
	public static final String WECHAT_ITEM_EXCEL = "微信商品导入模板.xls";

	// ######################################################add by chenle####### 商品操作类型：1新增，2编辑信息，3改价，4改库存，5申请下架，6批量导入
	public static final Integer GOODS_OPERATE_TYPE_1 = 1;
	public static final Integer GOODS_OPERATE_TYPE_2 = 2;
	public static final Integer GOODS_OPERATE_TYPE_3 = 3;
	public static final Integer GOODS_OPERATE_TYPE_4 = 4;
	public static final Integer GOODS_OPERATE_TYPE_5 = 5;
	public static final Integer GOODS_OPERATE_TYPE_6 = 6;

	// ************************************************add by tongxueying****************/ 礼品分区当前状态：0启用 1禁用
	public static final String PARTITION_STATUS_QY = "0";
	public static final String PARTITION_STATUS_TY = "1";
	// ************************************************add by tongxueying****************/ 礼品分区发布状态：0未发布 1已发布
	public static final String PARTITION_PUBLISH_STATUS_0 = "0";
	public static final String PARTITION_PUBLISH_STATUS_1 = "1";

	//	商城渠道标志
	public static final String SOURCE_ID_MALL = "00";
	//cc渠道标志
	public static final String SOURCE_ID_CC = "01";
	//IVR渠道标志
	public static final String SOURCE_ID_IVR = "02";
	//手机渠道标志
	public static final String SOURCE_ID_CELL = "03";
	//短信渠道标志
	public static final String SOURCE_ID_MESSAGE = "04";
	//  广发银行（微信）渠道标志
	public static final String SOURCE_ID_WX_BANK = "05";
	//  广发信用卡（微信）渠道标志
	public static final String SOURCE_ID_WX_CARD = "06";
	//商城渠道上送积分系统标志
	public static final String SOURCE_ID_MALL_TYPY = "MALL";
	//cc渠道上送积分系统标志
	public static final String SOURCE_ID_CC_TYPY = "CCAG";
	//IVR渠道上送积分系统标志
	public static final String SOURCE_ID_IVR_TYPY = "CCAG";
	//手机渠道上送积分系统标志
	public static final String SOURCE_ID_CELL_TYPY = "CS";
	//短信渠道上送积分系统标志
	public static final String SOURCE_ID_MESSAGE_TYPY = "SMSP";
	//微信渠道上送积分系统标志
	public static final String SOURCE_ID_WX_TYPY = "WX";
	//已下单 0309：已发货[只在订单处理明细表使用，发货时记录]
	public static final String ORDER_STATUS_CODE_HAS_ORDERS = "0308";
	//************************************************add by yanjie.ao****************/   对账文件积分优惠券 是否出具标识
	public static final String ORDER_ISCHECK_YES = "0"; //是否需要出具优惠券对账文件   0-需要   1-不需要
	public static final String ORDER_ISCHECK_NO = "1";
	public static final String ORDER_ISPOINT_YES = "0";//是否出具积分对账文件   0-需要  1-不需要
	public static final String ORDER_ISPOINT_NO = "1";
	//************************************************add by yanjie.ao****************/   电子支付退货接口
	public static final String GATEWAY_ENVELOPE_TRADECODE_NETBANK_RETURN_NEW = "NSCT018";
	public static final String TRADECHANNEL="EBS"; //交易渠道
	public static final String TRADESOURCE="#SC"; //交易来源
	public static final String BIZSIGHT="00"; //业务场景(常规业务：00)
	public static final String SUCCESS_CODE="000000";//接口返回成功码


	//*****************************************************add by chenle*************/支付方式代码
	public static final String PAY_WAY_CODE_0001 = "0001";//现金
	public static final String PAY_WAY_CODE_0002 = "0002";//积分
	public static final String PAY_WAY_CODE_0003 = "0003";//现金+积分


	//************************************************add by zhiyu.cong ****************/	积分类型
	public static final String JGID_COMMON = "1";	//普通积分
	public static final String JGID_COMMON_FORMAT = "001";//普通积分 转换
	public static final String JGID_HOPE = "3";		//希望卡积分
	public static final String JGID_HOPE_FORMAT = "002";	//希望卡积分 转换
	public static final String JGID_TRUTH = "66";	//真情卡新客户礼遇积分
	public static final String JGID_TRUTH_FORMAT = "003";	//真情卡新客户礼遇积分 转换


}

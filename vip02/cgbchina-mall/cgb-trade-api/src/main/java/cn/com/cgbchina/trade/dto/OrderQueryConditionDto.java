package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.common.contants.Contants;
import com.google.common.collect.Maps;
import lombok.Getter;
import lombok.Setter;
import org.apache.commons.lang3.StringUtils;

import java.io.Serializable;
import java.util.Map;

/**
 * 查询条件
 *
 * 用于前台form表单传值 Created by zhoupeng on 2016/7/20.
 */
public class OrderQueryConditionDto implements Serializable {

	private static final long serialVersionUID = 3658645068963885626L;
	@Setter
	@Getter
	private String ordermainId;
	@Setter
	@Getter
	private String orderId;
	@Setter
	@Getter
	private String curStatusId;
	@Setter
	@Getter
	private String goodsType;
	@Setter
	@Getter
	private String sourceId;
	@Setter
	@Getter
	private String goodsId;
	@Setter
	@Getter
	private String memberName;
	@Setter
	@Getter
	private String ordertypeId;
	@Setter
	@Getter
	private String startTime;
	@Setter
	@Getter
	private String endTime;
	@Setter
	@Getter
	private String limitFlag;
	@Setter
	@Getter
	private String tabtype;// tab页类型，区分订单状态
	@Getter
	@Setter
	private String vendorSnm;
	@Setter
	@Getter
	private String cardno;
	@Getter
	@Setter
	private String sinStatusId;
	@Getter
	@Setter
	private String searchType;//默认时间一个月--内管z
	@Getter
	@Setter
	private String findUserId;//查询者id
	@Getter
	@Setter
	private String goodsNm;
	@Getter
	@Setter
	private String custType;
	@Getter
	@Setter
	private String delFile;//删除文件
	@Getter
	@Setter
	private String orderFileName;//删除文件名
	//请款使用补充
	@Getter
	@Setter
	private String roleFlag;
	@Getter
	@Setter
	private String vendorId;
	@Getter
	@Setter
	private String actTypeSecond;
	@Getter
	@Setter
	private String curStatusReceive;
	@Getter
	@Setter
	private String curStatusBack;
	@Getter
	@Setter
	private String curStatusUnBack;
	@Getter
	@Setter
	private String tblFlag;
	@Getter
	@Setter
	private String SystemType;
	@Getter
	@Setter
	private String tabNumber;
	@Getter
	@Setter
	private String miaoshaActionFlag;
	@Getter
	@Setter
	private String goodssendFlag;

	/**
	 * 转成map
	 *
	 * @return
	 */
	public Map<String, Object> toMap() {
		Map<String, Object> map = Maps.newHashMap();
		map.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
		if (StringUtils.isNotEmpty(this.ordermainId)) {
			map.put("ordermainId", this.ordermainId);
		}
		if (StringUtils.isNotEmpty(this.orderId)) {
			map.put("orderId", this.orderId);
		}
		if (StringUtils.isNotEmpty(this.goodsType)) {
			map.put("goodsType", this.goodsType);
		}
		if (StringUtils.isNotEmpty(this.sourceId)) {
			map.put("sourceId", this.sourceId);
		}
		if (StringUtils.isNotEmpty(this.goodsId)) {
			map.put("goodsId", this.goodsId);
		}
		if (StringUtils.isNotEmpty(this.memberName)) {
			map.put("memberName", this.memberName);
		}
		if (StringUtils.isNotEmpty(this.ordertypeId)) {
			map.put("ordertypeId", this.ordertypeId);
		}
		if (StringUtils.isNotEmpty(this.startTime)) {
			map.put("startTime", this.startTime);
		}
		if (StringUtils.isNotEmpty(this.endTime)) {
			map.put("endTime", this.endTime);
		}
		if (StringUtils.isNotEmpty(this.tabtype)) {
			map.put("tabtype", this.tabtype);
		}
		if (StringUtils.isNotEmpty(this.limitFlag)){
			map.put("limitFlag", this.limitFlag);
		}
		if (StringUtils.isNotEmpty(this.vendorSnm)) {
			map.put("vendorSnm", this.vendorSnm);
		}
		if (StringUtils.isNotEmpty(this.cardno)) {
			map.put("cardno", this.cardno);
		}
		if (StringUtils.isNotEmpty(this.sinStatusId)) {
			map.put("sinStatusId", this.sinStatusId);
		}
		if(StringUtils.isNotEmpty(curStatusId)){
			map.put("curStatusId", this.curStatusId);
		}
		if(StringUtils.isNotEmpty(searchType)){
			map.put("searchType", this.searchType);
		}
		if(StringUtils.isNotEmpty(findUserId)){
			map.put("findUserId", this.findUserId);
		}
		if(StringUtils.isNotEmpty(goodsNm)){
			map.put("goodsNm", this.goodsNm);
		}
		if(StringUtils.isNotEmpty(custType)){
			map.put("custType", this.custType);
		}
		return map;
	}
}

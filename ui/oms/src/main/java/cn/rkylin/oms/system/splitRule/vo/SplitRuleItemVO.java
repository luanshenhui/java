package cn.rkylin.oms.system.splitRule.vo;

import org.apache.commons.lang.StringUtils;

import cn.rkylin.oms.system.splitRule.domain.SplitRuleItem;

/**
 * 分担规则详情
 * @author jinshen
 *
 */
public class SplitRuleItemVO extends SplitRuleItem {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1396999563952888060L;
	private static final String OPERATION_SELECT_ITEM = "<input type=\"checkbox\" ecItemId=\"%s\" name=\"ecItemId\"/>";
	private static final String OPERATION_SELECT_ITEM_DISABLED = "<input type=\"checkbox\" disabled/>";
	/**
	 * shopId
	 */
	private String shopId;
	/**
	 * 其他的SQL
	 */
	private String otherSql;
	/**
	 * orderBy子句
	 */
	private String orderBy;
	/**
	 * 搜索条件
	 */
	private String searchCondition;
	/**
	 * 搜索条件
	 */
	private String searchItemCondition;
	/**
	 * 平台商品编码
	 */
	private String ecItemCode;
	/**
	 * 平台商品名称
	 */
	private String ecItemName;
	/**
	 * 商品主键
	 */
	private String ecItemId;
	/**
	 * 商家编码
	 */
	private String outerCode;
	/**
	 * checkbox
	 */
	private String itemSelect;
	/**
	 * 店铺
	 */
	private String shopname;
	
	public String getEcItemCode() {
		return ecItemCode;
	}
	public void setEcItemCode(String ecItemCode) {
		this.ecItemCode = ecItemCode;
	}
	public String getEcItemName() {
		return ecItemName;
	}
	public void setEcItemName(String ecItemName) {
		this.ecItemName = ecItemName;
	}
	public String getEcItemId() {
		return ecItemId;
	}
	public void setEcItemId(String ecItemId) {
		this.ecItemId = ecItemId;
	}
	public String getOuterCode() {
		return outerCode;
	}
	public void setOuterCode(String outerCode) {
		this.outerCode = outerCode;
	}
	public String getItemSelect() {
		return itemSelect;
	}
	public void setItemSelect(String itemSelect) {
		StringBuffer opButton = new StringBuffer();
		if (StringUtils.isNotEmpty(this.getSplitShopName())) {
			opButton.append(String.format(OPERATION_SELECT_ITEM_DISABLED));
		} else {
			opButton.append(String.format(OPERATION_SELECT_ITEM,this.getEcItemId()));
		}
		this.itemSelect = opButton.toString();
	}
	
	public String getSearchCondition() {
		return searchCondition;
	}
	public void setSearchCondition(String searchCondition) {
		this.searchCondition = searchCondition;
	}
	public String getOtherSql() {
		return otherSql;
	}
	public void setOtherSql(String otherSql) {
		this.otherSql = otherSql;
	}
	public String getOrderBy() {
		return orderBy;
	}
	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}
	public String getShopId() {
		return shopId;
	}
	public void setShopId(String shopId) {
		this.shopId = shopId;
	}
	public String getShopname() {
		return shopname;
	}
	public void setShopname(String shopname) {
		this.shopname = shopname;
	}
	public String getSearchItemCondition() {
		return searchItemCondition;
	}
	public void setSearchItemCondition(String searchItemCondition) {
		this.searchItemCondition = searchItemCondition;
	}
	
}

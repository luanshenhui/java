package cn.com.cgbchina.rest.provider.model;

import java.util.List;

/**
 * Comment: Created by 11150321050126 on 2016/4/21.
 */
public class MAL101Model {
	public class Request {
		public String currentPage;
		public String cardNo;
		public String jfType;
		public String keyValue;
		public String goodsXid;
		public String bonusRegion;

		public String getCurrentPage() {
			return currentPage;
		}

		public void setCurrentPage(String currentPage) {
			this.currentPage = currentPage;
		}

		public String getCardNo() {
			return cardNo;
		}

		public void setCardNo(String cardNo) {
			this.cardNo = cardNo;
		}

		public String getJfType() {
			return jfType;
		}

		public void setJfType(String jfType) {
			this.jfType = jfType;
		}

		public String getKeyValue() {
			return keyValue;
		}

		public void setKeyValue(String keyValue) {
			this.keyValue = keyValue;
		}

		public String getGoodsXid() {
			return goodsXid;
		}

		public void setGoodsXid(String goodsXid) {
			this.goodsXid = goodsXid;
		}

		public String getBonusRegion() {
			return bonusRegion;
		}

		public void setBonusRegion(String bonusRegion) {
			this.bonusRegion = bonusRegion;
		}
	}

	public class Response {
		private String channelSN;
		private String successCode;
		private String returnCode;
		private String ReturnDes;
		private String totalPages;
		private String curPage;
		private String loopTag;
		private String loopCount;
		private List<ResponseLoop> loops;

		public String getChannelSN() {
			return channelSN;
		}

		public void setChannelSN(String channelSN) {
			this.channelSN = channelSN;
		}

		public String getSuccessCode() {
			return successCode;
		}

		public void setSuccessCode(String successCode) {
			this.successCode = successCode;
		}

		public String getReturnCode() {
			return returnCode;
		}

		public void setReturnCode(String returnCode) {
			this.returnCode = returnCode;
		}

		public String getReturnDes() {
			return ReturnDes;
		}

		public void setReturnDes(String returnDes) {
			ReturnDes = returnDes;
		}

		public String getTotalPages() {
			return totalPages;
		}

		public void setTotalPages(String totalPages) {
			this.totalPages = totalPages;
		}

		public String getCurPage() {
			return curPage;
		}

		public void setCurPage(String curPage) {
			this.curPage = curPage;
		}

		public String getLoopTag() {
			return loopTag;
		}

		public void setLoopTag(String loopTag) {
			this.loopTag = loopTag;
		}

		public String getLoopCount() {
			return loopCount;
		}

		public void setLoopCount(String loopCount) {
			this.loopCount = loopCount;
		}

		public List<ResponseLoop> getLoops() {
			return loops;
		}

		public void setLoops(List<ResponseLoop> loops) {
			this.loops = loops;
		}
	}

	public class ResponseLoop {
		private String goodsId;
		private String goodsName;
		private String goodsFType;
		private String goodsCType;
		private String cusLevel;
		private String cusLevelName;
		private String cusPrice;
		private String payCodeByM;
		private String birthPrice;
		private String payCodeByB;
		private String intergralPart;
		private String MoneyPart;
		private String payCodeByBoth;
		private String inventory;
		private String jfType;
		private String jfTypeName;
		private String goodsType;
		private String virtual_limit;
		private String virtual_mileage;
		private String goodsBid;
		private String virtual_price;

		public String getGoodsId() {
			return goodsId;
		}

		public void setGoodsId(String goodsId) {
			this.goodsId = goodsId;
		}

		public String getGoodsName() {
			return goodsName;
		}

		public void setGoodsName(String goodsName) {
			this.goodsName = goodsName;
		}

		public String getGoodsFType() {
			return goodsFType;
		}

		public void setGoodsFType(String goodsFType) {
			this.goodsFType = goodsFType;
		}

		public String getGoodsCType() {
			return goodsCType;
		}

		public void setGoodsCType(String goodsCType) {
			this.goodsCType = goodsCType;
		}

		public String getCusLevel() {
			return cusLevel;
		}

		public void setCusLevel(String cusLevel) {
			this.cusLevel = cusLevel;
		}

		public String getCusLevelName() {
			return cusLevelName;
		}

		public void setCusLevelName(String cusLevelName) {
			this.cusLevelName = cusLevelName;
		}

		public String getCusPrice() {
			return cusPrice;
		}

		public void setCusPrice(String cusPrice) {
			this.cusPrice = cusPrice;
		}

		public String getPayCodeByM() {
			return payCodeByM;
		}

		public void setPayCodeByM(String payCodeByM) {
			this.payCodeByM = payCodeByM;
		}

		public String getBirthPrice() {
			return birthPrice;
		}

		public void setBirthPrice(String birthPrice) {
			this.birthPrice = birthPrice;
		}

		public String getPayCodeByB() {
			return payCodeByB;
		}

		public void setPayCodeByB(String payCodeByB) {
			this.payCodeByB = payCodeByB;
		}

		public String getIntergralPart() {
			return intergralPart;
		}

		public void setIntergralPart(String intergralPart) {
			this.intergralPart = intergralPart;
		}

		public String getMoneyPart() {
			return MoneyPart;
		}

		public void setMoneyPart(String moneyPart) {
			MoneyPart = moneyPart;
		}

		public String getPayCodeByBoth() {
			return payCodeByBoth;
		}

		public void setPayCodeByBoth(String payCodeByBoth) {
			this.payCodeByBoth = payCodeByBoth;
		}

		public String getInventory() {
			return inventory;
		}

		public void setInventory(String inventory) {
			this.inventory = inventory;
		}

		public String getJfType() {
			return jfType;
		}

		public void setJfType(String jfType) {
			this.jfType = jfType;
		}

		public String getJfTypeName() {
			return jfTypeName;
		}

		public void setJfTypeName(String jfTypeName) {
			this.jfTypeName = jfTypeName;
		}

		public String getGoodsType() {
			return goodsType;
		}

		public void setGoodsType(String goodsType) {
			this.goodsType = goodsType;
		}

		public String getVirtual_limit() {
			return virtual_limit;
		}

		public void setVirtual_limit(String virtual_limit) {
			this.virtual_limit = virtual_limit;
		}

		public String getVirtual_mileage() {
			return virtual_mileage;
		}

		public void setVirtual_mileage(String virtual_mileage) {
			this.virtual_mileage = virtual_mileage;
		}

		public String getGoodsBid() {
			return goodsBid;
		}

		public void setGoodsBid(String goodsBid) {
			this.goodsBid = goodsBid;
		}

		public String getVirtual_price() {
			return virtual_price;
		}

		public void setVirtual_price(String virtual_price) {
			this.virtual_price = virtual_price;
		}
	}
}

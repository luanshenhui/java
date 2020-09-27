package cn.com.cgbchina.trade.vo;

import cn.com.cgbchina.trade.vo.NoAs400EnvolopeVo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 发送柜面网关报文的vo
 *
 * @author Administrator
 *
 */
public class GateWayEnvolopeVo extends NoAs400EnvolopeVo implements
		Serializable {

	private Map messageEntity = new HashMap();// 报文体(不包括循环的字段)

	private List messageCirculateList = new ArrayList();// 循环体，里面放Map结构

	private List messageCirculateList2 = new ArrayList();// 循环体2，里面放Map结构

	private List messageCirculateList3 = new ArrayList();// 循环体2，里面放Map结构

	private List messageCirculateList4 = new ArrayList();// 循环体2，里面放Map结构

	private String receiverIdFlag = "";

	private String senderIdFlag = "";

	private String tradeCodeFlag = "";


	public String getReceiverIdFlag() {
		return receiverIdFlag;
	}

	public void setReceiverIdFlag(String receiverIdFlag) {
		this.receiverIdFlag = receiverIdFlag;
	}

	public String getSenderIdFlag() {
		return senderIdFlag;
	}

	public void setSenderIdFlag(String senderIdFlag) {
		this.senderIdFlag = senderIdFlag;
	}

	public String getTradeCodeFlag() {
		return tradeCodeFlag;
	}

	public void setTradeCodeFlag(String tradeCodeFlag) {
		this.tradeCodeFlag = tradeCodeFlag;
	}

	public List getMessageCirculateList() {
		return messageCirculateList;
	}

	public void setMessageCirculateList(List messageCirculateList) {
		this.messageCirculateList = messageCirculateList;
	}

	public Map getMessageEntity() {
		return messageEntity;
	}

	public void setMessageEntity(Map messageEntity) {
		this.messageEntity = messageEntity;
	}

	public List getMessageCirculateList2() {
		return messageCirculateList2;
	}

	public void setMessageCirculateList2(List messageCirculateList2) {
		this.messageCirculateList2 = messageCirculateList2;
	}

	public List getMessageCirculateList3() {
		return messageCirculateList3;
	}

	public void setMessageCirculateList3(List messageCirculateList3) {
		this.messageCirculateList3 = messageCirculateList3;
	}

	public List getMessageCirculateList4() {
		return messageCirculateList4;
	}

	public void setMessageCirculateList4(List messageCirculateList4) {
		this.messageCirculateList4 = messageCirculateList4;
	}

	/**
	 * 获取循环体长度
	 *
	 * @return
	 */
	public int getMessageCirculateListSize() {
		if (messageCirculateList != null) {
			return messageCirculateList.size();
		}
		return 0;
	}

	/**
	 * 获取循环体长度
	 *
	 * @return
	 */
	public int getMessageCirculateListSize2() {
		if (messageCirculateList2 != null) {
			return messageCirculateList2.size();
		}
		return 0;
	}

	/**
	 * ��ȡѭ���峤��
	 *
	 * @return
	 */
	public int getMessageCirculateListSize3() {
		if (messageCirculateList3 != null) {
			return messageCirculateList3.size();
		}
		return 0;
	}

	/**
	 * 获取循环体长度
	 *
	 * @return
	 */
	public int getMessageCirculateListSize4() {
		if (messageCirculateList4 != null) {
			return messageCirculateList4.size();
		}
		return 0;
	}

	/**
	 * 获取非循环体报文体属性值
	 *
	 * @param attribute
	 * @return
	 */
	public String getMessageEntityValue(String attribute) {
		if (messageEntity != null) {
			return (String) messageEntity.get(attribute);
		}
		return "";
	}

	/**
	 * 设置非循环体报文体属性值
	 *
	 * @param attribute
	 * @param value
	 * @return
	 */
	public void setMessageEntityValue(String attribute, String value) {
		if (messageEntity == null) {
			messageEntity = new HashMap();// 报文体(不包括循环的字段)
		}
		messageEntity.put(attribute, value);
	}

	/**
	 * 设置循环体
	 *
	 * @return
	 */
	public void addMessageCirculateMap(Map map) {
		messageCirculateList.add(map);
	}

	/**
	 * 设置循环体
	 *
	 * @return
	 */
	public void addMessageCirculateMap2(Map map) {
		messageCirculateList2.add(map);
	}

	/**
	 * 设置循环体
	 *
	 * @return
	 */
	public void addMessageCirculateMap3(Map map) {
		messageCirculateList3.add(map);
	}

	/**
	 * ����ѭ����
	 *
	 * @return
	 */
	public void addMessageCirculateMap4(Map map) {
		messageCirculateList4.add(map);
	}

	/**
	 * 获取循环体的属性
	 *
	 * @return
	 */
	public String getmessageCirculateValue(int i, String attribute) {
		if (messageCirculateList != null && messageCirculateList.size() > 0) {
			Map map = (HashMap) messageCirculateList.get(i);
			String value = null;
			Object valueObject = map.get(attribute);
			if (valueObject != null) {
				value = (String) map.get(attribute).toString();
			} else {
				//System.out.println("valueObject is null");
			}
			return value;
		}
		return null;
	}

	/**
	 * 获取循环体的属性
	 *
	 * @return
	 */
	public String getmessageCirculateValue2(int i, String attribute) {
		if (messageCirculateList2 != null && messageCirculateList2.size() > 0) {
			Map map = (HashMap) messageCirculateList2.get(i);
			String value = null;
			Object valueObject = map.get(attribute);
			if (valueObject != null) {
				value = (String) map.get(attribute).toString();
			} else {
				//System.out.println("valueObject is null");
			}
			return value;
		}
		return null;
	}

	/**
	 * 获取循环体的属性
	 *
	 * @return
	 */
	public String getmessageCirculateValue3(int i, String attribute) {
		if (messageCirculateList3 != null && messageCirculateList3.size() > 0) {
			Map map = (HashMap) messageCirculateList3.get(i);
			String value = null;
			Object valueObject = map.get(attribute);
			if (valueObject != null) {
				value = (String) map.get(attribute).toString();
			} else {
				//System.out.println("valueObject is null");
			}
			return value;
		}
		return null;
	}

	/**
	 * 获取循环体的属性
	 *
	 * @return
	 */
	public String getmessageCirculateValue4(int i, String attribute) {
		if (messageCirculateList4 != null && messageCirculateList4.size() > 0) {
			Map map = (HashMap) messageCirculateList4.get(i);
			String value = null;
			Object valueObject = map.get(attribute);
			if (valueObject != null) {
				value = (String) map.get(attribute).toString();
			} else {
				//System.out.println("valueObject is null");
			}
			return value;
		}
		return null;
	}

}

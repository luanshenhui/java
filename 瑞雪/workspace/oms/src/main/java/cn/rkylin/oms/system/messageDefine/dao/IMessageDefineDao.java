package cn.rkylin.oms.system.messageDefine.dao;

import java.util.List;

import cn.rkylin.oms.system.messageDefine.domain.OMS_MESSAGE;
import cn.rkylin.oms.system.messageDefine.domain.OMS_MESSAGE_SHOP;
import cn.rkylin.oms.system.messageDefine.vo.MessageDefineVo;

public interface IMessageDefineDao {

//	void saveMessage(OMS_MESSAGE message) throws Exception;

	void delete(String stationParam,String string)throws Exception;
	
	void doEnable(String msgEnable,String string)throws Exception;
	
	OMS_MESSAGE getMessageInfo(OMS_MESSAGE message) throws Exception;

	List<OMS_MESSAGE_SHOP> getMessageShopList(String[] arr) throws Exception;

	void insertMessageShop(OMS_MESSAGE_SHOP ms) throws Exception;

	List getMsgByCondition(MessageDefineVo messageDefineVoVO) throws Exception;
	
	public void insert(MessageDefineVo messageDefineVoVO) throws Exception;
	
	void deleteShopMes(String stationParam,String string)throws Exception;

	OMS_MESSAGE_SHOP getMessageShop(OMS_MESSAGE_SHOP messageShop) throws Exception;

	void updateFormFree(OMS_MESSAGE_SHOP messageShop) throws Exception;

	void updateMessage(MessageDefineVo msgVO) throws Exception;

}

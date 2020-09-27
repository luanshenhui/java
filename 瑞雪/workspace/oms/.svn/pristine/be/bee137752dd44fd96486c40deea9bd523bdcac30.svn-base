package cn.rkylin.oms.system.messageDefine.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.system.messageDefine.domain.OMS_MESSAGE;
import cn.rkylin.oms.system.messageDefine.domain.OMS_MESSAGE_SHOP;
import cn.rkylin.oms.system.messageDefine.vo.MessageDefineVo;

@Repository(value = "messageDefineDao")
public class MessageDefineDaoImpl implements IMessageDefineDao{
	
	@Autowired
	protected IDataBaseFactory dao;

//	@Override
//	public void saveMessage(OMS_MESSAGE message) throws Exception {
//		dao.insert("saveMessage_insert", message);
//		
//	}

	@Override
	public void delete(String stationParam, String string) throws Exception {
		dao.delete(stationParam, string);
	}
	@Override
	public void deleteShopMes(String stationParam, String string) throws Exception {
		dao.delete(stationParam, string);
	}
	@Override
	public void doEnable(String msgEnable,String string) throws Exception {
		if(msgEnable.equals("是")){
			dao.update("updateUnenable", string);
		}else{
			dao.update("updateEnable", string);
		}
	}

	@Override
	public OMS_MESSAGE getMessageInfo(OMS_MESSAGE message) throws Exception {
		List list = dao.findAllList("getMessageInfo", message);
		return (OMS_MESSAGE) (list.size() > 0 ? list.get(0) : null);
	}

	@Override
	public List<OMS_MESSAGE_SHOP> getMessageShopList(String[] arr) throws Exception {
		List list = dao.findAllList("getMessageShopList", arr);
		return null;
	}

	@Override
	public void insertMessageShop(OMS_MESSAGE_SHOP ms) throws Exception {
		dao.insert("insertMessageShop", ms);
	}

	@Override
	public List getMsgByCondition(MessageDefineVo messageDefineVoVO) throws Exception {
		// TODO Auto-generated method stub
		return dao.findAllList("getMessageList", messageDefineVoVO);
	}

	@Override
	public void insert(MessageDefineVo messageDefineVo) throws Exception {
		dao.insert("saveMessage_insert",messageDefineVo);
	}
	@Override
	public OMS_MESSAGE_SHOP getMessageShop(OMS_MESSAGE_SHOP messageShop) throws Exception {
		List list = dao.findAllList("getMessageShop", messageShop);
		return (OMS_MESSAGE_SHOP) (list.size() > 0 ? list.get(0) : null);
	}
	@Override
	public void updateFormFree(OMS_MESSAGE_SHOP messageShop) throws Exception {
		dao.update("updateMessageShop", messageShop);
		
	}
	@Override
	public void updateMessage(MessageDefineVo msgVO) throws Exception {
		dao.update("updateMessage", msgVO);
	}

}

package cn.com.cgbchina.batch.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.batch.model.BatchEspActRemindModel;
import cn.com.cgbchina.item.model.GoodsXidSeqModelModel;
import cn.com.cgbchina.promotion.model.EspActRemindModel;

@Repository
public class BatchEspActRemindDao extends SqlSessionDaoSupport {
	
	public long findNeedSendMsgCount(Date date){
		Map<String,Object> map=new HashMap<>();
		map.put("date", date);
		return getSqlSession().selectOne("BatchEspActRemindModel.findNeedSendMsgCount", map);
	}
	
	public List<BatchEspActRemindModel> findNeedSendMsg(Date date, long offset, long limit){
		Map<String,Object> map=new HashMap<>();
		map.put("date", date);
		map.put("offset", offset);
		map.put("limit", limit);
		return getSqlSession().selectList("BatchEspActRemindModel.findNeedSendMsg", map);
	}
	
	
	public int updateSendFlg(List<String> ids,String flg){
		Map<String,Object> map=new HashMap<>();
		map.put("ids", ids);
		map.put("flg", flg);
		return getSqlSession().update("BatchEspActRemindModel.updateSendFlg", map);
	}
}
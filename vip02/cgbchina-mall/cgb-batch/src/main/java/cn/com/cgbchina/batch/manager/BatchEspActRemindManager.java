package cn.com.cgbchina.batch.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import cn.com.cgbchina.batch.dao.BatchEspActRemindDao;

import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
public class BatchEspActRemindManager {
	@Autowired
	private BatchEspActRemindDao dao;
	@Transactional
	public int updateSendFlg(List<String> ids,String flg){
		return dao.updateSendFlg(ids,"1");
	}
}

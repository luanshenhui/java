package cn.com.cgbchina.related.manager;

import cn.com.cgbchina.related.dao.TblEspKeywordRecordDao;
import cn.com.cgbchina.related.model.TblEspKeywordRecordModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by 11141021040453 on 2016/6/6.
 */
@Component
@Transactional
public class TblEspKeywordRecordManager {

	@Resource
	TblEspKeywordRecordDao tblEspKeywordRecordDao;

	/**
	 * 新增关键词
	 * 
	 * @param tblEspKeywordRecordModel
	 * @return
	 */
	public Integer insert(TblEspKeywordRecordModel tblEspKeywordRecordModel) {
		return tblEspKeywordRecordDao.insert(tblEspKeywordRecordModel);
	}

}

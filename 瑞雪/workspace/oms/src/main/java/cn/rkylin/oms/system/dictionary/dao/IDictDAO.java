package cn.rkylin.oms.system.dictionary.dao;

import java.util.List;

import cn.rkylin.oms.system.dictionary.domain.OMS_DICT;
import cn.rkylin.oms.system.dictionary.vo.DictVO;

public interface IDictDAO {

//	List getDictByCondition(OMS_DICT unitParam, int page, int rows) throws Exception;

	void insert(String string, OMS_DICT ur) throws Exception;

	void delete(String stationParam,String string)throws Exception;
	
	void update(String stationParam,OMS_DICT ur)throws Exception;

	List getParamDictByCode(OMS_DICT dict) throws Exception;
	
	List getDictByCondition(DictVO dictVO) throws Exception;
	
	List getDictTypeList(OMS_DICT dict) throws Exception;
	
}

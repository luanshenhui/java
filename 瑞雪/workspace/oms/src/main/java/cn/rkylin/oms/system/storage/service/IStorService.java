package cn.rkylin.oms.system.storage.service;

import java.util.List;

import com.github.pagehelper.PageInfo;

import cn.rkylin.oms.system.storage.domain.OMS_STOR;
import cn.rkylin.oms.system.storage.vo.StorVO;

public interface IStorService {
	PageInfo<StorVO> findByWhere(int page, int length, StorVO param) throws Exception;

	public void delete(String storId) throws Exception;
	
	List getStorByCondition(StorVO storVO) throws Exception;
	
	public void insert(StorVO storVO) throws Exception;
	
	public OMS_STOR selectStorDetail(String storId) throws Exception;
	
	public void update(StorVO storVO) throws Exception;
}

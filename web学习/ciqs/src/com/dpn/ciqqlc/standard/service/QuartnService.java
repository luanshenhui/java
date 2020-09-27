package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.ProsasModel;
import com.dpn.ciqqlc.standard.model.QuartnModel;
import com.dpn.ciqqlc.standard.model.VideoEventModel;


/**
 * 隔离、就地诊验或留验service
 * @author erikWang
 *
 */
public interface QuartnService {
	
	/**
	 * 保存
	 * @param quartnModel 隔离、就地诊验或留验對象
	 * @return 1是成功 0是不成功
	 */
	int save(QuartnModel quartnModel );
		
	/**
	 * 通过证件号或者时间查询截留物品
	 * @param quartnModel QuartnModel对象
	 * @return 截留物列表信息 
	 * @throws Exception 
	 */
	List<QuartnModel> findListPack(QuartnModel quartnModel) throws Exception;
	
	/**
	 * 根据Prosas表id查询截留物信息
	 * @param id Prosas主键id
	 * @return Prosas表信息以及图片,录像信息等
	 */
	ProsasModel findById(String id);
	
	/**
	 * 根据cardNo和procType 查找
	 * @param map cardNo跟文档类型集合
	 * @return 图片文档列表
	 */
	List<VideoEventModel> findByFileEvent(Map<?, ?> map);
	
	/**
	 * 通过pid跟type查找记录表
	 * @param map 集合
	 * @return 单条QLC_CHECK_DOCS_RCD表的信息
	 */
	CheckDocsRcdModel  findByDoc(Map<?, ?> map);
	
	/**
	 * 大列表点详情
	 * @param id CheckDocsRcdModel主键Id
	 * @return CheckDocsRcdModel 对象
	 */
	CheckDocsRcdModel  findByDocId(String id);
		
}

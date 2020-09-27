package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.model.AnnounceInfo;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

/**
 * Created by 11141021040453 on 16-4-13.
 */
public interface AnnouncementService {

	/**
	 * 查找公告
	 * 
	 * @return
	 */
	public Response<Pager<AnnounceInfo>> find(@Param("pageNo") Integer pageNo);

	/**
	 * 添加公告
	 * 
	 * @param announceInfo
	 * @return
	 */
	public Response<Boolean> create(AnnounceInfo announceInfo);

}

package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.dto.EspAdvertiseDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.related.model.EspAdvertiseModel;

import java.util.List;
import java.util.Map;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-30.
 */
public interface EspAdvertiseService {
	/**
	 * 添加手机广告
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	public Response<Boolean> create(EspAdvertiseModel espAdvertiseModel,String partitionsKeyword,
                                    String backCategory1Id,String backCategory2Id,String backCategory3Id);

	/**
	 * 删除手机广告
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	public Response<Boolean> delete(EspAdvertiseModel espAdvertiseModel);

	/**
	 * 发布手机广告
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	public Response<Boolean> updateAdvetiseStatus(EspAdvertiseModel espAdvertiseModel);

	/**
	 * 更新启用状态
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	public Response<Boolean> updateIsStop(EspAdvertiseModel espAdvertiseModel);

	/**
	 * 更新手机广告
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	public Response<Boolean> update(String id, EspAdvertiseModel espAdvertiseModel,String partitionsKeyword,
                                    String backCategory1Id,String backCategory2Id,String backCategory3Id);

	/**
	 * 查询手机广告列表
	 *
	 * @param pageNo
	 * @param size
	 * @return
	 */
	public Response<Pager<EspAdvertiseDto>> findByPage(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("ordertypeId") String ordertypeId, @Param("advertisePos") String advertisePos,
			@Param("publishStatus") String publishStatus);
    /**
     * 顺序校验
     *
     * @param checkAdvertiseSeq
     * @return
     */
    public Response<Boolean> checkAdvertiseSeq(Long id, String checkAdvertiseSeq);

	/**
	 * 查询有效广告，外部接口调用
	 * @param paramMap 参数Map
	 * @return 广告列表
	 *
	 * geshuo 20160721
	 */
	public Response<List<EspAdvertiseModel>> findAvailableAds(Map<String,Object> paramMap);
}

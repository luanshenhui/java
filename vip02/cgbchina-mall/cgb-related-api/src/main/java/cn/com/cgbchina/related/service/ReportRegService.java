package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.dto.ReportManageDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * 
 *	日期		:	2016年7月14日<br>
 *	作者		:	Huangcy<br>
 *	项目		:	cgb-related-api<br>
 *	功能		:	报表文件记录表<br>
 */
public interface ReportRegService {
	/**
	 * 报表管理页面
	 * @param pageNo
	 * @param size
	 * @param vendorName
	 * @param reportCode
	 * @param reportNm
	 * @param reportDesc
	 * @param startDate
	 * @param endDate
	 * @param user
	 * @return tongxueying
	 */
	public Response<Pager<ReportManageDto>> reportManage(@Param("pageNo") Integer pageNo,
														 @Param("size") Integer size,
														 @Param("vendorName") String vendorName,//供应商名称
														 @Param("reportCode") String reportCode,//报表代码
														 @Param("reportNm") String reportNm,//报表名称
														 @Param("reportDesc") String reportDesc,//报表类型（日、周、月）
														 @Param("startDate") String startDate,//开始日期
														 @Param("endDate") String endDate,//结束日期
														 @Param("User") User user);
}

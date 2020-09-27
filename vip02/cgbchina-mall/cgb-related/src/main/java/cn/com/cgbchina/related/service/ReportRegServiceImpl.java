package cn.com.cgbchina.related.service;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.related.dao.ReportRegDao;
import cn.com.cgbchina.related.dto.ReportManageDto;
import cn.com.cgbchina.related.model.ReportModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * 日期		:	2016年7月14日<br>
 * 作者		:	Huangcy<br>
 * 项目		:	cgb-related<br>
 * 功能		:	<br>
 */
@Slf4j
@Service
public class ReportRegServiceImpl implements ReportRegService {
    @Resource
    private VendorService vendorService;
    @Resource
    private ReportRegDao reportRegDao;
    public static final String YYYY_MM_DD = "yyyy-MM-dd";
    public static final String DAY_REPORT = "日报表";
    public static final String WEEK_REPORT = "周报表";
    public static final String MONTH_REPORT = "月报表";
    public static final String[] VENDOR_EXCLUDE = {"YG06","YG10","YG14","YG02"};// 不进行供应商 查询 的报表


    /**
     * 报表管理页面
     *
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
    @Override
    public Response<Pager<ReportManageDto>> reportManage(@Param("pageNo") Integer pageNo,
                                                         @Param("size") Integer size,
                                                         @Param("vendorName") String vendorName,
                                                         @Param("reportCode") String reportCode,
                                                         @Param("reportNm") String reportNm,
                                                         @Param("reportDesc") String reportDesc,
                                                         @Param("startDate") String startDate,
                                                         @Param("endDate") String endDate,
                                                         @Param("User") User user) {
        Response<Pager<ReportManageDto>> response = Response.newResponse();
        checkArgument(StringUtils.isNotBlank(reportCode), "reportCode is null");
        List<String> reportCodeList = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(reportCode);
        PageInfo pageInfo = new PageInfo(pageNo, size);
        Map<String, Object> param = Maps.newHashMap();
        param.put("offset", pageInfo.getOffset());
        param.put("limit", pageInfo.getLimit());
        param.put("reportCode", reportCodeList);//报表代码
        if(Arrays.asList(VENDOR_EXCLUDE).contains(reportCodeList.get(0))){
            param.put("reportType",reportCodeList.get(0));// 认为--菜单的报表类别，用于过滤供应商的标识
        }
        List<String> vendorIdList;
        if (StringUtils.isNotBlank(vendorName)) {
            Response<List<String>> resultResponse = vendorService.findIdByName(vendorName);
            if(resultResponse.isSuccess()&& resultResponse != null){
                vendorIdList = resultResponse.getResult();//根据供应商简称模糊查询供应商Id
                param.put("vendorIdList", vendorIdList);//vendorIdList
            }

        } else if (StringUtils.isNotBlank(user.getVendorId())) {
            vendorIdList = Lists.newArrayList();
            vendorIdList.add(user.getVendorId());
            param.put("vendorIdList", vendorIdList);//供应商平台的
        }
        if (StringUtils.isNotBlank(reportNm)) {
            param.put("reportNm", reportNm);//报表名称
        }
        if (StringUtils.isNotBlank(startDate)) {
            Date startTime = DateHelper.string2Date(startDate, YYYY_MM_DD);//开始日期
            param.put("startDate", startTime);
        }
        if (StringUtils.isNotBlank(endDate)) {
            Date endTime = DateHelper.string2Date(endDate, YYYY_MM_DD);//结束日期
            param.put("endDate", endTime);
        }
        if (StringUtils.isNotBlank(reportDesc)) {
            if ("01".equals(reportDesc)) {
                reportDesc = DAY_REPORT;
            } else if ("02".equals(reportDesc)) {
                reportDesc = WEEK_REPORT;
            } else if ("03".equals(reportDesc)) {
                reportDesc = MONTH_REPORT;
            }
            param.put("reportDesc", reportDesc);//报表类型 日、周、月
        }
        try {
            Pager<ReportModel> pager = reportRegDao.findReportByPage(param);
            List<ReportManageDto> reportManageDtoList = Lists.newArrayList();
            if (pager.getTotal() > 0) {
                List<ReportModel> reportModels = pager.getData();
                ReportManageDto reportManageDto = null;
                for (ReportModel reportModel : reportModels) {
                    reportManageDto = new ReportManageDto();

                    int subStar;//截取的起始位置
                    if(-1 == reportModel.getReportPath().lastIndexOf("\\")){
                        subStar = reportModel.getReportPath().lastIndexOf("/") + 1;
                    }else{
                        subStar =  reportModel.getReportPath().lastIndexOf("\\") + 1;
                    }
                    String name = reportModel.getReportPath().substring(subStar, reportModel.getReportPath().length());

                    reportManageDto.setFileName(name);//截好的文件名
                    //根据vendorId查出相应的供应商简称
                    VendorInfoModel vendorInfoModel = vendorService.findVendorById(reportModel.getVendorId()).getResult();
                    if (vendorInfoModel != null && StringUtils.isNotEmpty(vendorInfoModel.getSimpleName())) {
                        reportManageDto.setSimpleName(vendorInfoModel.getSimpleName());
                    }
                    reportManageDto.setReportModel(reportModel);
                    reportManageDtoList.add(reportManageDto);
                }
                response.setResult(new Pager<ReportManageDto>(pager.getTotal(), reportManageDtoList));
            } else {
                response.setResult(new Pager<ReportManageDto>(0L, Collections.<ReportManageDto>emptyList()));
            }
        } catch (Exception e) {
            log.error("failed to query report record", Throwables.getStackTraceAsString(e));
            response.setError("query.error");
        }
        return response;
    }
}

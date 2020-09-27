package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.ApplyPaymentExportDao;
import cn.com.cgbchina.batch.dao.ConstantlyExportDao;
import cn.com.cgbchina.batch.model.ApplyPayModel;
import cn.com.cgbchina.batch.util.ConstantlyExported;
import cn.com.cgbchina.batch.util.ReportTaskUtil;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Created by zjq on 2016/12/26.
 */
@Service
@Slf4j
public class ApplyPaymentExportServiceImpl implements ApplyPaymentExportService{
    @Autowired
    private ExcelUtilAgency excelUtilAgency;
    @Autowired
    private ReportTaskUtil reportTaskUtil;
	@Autowired
	private ConstantlyExportDao constantlyExportDao;
	@Autowired
	private ApplyPaymentExportDao applyPaymentExportDao;
	@Value("${admin.applypaymentExportJF.outpath}")
	private String outpath;
	@Value("${admin.applypaymentExportJF.reportName}")
	private String reportName;
    @Value("${admin.applypaymentExportJF.tempPath}")
    private String templatePath;// 模板路径
	@Override
	public void applyPaymentExport(Map<String, Object> paramMap) {
		String userid =(String) paramMap.get("findUserId");
		String fileName = ExcelUtilAgency.encodingOutputFilePathOrder(outpath,reportName,userid, DateHelper.getCurrentTimess());
        String filePath;
        String redisKey;
		String systemType = (String)paramMap.get("systemType");
		String orderType = (String)paramMap.get("ordertypeId");
        log.info("runApplyPaymentExport.start",paramMap.toString());
        filePath = templatePath;
        redisKey = Contants.REDIS_KEY_APPLYPAYMENTEXPORT + systemType + orderType+ userid;
        Response<List<ApplyPayModel>> rs=exportRequest(paramMap);
        String fileNamePage = fileName + "_end.xlsx";
        String paths = null;
        if(rs.isSuccess()&&rs.getResult()!=null){
        	 try {
                 String outPath = excelUtilAgency.exportExcel(rs.getResult(),filePath,fileNamePage);
                 String path = reportTaskUtil.removeDiskPath(outPath);
                 if(paths == null ||paths.isEmpty()){
                     paths = "--"+path;
                 }else {
                     paths = paths + ","+ path;
                 }
				 constantlyExportDao.create(redisKey,paths,null);
                 log.info("runOrderExport.paths:"+paths + "redisKey:"+redisKey);
             } catch (Exception e) {
				 constantlyExportDao.create(redisKey,"98",null);
                 log.error("fail to export exportApplyPaymentUndelivered data, bad code{}", Throwables.getStackTraceAsString(e));
                 throw new ResponseException(500, e.getMessage());
             }	
        }
        
    }

	@Override
	public Boolean deleteApplyFileExcel(String userId) {
		try{
			String filepath = ExcelUtilAgency.encodingOutputFilePathOrder(outpath, reportName, userId, null);
			filepath = reportTaskUtil.addDiskPath(filepath);
			File f1 = new File(filepath);
			log.info("delete.orderExcel.filepaht:{}",filepath);
			ConstantlyExported constantlyExported = new ConstantlyExported();
			if (!constantlyExported.deleteDir(f1)){
				log.error("delete.orderExcel.filepaht.fail");
				return false;
			}
            return true;
        }catch (Exception e){
            log.error("delete.ApplyPaymentExcel.filepaht.fail:",e);
            return false;
        }
	}

    public Response<List<ApplyPayModel>> exportRequest(Map<String, Object> paramMap) {
		String roleFlag = (String)paramMap.get("roleFlag");
		Response<List<ApplyPayModel>> response = Response.newResponse();
		try {
			List<ApplyPayModel> applyPayModelList = null;
			// 获取历史子订单列表数据
			if (Contants.USEING_COMMON_STATUS_0.equals(roleFlag)) {
				applyPayModelList = applyPaymentExportDao.findAllForReq(paramMap);
			} else {
				applyPayModelList = applyPaymentExportDao.findAlReq(paramMap);
			}
			if(applyPayModelList == null || applyPayModelList.size()==0){
				response.setResult(Lists.<ApplyPayModel>newArrayList());
				return response;
			}
			List<ApplyPayModel> applyPayModels = Lists.newArrayList();
			// 遍历TblOrderHistoryModelList,构造返回值
			for (ApplyPayModel applyPayModel : applyPayModelList) {
				data_format(applyPayModel);
				applyPayModels.add(applyPayModel);
			}
			response.setResult(applyPayModelList);
			return response;
		} catch (Exception e) {
			log.error("OrderPartBackServiceImpl.exportRequest.error{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderPartBackServiceImpl.exportRequest.error");
			return response;
		}
	}
    
	//数据转换
	private void data_format(ApplyPayModel orderSubModel){
		String goodssendFlag = orderSubModel.getGoodssendFlag();
		String sinStatusNm = orderSubModel.getSinStatusNm(); // 未请款 导出时显示 add by zhoupeng
		String batchNo = orderSubModel.getBatchNo(); //批次号 add by zhoupeng
		// 发货标识
		if(Objects.equals("0",goodssendFlag)){
			orderSubModel.setGoodssendFlag("未发货");
		}else if(Objects.equals("1",goodssendFlag)){
			orderSubModel.setGoodssendFlag("已发货");
		}else if(Objects.equals("2",goodssendFlag)){
			orderSubModel.setGoodssendFlag("已签收");
		}
		// 请款状态名称
		if(Strings.isNullOrEmpty(sinStatusNm)) {
			orderSubModel.setSinStatusNm("未请款");
		}
		// 批次号
		if(Strings.isNullOrEmpty(batchNo)) {
			orderSubModel.setBatchNo("无");
		}
	}
}

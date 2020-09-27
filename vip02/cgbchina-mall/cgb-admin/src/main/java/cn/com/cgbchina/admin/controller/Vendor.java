/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.admin.service.EPinService;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.enums.ChannelType;
import cn.com.cgbchina.common.utils.ExcelUtil;
import cn.com.cgbchina.common.utils.ExportUtils;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.rest.visit.model.user.EEA1InfoResult;
import cn.com.cgbchina.user.dto.MailStagesDto;
import cn.com.cgbchina.user.dto.StageRateDto;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.dto.VendorRatioUploadDto;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import cn.com.cgbchina.user.service.VendorService;
import cn.com.cgbchina.web.utils.SafeHtmlValidator;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.exception.UserNotLoginException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.util.IOUtils;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.spirit.util.Arguments.isNull;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/04/15
 */
@Controller
@RequestMapping("/api/admin/cooperation")
@Slf4j
public class Vendor {
    private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

    @Autowired
    VendorService vendorService;

    @Autowired
    MessageSources messageSources;

    @Autowired
    GoodsService goodService;

    @Autowired
    private EPinService ePinService;
    private String rootFilePath;

    public Vendor() {
        this.rootFilePath = this.getClass().getResource("/upload").getPath();
    }

    /**
     * 根据渠道，查询供应商列表("YG")
     *
     * @return
     */
    @RequestMapping(value = "list", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<List<VendorInfoModel>> list(@RequestParam("channel") String channel) {
        User user = UserUtil.getUser();
        if(user == null) {
            log.error("user.not.login");
            throw  new ResponseException(500,messageSources.get("user.not.login"));
        }
        if(isNull(ChannelType.from(channel))) {
            log.error("channel is not exists,channel:{}",channel);
            throw new ResponseException(500,messageSources.get("channel.not.exist"));
        }
        Response<List<VendorInfoModel>> response = vendorService.findVendorByChannel(channel);
        if (response.isSuccess()) {
            return response;
        }
        throw new ResponseException(500,messageSources.get("channel.not.exist"));
    }

    /**
     * 根据渠道，查询供应商列表("YG")
     *
     * @return vendorInfoModels
     * add by zhoupeng
     */
    @RequestMapping(value = "findVendorsByNameLike", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<List<VendorInfoModel>> findVendorsByNameLike(@RequestParam("channel") String channel,
                                                                 @RequestParam("keyword") String keyword) {
        User user = UserUtil.getUser();
        if(user == null) {
            log.error("user.not.login");
            throw  new ResponseException(500,messageSources.get("user.not.login"));
        }
        if(isNull(ChannelType.from(channel))) {
            log.error("channel is not exists,channel:{}",channel);
            throw new ResponseException(500,messageSources.get("channel.not.exist"));
        }
        VendorInfoModel vendorInfoModel = new VendorInfoModel();
        if(!Strings.isNullOrEmpty(keyword)){
            vendorInfoModel.setSimpleName(keyword);
        }
        vendorInfoModel.setBusinessTypeId(channel);
        vendorInfoModel.setStatus(Contants.VENDOR_COMMON_STATUS_0102);//已启用

        Response<List<VendorInfoModel>> response = vendorService.findVendorsByModel(vendorInfoModel);
        if (response.isSuccess()) {
            return response;
        }
        throw new ResponseException(500,messageSources.get("channel.not.exist"));
    }

    /**
     * 根据供应商Id加载供应商信息
     *
     * @return
     */
    @RequestMapping(value = "/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<VendorInfoModel> findById(@PathVariable("id") String vendorId) {
        if (SafeHtmlValidator.checkScriptAndEvent(vendorId)) {
            throw new ResponseException(500,messageSources.get("param.illegal"));
        }
        Response<VendorInfoModel> vendorInfoModelResponse = vendorService.findVendorById(vendorId);
        if (vendorInfoModelResponse.isSuccess()) {
            return vendorInfoModelResponse;
        }



        throw new ResponseException(500,messageSources.get("vendor.time.query.error "));
    }

    /**
     * 商城合作商添加
     *
     * @param vendorInfoDto
     * @return
     */
    @RequestMapping(value = "/add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> create(VendorInfoDto vendorInfoDto, HttpServletRequest request,
                                    HttpServletResponse response) {
        // 从登录信息中获取用户id和用户名称并插入到model中
        User user = UserUtil.getUser();
        if (user == null) {
            throw new UserNotLoginException("user.not.login");
        }
        String createOper = user.getName();
        vendorInfoDto.setCreateOper(createOper);
        // 将分期费率的数据整合存入StageRateDto
        String json = vendorInfoDto.getStageRate();
        StageRateDto stageRateDto = jsonMapper.fromJson(json, StageRateDto.class);
        // 将邮购分期的数据整合存入MailStagesDto
        String jsonMailStages = vendorInfoDto.getMailStages();
        MailStagesDto mailStagesDto = jsonMapper.fromJson(jsonMailStages, MailStagesDto.class);
        if(stageRateDto != null){
            // 校验分期费率是否有重复
            List<TblVendorRatioModel> vendorRatioModelList= stageRateDto.getTblVendorRatioModelList();
            //分期数list
            List<Integer> periods = new ArrayList<>();
            for(TblVendorRatioModel tblVendorRatioModel : vendorRatioModelList){
                if(tblVendorRatioModel.getFixedamtFee() != null){
                    periods.add(tblVendorRatioModel.getPeriod());
                }
            }
            //对分期数list进行排序
            Collections.sort(periods);
            for(int i = 0;i < periods.size()-1; i++){
                if(periods.get(i) == periods.get(i+1)){
                    log.error("period.repeat.error");
                    throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("period.repeat.error"));
                }
            }
        }
        try {
            // dto转化为Json
            String diffinfoForUpdate = jsonMapper.toJson(vendorInfoDto);
            vendorInfoDto.setDiffinfoForUpdate(diffinfoForUpdate);
            // 对一次密码进行加密开始
            VendorModel vendorModel = vendorInfoDto.getVendorModel();
            String password = vendorInfoDto.getPasswordFirst();
            // 校验密码信息
            EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, password);
            request.getSession().removeAttribute("randomPwd");
            // 密码机不成功返回
            if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
                log.error("pwd.service.error");
                throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
            }
            vendorModel.setPwfirst(eEA1InfoResult.getPinBlock());
            vendorInfoDto.setVendorModel(vendorModel);
            // 对一次密码进行加密结束
            // 新增
            Response<Boolean> result = vendorService.create(vendorInfoDto, stageRateDto, mailStagesDto);
            if (!result.isSuccess()) {
                log.error("create.vendor.error，error:{}", result.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
            }

            return result;
        } catch (IllegalArgumentException e) {
            log.error("create.vendor.error，error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("create.vendor.error，error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.vendor.error"));
        }
    }

    /**
     * 商城合作商编辑
     *
     * @param vendorInfoDto
     * @return
     */
    @RequestMapping(value = "/edit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> update(VendorInfoDto vendorInfoDto, HttpServletRequest request,
                                    HttpServletResponse response) {
        User user = UserUtil.getUser();
        if (user == null) {
            throw new UserNotLoginException("user.not.login");
        }
        String createName = user.getName();
        // 分期费率和邮购分期删除的id的集合
        List stageRateIdList = jsonMapper.fromJson(vendorInfoDto.getStageRateIdList(), List.class);
        List mailStagesIdList = jsonMapper.fromJson(vendorInfoDto.getMailStagesIdList(), List.class);
        // 将分期费率的数据整合存入StageRateDto
        String json = vendorInfoDto.getStageRate();
        StageRateDto stageRateDto = jsonMapper.fromJson(json, StageRateDto.class);
        // 将邮购分期的数据整合存入MailStagesDto
        String jsonMailStages = vendorInfoDto.getMailStages();
        MailStagesDto mailStagesDto = jsonMapper.fromJson(jsonMailStages, MailStagesDto.class);
        if(stageRateDto != null){
            // 校验分期费率是否有重复
            List<TblVendorRatioModel> vendorRatioModelList= stageRateDto.getTblVendorRatioModelList();
            //分期数list
            List<Integer> periods = new ArrayList<>();
            for(TblVendorRatioModel tblVendorRatioModel : vendorRatioModelList){
                if(tblVendorRatioModel.getFixedamtFee() != null){
                    periods.add(tblVendorRatioModel.getPeriod());
                }
            }
            //对分期数list进行排序
            Collections.sort(periods);
            for(int i = 0;i < periods.size()-1; i++){
                if(periods.get(i) == periods.get(i+1)){
                    log.error("period.repeat.error");
                    throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("period.repeat.error"));
                }
            }
        }
        try {
            // dto转化为Json
            String diffinfoForUpdate = jsonMapper.toJson(vendorInfoDto);
            vendorInfoDto.setDiffinfoForUpdate(diffinfoForUpdate);
            // 如果一次密码不为空，对一次密码进行加密开始
            String password = vendorInfoDto.getPasswordFirst();
            if (StringUtils.notEmpty(password)) {
                VendorModel vendorModel = vendorInfoDto.getVendorModel();
                // 校验密码信息
                EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, password);
                request.getSession().removeAttribute("randomPwd");
                // 密码机不成功返回
                if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
                    log.error("pwd.service.error");
                    throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
                }
                vendorModel.setPwfirst(eEA1InfoResult.getPinBlock());
                vendorInfoDto.setVendorModel(vendorModel);
                // 对一次密码进行加密结束
            }
            // 更新
            Response<Boolean> result = vendorService.update(vendorInfoDto, stageRateDto, mailStagesDto, stageRateIdList,
                    mailStagesIdList, createName);
            if (!result.isSuccess()) {
                log.error("update.vendor.error，error:{}", result.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
            }
            return result;
        } catch (IllegalArgumentException e) {
            log.error("update.vendor.error，error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("update.vendor.error，error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("update.vendor.error"));
        }
    }

    /**
     * 商城合作商删除
     *
     * @param vendorId
     * @return
     */
    @RequestMapping(value = "/delete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> delete(String vendorId) {
        Response<Boolean> result = new Response<Boolean>();
        // 校验
        try {
            Response<VendorInfoDto> vendorR = vendorService.findById(vendorId);
            if(!vendorR.isSuccess() || vendorR.getResult()==null){
                throw new ResponseException(Contants.ERROR_CODE_500, "该供应商不存在或已删除");
            }
            String businessTypeId = vendorR.getResult().getBusinessTypeId();
            // 校验该供应商下有没有商品挂载 只要该供应商有商品挂载 那么不允许删除
            Response<Integer> goodsCountByVendorId = goodService.findGoodsCountByVendorId(vendorId,businessTypeId);
            if (goodsCountByVendorId.isSuccess()) {
                Integer goodCount = goodsCountByVendorId.getResult();
                if (goodCount > 0) {
                    throw new IllegalArgumentException("vendor.good.count.not.zero");
                }
            } else {
                throw new IllegalArgumentException(goodsCountByVendorId.getError());
            }

            // 删除
            Response<Boolean> deleteResult = vendorService.delete(vendorId);
            if (!deleteResult.isSuccess()) {
                log.error("delete.vendor.error，error:{}", result.getError());
                throw new IllegalArgumentException(result.getError());
            }
            // 删除供应商的同时下架产品

            Response<Boolean> updateResult = goodService.updateChannelByVendorId(vendorId,businessTypeId);
            if (!updateResult.isSuccess()) {
                log.error("update.channel.error，error:{}", result.getError());
                throw new IllegalArgumentException(result.getError());
            }
            // 删除供应商的同时删除子账户
            Response<Boolean> deleteByParentId = vendorService.deleteByParentId(vendorId);
            if (!deleteByParentId.isSuccess()) {
                log.error("delete.son.error，error:{}", result.getError());
                throw new IllegalArgumentException(result.getError());
            }

            if (deleteResult.getResult() == true && updateResult.getResult() == true && deleteByParentId.getResult()) {
                result.setResult(true);
            } else {
                result.setResult(false);
            }
            if (!result.isSuccess()) {
                log.error("delete.vendor.error，error:{}", result.getError());
                throw new IllegalArgumentException(result.getError());
            }
            return result;
        } catch (IllegalArgumentException e) {
            log.error("delete.vendor.error，error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("delete.vendor.error，error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("delete.vendor.error"));
        }
    }

	/**
	 * 商城合作商审核
	 *
	 * @param vendorId
	 * @param pwsecond
	 * @param refuseDesc
	 * @return
	 */
	@RequestMapping(value = "/audit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> vendorCheck(String vendorId, String pwsecond, String refuseDesc, String status,
			String vendorStatus, HttpServletRequest request, HttpServletResponse response) {
            String businessTypeId = "";
		try {
			// 校验
			// 对二次密码进行加密开始
			if (StringUtils.notEmpty(pwsecond)) {
				// 校验密码信息
				EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, pwsecond);
				request.getSession().removeAttribute("randomPwd");
				// 密码机不成功返回
				if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
					log.error("pwd.service.error");
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
				}
				pwsecond = eEA1InfoResult.getPinBlock();
				// 对一次密码进行加密结束
			} else {
				// 查询数据库中是否有二次密码
				// 逻辑：前台传过来的二次密码为空，数据库中的二次密码也为空，则抛出异常；否则正常执行
				Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(vendorId);
				if(!vendorInfoDtoResponse.isSuccess()){
					log.error("Response.error,error code: {}", vendorInfoDtoResponse.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(vendorInfoDtoResponse.getError()));
				}
				VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();
				VendorModel vendorModel = vendorInfoDto.getVendorModel();
				String twoPassword = vendorModel.getPwsecond();
                businessTypeId = vendorInfoDto.getBusinessTypeId();
				if (StringUtils.isEmpty(twoPassword)) {
					log.error("pwd.control.error");
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.control.error"));
				}
			}

			// 审核
			Response<Boolean> updateResult = new Response<Boolean>();
			Response<Boolean> updateByParentId = new Response<Boolean>();
			updateResult.setResult(false);
			updateByParentId.setResult(false);
			Response<Boolean> checkResult = vendorService.vendorCheck(vendorId, pwsecond, refuseDesc);
			// 当修改了供应商状态为未启用且审核成功时将该供应商的产品下架
			if (checkResult.isSuccess() && checkResult.getResult()) {
				if (Contants.VENDOR_COMMON_STATUS_0101.equals(status)) {
					updateResult = goodService.updateChannelByVendorId(vendorId,businessTypeId);
					if (!updateResult.isSuccess()) {
						log.error("check.vendorInfo.update.channel.error，error:{}", updateResult.getError());
						throw new ResponseException(Contants.ERROR_CODE_500,
								messageSources.get(updateResult.getError()));
					}
				}
				// 当修改了供应商用户状态为未启用且审核成功时将该供应商的子账户停用,同时将产品下架
				if (Contants.VENDOR_COMMON_STATUS_0101.equals(vendorStatus)) {
					updateByParentId = vendorService.updateByParentId(vendorId);
					if (!updateByParentId.isSuccess()) {
						log.error("check.vendor.update.son.error，error:{}", updateByParentId.getError());
						throw new ResponseException(Contants.ERROR_CODE_500,
								messageSources.get(updateByParentId.getError()));
					}
					updateResult = goodService.updateChannelByVendorId(vendorId,businessTypeId);
					if (!updateResult.isSuccess()) {
						log.error("check.vendor.update.channel.error，error:{}", updateResult.getError());
						throw new ResponseException(Contants.ERROR_CODE_500,
								messageSources.get(updateResult.getError()));
					}
				}
			}
			if (!checkResult.isSuccess()) {
				log.error("check.vendor.error，error:{}", checkResult.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(checkResult.getError()));
			}
			return checkResult;

        } catch (IllegalArgumentException e) {
            log.error("check.vendor.error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("check.vendor.error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("check.vendor.error"));
        }
    }

    /**
     * 商城合作商拒绝
     *
     * @param vendorId
     * @param refuseDesc
     * @return
     */
    @RequestMapping(value = "/audit-vendorRefuse", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> vendorRefuse(String vendorId, String refuseDesc) {
        try {
            // 校验

            // 拒绝
            Response<Boolean> result = vendorService.vendorRefuse(vendorId, refuseDesc);
            if (!result.isSuccess()) {
                log.error("refuse.vendor.error，error:{}", result.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
            }
            return result;
        } catch (IllegalArgumentException e) {
            log.error("refuse.vendor.error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("refuse.vendor.error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("refuse.vendor.error"));
        }
    }

    /**
     * 合作商新增校验
     *
     * @param vendorId
     * @param vendorCode
     * @return
     */
    @RequestMapping(value = "/add-check", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Integer> vendorCreateCheck(String vendorId, String vendorCode) {
        try {
            Response<Integer> result = vendorService.vendorCreateCheck(vendorId, vendorCode);
            return result;
        } catch (IllegalArgumentException e) {
            log.error("check.error，error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("check.error，error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("check.error"));
        }
    }

    /**
     * 供应商用户账号管理 启用未启用状态修改
     *
     * @param code
     * @param status
     * @return
     */
    @RequestMapping(value = "/account-changeStatus", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> changeStatus(String code, String status) {
        try {
            // 校验

            // 修改状态
            Response<Boolean> updateResult = vendorService.changeStatus(code, status);
            if (!updateResult.isSuccess()) {
                log.error("change.status.error，error:{}", updateResult.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(updateResult.getError()));
            }
            return updateResult;

        } catch (IllegalArgumentException e) {
            log.error("change.status.error，error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("change.status.error，error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("check.error"));
        }
    }

	/**
	 * 分期费率导入
	 * 
	 * @param files
	 * @return
	 */

	@RequestMapping(value = "/importExcel", method = RequestMethod.POST, produces = MediaType.TEXT_HTML_VALUE)
	@ResponseBody
	public String processUpload(MultipartFile files) {
		Map<String,Object> maps = Maps.newHashMap();
		FileInputStream fileInputStream = null;
		User user = UserUtil.getUser();
		String tempFilePath = "";
		FileOutputStream fileOutputStream = null;
		try (FileInputStream uploadFile = new FileInputStream(rootFilePath + "/template/ratio_model_kzx_YG.xlsx")) {
			Map<String, Object> dataBeans = Maps.newHashMap();
			List<VendorRatioUploadDto> details = Lists.newArrayList();
			dataBeans.put("vendorRatios", details);
			fileInputStream = new FileInputStream(rootFilePath + "/config/ratio_model_kzx_YG.xml");
			ExcelUtil.importExcelToData(dataBeans, files.getInputStream(), fileInputStream);
			//对上传文件的内容进行校验
			Boolean uploadFlag = validate(details);
			//进行数据导入
			if(!uploadFlag){
				maps.put("success", Boolean.FALSE);
				return JsonMapper.JSON_NON_EMPTY_MAPPER.toJson(maps);
			}
			Response<List<VendorRatioUploadDto>> response = vendorService.uploadVendorRatios(details, user);
			if (response.isSuccess()) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("vendorRatios", response.getResult());
				Workbook workbook = WorkbookFactory.create(uploadFile);
				ExportUtils.exportTemplate(workbook, map);
				String relativeFile = "/tempfile/ratio_model_kzx_YG" + UUID.randomUUID().toString() + ".xlsx";
				tempFilePath = rootFilePath + relativeFile;
				fileOutputStream = new FileOutputStream(tempFilePath);
				workbook.write(fileOutputStream);
				fileOutputStream.flush();
				maps.put("success", Boolean.TRUE);
				maps.put("fileName", relativeFile);
			}
		} catch (Exception e) {
			log.error("import.ratio_model_kzx_YG.xls.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("vendor.ratio.import.fail"));
		} finally {
			if (fileInputStream != null) {
				try {
					fileInputStream.close();
				} catch (IOException e) {
					log.error("fail to close fileInputStream locate in{} ", Throwables.getStackTraceAsString(e));
				}
			}
		}
		return JsonMapper.JSON_NON_EMPTY_MAPPER.toJson(maps);
	}

	/*
	 * 下载分期费率模板
	 *
	 * @return
	 */
	@RequestMapping(value = "/import-exportExcel", method = RequestMethod.GET, produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public void exportExcel(HttpServletResponse response) throws IOException {
		String fileName = "vendor_ratio_import_template.xls"; // 输出给前台显示的文件名
		String filePath = rootFilePath + "/template/ratio_model_kzx_YG.xlsx";// 文件的绝对路径
		Map<String, Object> context = Maps.newHashMap();
		context.put("vendorRatios", Collections.emptyList());
		try {
			ExportUtils.exportTemplate(response, fileName, filePath, context);
		} catch (Exception e) {
			log.error("fail to download excel", e);
			response.reset();
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("export.vendor.ratio.excel.error"));
		}

	}

	/**
	 * 下载分期费率导入结果临时文件
	 *
	 * @param relativePath
	 */
	@RequestMapping(value = "/import-downloadTempFile", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public void downloadTempFile(HttpServletResponse response, String relativePath, Boolean isDownLoad) {
		OutputStream outputStream = null;
		if (!isDownLoad) {
			// 没点击下载 那么删除临时文件 认为此次导出用户不想看了
			return;
		}
		try (FileInputStream fileInputStream = new FileInputStream(rootFilePath + relativePath)) {
			String temp = "vendor_ratio_export" + LocalDate.now().toString() + ".xlsx";
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition",
					"attachment;filename=" + new String(temp.getBytes("UTF-8"), "iso8859-1") + ";target=_blank");
			outputStream = response.getOutputStream();
			IOUtils.copy(fileInputStream, outputStream);
			outputStream.flush();

        } catch (Exception e) {
            log.error("fail to down load temp file goods", e);
            throw new ResponseException(500, messageSources.get("export.file.error"));
        } finally {
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException e) {
                    log.error("fail to close fileOutStream downloadTemp", e);
                }
            }

			File file = new File(rootFilePath + relativePath);
			boolean delete = file.delete();
			if (!delete) {
				log.error("fail to delete temp excel file on goods");
			}
		}
	}

	/**
	 * 对上传的文件进行校验
	 * @param vendorRatioUploadDtos
	 * @return
	 */
	private Boolean validate(List<VendorRatioUploadDto> vendorRatioUploadDtos){
		Boolean uploadFlag = true;
		List<String> vendorIdList = new ArrayList<>();
		//导入的供应商id的集合
		for(VendorRatioUploadDto vendorRatioUploadDto : vendorRatioUploadDtos){
			String vendorId = vendorRatioUploadDto.getVendorId();
			if(!vendorIdList.contains(vendorId)){
				vendorIdList.add(vendorRatioUploadDto.getVendorId());
			}
		}
		for(String vendorId : vendorIdList){
			List<VendorRatioUploadDto> equalVendorIdList = new ArrayList<>();
			//取出导入的同一供应商的分期
			for(VendorRatioUploadDto vendorRatioUploadDto : vendorRatioUploadDtos){
				if(vendorId.equals(vendorRatioUploadDto.getVendorId())){
					equalVendorIdList.add(vendorRatioUploadDto);
				}
			}
			for(VendorRatioUploadDto vendorRatioUploadDto : equalVendorIdList){
				Integer period = vendorRatioUploadDto.getPeriod();
				List<VendorRatioUploadDto> equalPeriodList = new ArrayList<>();
				for(VendorRatioUploadDto dto : equalVendorIdList){
					if(period.equals(dto.getPeriod())){
						equalPeriodList.add(dto);
					}
				}
				if(equalPeriodList.size() != 1){
					uploadFlag = false;
				}
			}
		}
		//uploadFlag为flase,说明校验不通过，直接返回
		if(!uploadFlag){
			return uploadFlag;
		}
	//当分期数为1时的特殊校验
		for(VendorRatioUploadDto vendorRatioUploadDto : vendorRatioUploadDtos){
			if(vendorRatioUploadDto.getPeriod() == 1){
				//分期费率为1期时手续费费率2及百分比和手续费费率3及百分比必须为null，2、3开机期数必须为0
				if(vendorRatioUploadDto.getFeeratio1() == null || vendorRatioUploadDto.getRatio1Precent() == null
						||vendorRatioUploadDto.getFeeratio2() != null || vendorRatioUploadDto.getRatio2Precent() != null
						|| vendorRatioUploadDto.getFeeratio3() != null || vendorRatioUploadDto.getRatio3Precent() != null
						||vendorRatioUploadDto.getFeeratio2Bill() != 0 || vendorRatioUploadDto.getFeeratio3Bill() != 0){
					uploadFlag = false;
				}
			}
			if(!uploadFlag){
				return uploadFlag;
			}
		}
	//数据校验
		//用于校验 手续费费率1(月费率)、费率1本金百分比、手续费费率2(月费率)、费率2本金百分比、手续费费率3(月费率)、费率3本金百分比
		String reg1 = "^([1-9]\\d{0,1}|0)(\\.\\d{1,5})?$";
		//用于校验 手续费费率2 开机期数、手续费费率3 开机期数、直接免除手续费期数FROM、直接免除手续费期数TO、手续费免除期数
		String reg2 = "^([1-9]\\d{0,1}|0)(\\.\\d{1,5})?$";
		//用于校验 固定金额手续费 首尾付本金
		String reg3 = "^\\d+(\\.\\d{0,2})?$";

		for(VendorRatioUploadDto vendorRatioUploadDto : vendorRatioUploadDtos){
			String fixedamtFee = vendorRatioUploadDto.getFixedamtFee()+"";
			String feeratio1 = vendorRatioUploadDto.getFeeratio1()+"";
			String ratio1Precent = vendorRatioUploadDto.getRatio1Precent()+"";
			String feeratio2 = vendorRatioUploadDto.getFeeratio2()+"";
			String ratio1Precen2 = vendorRatioUploadDto.getRatio2Precent()+"";
			String feeratio2Bill = vendorRatioUploadDto.getFeeratio2Bill()+"";
			String feeratio3 = vendorRatioUploadDto.getFeeratio3()+"";
			String ratio1Precen3 = vendorRatioUploadDto.getRatio3Precent()+"";
			String feeratio3Bill = vendorRatioUploadDto.getFeeratio3Bill()+"";
			String reducerateFrom = vendorRatioUploadDto.getReducerateFrom()+"";
			String reducerateTo = vendorRatioUploadDto.getReducerateTo()+"";
			String reducerate = vendorRatioUploadDto.getReducerate()+"";
			String htant = vendorRatioUploadDto.getHtant()+"";
			if(!match(reg3,fixedamtFee)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(!match(reg1,feeratio1)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(!match(reg1,ratio1Precent)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(vendorRatioUploadDto.getFeeratio2() != null && !match(reg1,feeratio2)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(vendorRatioUploadDto.getRatio2Precent()!= null && !match(reg1,ratio1Precen2)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(!match(reg2,feeratio2Bill)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(vendorRatioUploadDto.getFeeratio3()!= null && !match(reg1,feeratio3)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(vendorRatioUploadDto.getRatio3Precent()!= null && !match(reg1,ratio1Precen3)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(!match(reg2,feeratio3Bill)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(!match(reg2,reducerateFrom)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(!match(reg2,reducerateTo)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(!match(reg2,reducerate)){
				uploadFlag = false;
				return uploadFlag;
			}
			if(!match(reg3,fixedamtFee)){
				uploadFlag = false;
				return uploadFlag;
			}
			//开始期数小于总期数、截止期数小于总期数，开始期数小于截止期数、免除期数小于总期数
			Integer total = vendorRatioUploadDto.getPeriod();
			Integer from = vendorRatioUploadDto.getReducerateFrom();
			Integer to = vendorRatioUploadDto.getReducerateTo();
			Integer to_from = vendorRatioUploadDto.getReducerate();
			if(from > total || to > total || to < from || to_from > total){
				uploadFlag = false;
				return uploadFlag;
			}
			//当首尾付标志为N--1、 S--2、 W--3时，首尾付本金必须为0
			if("1".equals(vendorRatioUploadDto.getHtflag()) || "2".equals(vendorRatioUploadDto.getHtflag())
					|| "3".equals(vendorRatioUploadDto.getHtflag())){
				if(!"0".equals(htant)){
					uploadFlag = false;
					return uploadFlag;
				}
			}
		}
		return uploadFlag;
	}

	/**
	 * 正则匹配
	 *
	 * @param regex
	 * @param str
	 * @return
	 */
	private static boolean match(String regex, String str) {
		Pattern pattern = Pattern.compile(regex);
		Matcher matcher = pattern.matcher(str);
		return matcher.matches();
	}
}

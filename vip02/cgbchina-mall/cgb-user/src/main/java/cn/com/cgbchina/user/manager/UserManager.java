package cn.com.cgbchina.user.manager;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import javax.annotation.Resource;

import cn.com.cgbchina.user.dto.VendorRatioUploadDto;
import com.google.common.collect.Lists;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.spirit.util.BeanMapper;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dao.MailStagesDao;
import cn.com.cgbchina.user.dao.TblVendorRatioDao;
import cn.com.cgbchina.user.dao.VendorDao;
import cn.com.cgbchina.user.dao.VendorInfoDao;
import cn.com.cgbchina.user.dto.MailStagesDto;
import cn.com.cgbchina.user.dto.StageRateDto;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;

/**
 * Created by niufw on 16-3-18.
 */
@Transactional
@Component
@Slf4j
public class UserManager {
	@Resource
	private VendorInfoDao vendorInfoDao;

	@Resource
	private VendorDao vendorDao;

	@Resource
	private TblVendorRatioDao tblVendorRatioDao;

	@Resource
	private MailStagesDao mailStagesDao;

	/**
	 * 商城合作商添加
	 *
	 * @param vendorInfoDto
	 * @return
	 */
	public boolean create(VendorInfoDto vendorInfoDto, StageRateDto stageRateDto, MailStagesDto mailStagesDto) {
		VendorInfoModel vendorInfoModel = new VendorInfoModel();
		// 拆分dto成各个model
		VendorModel vendorModel = vendorInfoDto.getVendorModel();
		// 插入用户等级
		vendorModel.setLevel("0");
		// 新建的是主帐号
		vendorModel.setIsSub("0");
		// 新建时给二次密码赋值为空串（否则前台不好判断）
		vendorModel.setPwsecond("");
		BeanMapper.copy(vendorInfoDto, vendorInfoModel);

		// 将model数据插入到对应的表中
		boolean vendorInfoResult = vendorInfoDao.insert(vendorInfoModel) == 1;
		boolean vendorUserResult = vendorDao.insert(vendorModel) == 1;


		// 分期费率插入
		boolean stageRateResult = true;
		if(stageRateDto != null){
			List<TblVendorRatioModel> tblVendorRatioModelList = stageRateDto.getTblVendorRatioModelList();
			for (TblVendorRatioModel tblVendorRatioModel : tblVendorRatioModelList) {
				//首尾付本金如果为空，则赋值0
				if(tblVendorRatioModel.getHtant() == null){
					BigDecimal htant = new BigDecimal(0);
					tblVendorRatioModel.setHtant(htant);
				}

				if (tblVendorRatioModel.getFixedamtFee() != null) {
					boolean result = tblVendorRatioDao.insert(tblVendorRatioModel) == 1;
					stageRateResult = stageRateResult && result;
				}
			}
		}

		// 邮购分期插入
		boolean mailStagesResult = true;
		if(mailStagesDto != null){
			List<MailStagesModel> mailStagesModelList = mailStagesDto.getMailStagesModelList();
			for (MailStagesModel mailStagesModel : mailStagesModelList) {
				if (StringUtils.isNotEmpty(mailStagesModel.getCode())) {
					boolean result = mailStagesDao.insert(mailStagesModel) == 1;
					mailStagesResult = mailStagesResult && result;
				}
			}
		}

		return vendorInfoResult && vendorUserResult && stageRateResult && mailStagesResult;
	}

	/**
	 * 商城合作商编辑
	 *
	 * @param vendorInfoDto
	 * @return
	 */
	public boolean update(VendorInfoDto vendorInfoDto, StageRateDto stageRateDto, MailStagesDto mailStagesDto,
			List stageRateIdList, List mailStagesIdList) {
		VendorInfoModel vendorInfoModel = new VendorInfoModel();
		// 拆分dto成各个model
		VendorModel vendorModel = vendorInfoDto.getVendorModel();
		// 当一次密码为空字符串时给一次密码复制mull,否则更新会覆盖数据库数据
		if (StringUtils.isEmpty(vendorModel.getPwfirst())) {
			vendorModel.setPwfirst(null);
		} else {
			// 当一次密码不为空时，清空二次密码
			vendorModel.setPwsecond("");
		}
		BeanMapper.copy(vendorInfoDto, vendorInfoModel);
		// 将model数据插入到对应的表中
		boolean vendorInfoResult = vendorInfoDao.update(vendorInfoModel) == 1;
		boolean vendorUserResult = vendorDao.update(vendorModel) == 1;
		boolean stageRateResult = true;
		if(stageRateDto != null){
			List<TblVendorRatioModel> tblVendorRatioModelList = stageRateDto.getTblVendorRatioModelList();
			for (TblVendorRatioModel tblVendorRatioModel : tblVendorRatioModelList) {
				//首尾付本金如果为空，则赋值0
				if(tblVendorRatioModel.getHtant() == null){
					BigDecimal htant = new BigDecimal(0);
					tblVendorRatioModel.setHtant(htant);
				}
				// id不为空则为编辑，id为空而固定金额手续费不为空，则为新增
				if (tblVendorRatioModel.getId() != null) {
					boolean result = tblVendorRatioDao.update(tblVendorRatioModel) == 1;
					stageRateResult = stageRateResult && result;
				} else if (tblVendorRatioModel.getFixedamtFee() != null) {
					boolean result = tblVendorRatioDao.insert(tblVendorRatioModel) == 1;
					stageRateResult = stageRateResult && result;
				}
			}
		}


		// 根据id逻辑删除分期费率
		boolean stageRateDelete = true;
		if(stageRateIdList != null){
			for (int i = 0; i < stageRateIdList.size(); i++) {
				Long id = Long.parseLong(stageRateIdList.get(i).toString());
				boolean result = tblVendorRatioDao.updateForDelete(id) == 1;
				stageRateDelete = stageRateDelete && result;
			}
		}


		boolean mailStagesResult = true;
		if(mailStagesDto != null){
			List<MailStagesModel> mailStagesModelList = mailStagesDto.getMailStagesModelList();
			for (MailStagesModel mailStagesModel : mailStagesModelList) {
				// id不为空则为编辑，id为空而邮购分期类别码不为空，则为新增
				if (mailStagesModel.getId() != null) {
					boolean result = mailStagesDao.update(mailStagesModel) == 1;
					mailStagesResult = mailStagesResult && result;
				} else if (StringUtils.isNotEmpty(mailStagesModel.getCode())) {
					boolean result = mailStagesDao.insert(mailStagesModel) == 1;
					mailStagesResult = mailStagesResult && result;
				}
			}
		}

		// 根据id逻辑删除分期邮购
		boolean mailStagesDelete = true;
		if(mailStagesIdList != null){
			for (int i = 0; i < mailStagesIdList.size(); i++) {
				Long id = Long.parseLong(mailStagesIdList.get(i).toString());
				boolean result = mailStagesDao.updateForDelete(id) == 1;
				mailStagesDelete = stageRateDelete && result;
			}
		}
		return vendorInfoResult && vendorUserResult && stageRateResult && mailStagesResult && stageRateDelete && mailStagesDelete;
	}

	/**
	 * 商城合作商删除
	 *
	 * @param vendorId
	 * @return
	 */
	public boolean delete(String vendorId) {
		boolean vendorInfoResult = vendorInfoDao.update(vendorId) == 1;
		boolean vendorUserResult = vendorDao.update(vendorId) == 1;

		return vendorInfoResult && vendorUserResult;
	}

	/**
	 * 商城合作商审核
	 *
	 * @param vendorId
	 * @return
	 */
	public boolean vendorCheck(String vendorId, String pwsecond, String refuseDesc) {
		VendorModel vendorModel = vendorDao.findByVendorId(vendorId);
		VendorInfoModel vendorInfoModel = vendorInfoDao.findByVendorId(vendorId);
		// 将两个密码拼接并采用update的方式插入表vendor中
		if (StringUtils.isNotEmpty(pwsecond)) {
			vendorModel.setPwsecond(pwsecond);
			vendorModel.setIsFirst("0");
		}
		// 将审核意见插入model
		vendorModel.setRefuseDesc(refuseDesc);
		// 清空diffinfoForUpdate(在未审核状态下，不能把信息更新到DB下，所以将修改信息暂时保存)
		vendorInfoModel.setDiffinfoForUpdate("");
		String checkStatus = vendorModel.getCheckStatus();
		// 修改状态 vendor_info中的status和vendor中的status 未启用修改为启用
		if (Contants.VENDOR_APPROVE_STATUS_0.equals(checkStatus)) {
			vendorInfoModel.setStatus(Contants.VENDOR_COMMON_STATUS_0102);
			vendorModel.setStatus(Contants.VENDOR_COMMON_STATUS_0102);
		}
		// 更新插入密码password和审核意见refuseDesc
		boolean vendorUserResults = vendorDao.update(vendorModel) == 1;
		// 审核状态修改
		boolean vendorUserResult = vendorDao.vendorCheck(vendorId) == 1;
		// 更新vendor_info表中的status
		boolean vendorInfoResults = vendorInfoDao.update(vendorInfoModel) == 1;
		return vendorUserResult && vendorUserResults && vendorInfoResults;
	}

	/**
	 * 商城合作商拒绝
	 *
	 * @param vendorId
	 * @param refuseDesc
	 * @return
	 */
	public boolean vendorRefuse(String vendorId, String refuseDesc) {
		VendorModel vendorModel = vendorDao.findByVendorId(vendorId);
		// 将审核意见插入model
		vendorModel.setRefuseDesc(refuseDesc);
		// 修改审核状态 如果是新增就拒绝（以前没有审核，数据库中审核状态是0-待审核（新增）），审核状态修改为 3-已拒绝（新增）
		// 如果是编辑拒绝（以前已经审核通过，数据库中审核状态是2-待审核（编辑）），审核状态修改为 4-已拒绝（编辑）
		String checkStatus = vendorModel.getCheckStatus();
		if (Contants.VENDOR_APPROVE_STATUS_0.equals(checkStatus)) {
			vendorModel.setCheckStatus(Contants.VENDOR_APPROVE_STATUS_3);
		} else if (Contants.VENDOR_APPROVE_STATUS_2.equals(checkStatus)) {
			vendorModel.setCheckStatus(Contants.VENDOR_APPROVE_STATUS_4);
		}
		// 更新插入审核意见refuseDesc和审核状态CheckStatus
		boolean vendorUserResults = vendorDao.update(vendorModel) == 1;
		return vendorUserResults;
	}

	/**
	 * 根据供应商ID停用该供应商下所有子帐号
	 *
	 * @param vendorId
	 * @return
	 */
	public Integer updateByParentId(String vendorId) {
		return vendorDao.updateByParentId(vendorId);
	}

	/**
	 * 根据供应商Id删除子帐号
	 *
	 * @param vendorId
	 * @return
	 */
	public Integer deleteByParentId(String vendorId) {
		return vendorDao.deleteByParentId(vendorId);
	}

	/**
	 * 供应商用户账号管理 启用未启用状态修改
	 *
	 * @param vendorModel
	 * @return
	 */
	public Boolean changeStatus(VendorModel vendorModel) {
		boolean result = vendorDao.changeStatus(vendorModel) == 1;
		return result;
	}

	/**
	 * 分期费率导入
	 *
	 * @param vendorRatioUploadDtos
	 * @param createOper
	 * @return
	 */
	public List<VendorRatioUploadDto> uploadVendorRatios(List<VendorRatioUploadDto> vendorRatioUploadDtos, String createOper){
		List<VendorRatioUploadDto> resultList = Lists.newArrayList();//返回结果
		List<String> vendorIdList = new ArrayList<>();//导入的供应商id的集合
		List<String> failVendorIdList = new ArrayList<>();
		//导入分期费率的供应商的id集合
		for (VendorRatioUploadDto dto : vendorRatioUploadDtos) {
			String vendorId = dto.getVendorId();
			if(!vendorIdList.contains(vendorId)){
				vendorIdList.add(vendorId);
			}
		}
		for(String vendorId : vendorIdList){
			//判断供应商是否存在，如果不存在，存入failVendorIdList
			VendorInfoModel vendorInfoModel = vendorInfoDao.findByVendorId(vendorId);
			if(vendorInfoModel == null){
				failVendorIdList.add(vendorId);
			}else{
				//如果供应商存在，查询可以导入分期费率的供应商是否有分期费率。如果有，删除数据库数据
				List<TblVendorRatioModel> tblVendorRatioModelList  = tblVendorRatioDao.findStageByVendorId(vendorId);
				if(tblVendorRatioModelList.size() != 0){
					tblVendorRatioDao.deleteByVendorId(vendorId);
				}
			}
		}
		//如果供应商id在失败list里，则返回导入失败，失败原因是该供应商不存在
		for (VendorRatioUploadDto dto : vendorRatioUploadDtos) {
			String vendorId = dto.getVendorId();
			if(failVendorIdList.contains(vendorId)){
				dto.setUploadFlag("导入失败");
				dto.setUploadFailedReason("供应商不存在");
				resultList.add(dto);
			}else{
				try{
					TblVendorRatioModel temp = new TblVendorRatioModel();
					temp.setVendorId(dto.getVendorId());//供应商代码
					temp.setPeriod(dto.getPeriod());//期数
					temp.setFixedfeehtFlag(dto.getFixedfeehtFlag());//手续费首位付标志
					temp.setFixedamtFee(dto.getFixedamtFee());//固定金额手续费
					temp.setFeeratio1(dto.getFeeratio1());//手续费费率1(月费率)
					temp.setRatio1Precent(dto.getRatio1Precent());//费率1本金百分比
					temp.setFeeratio2(dto.getFeeratio2());//手续费费率2(月费率)
					temp.setRatio2Precent(dto.getRatio2Precent());//费率2本金百分比
					temp.setFeeratio2Bill(dto.getFeeratio2Bill());//手续费费率2 开机期数
					temp.setFeeratio3(dto.getFeeratio3());//手续费费率3(月费率)
					temp.setRatio3Precent(dto.getRatio3Precent());//费率3本金百分比
					temp.setFeeratio3Bill(dto.getFeeratio3Bill());//手续费费率3 开机期数
					temp.setReducerateFrom(dto.getReducerateFrom());//直接免除手续费期数FROM
					temp.setReducerateTo(dto.getReducerateTo());//直接免除手续费期数To
					temp.setReducerate(dto.getReducerate());//手续费免除期数
					temp.setHtflag(dto.getHtflag());//首尾付标志
					temp.setHtant(dto.getHtant());//首尾付本金
					temp.setCreateOper(createOper);//创建人id
					//插入
					Integer count = tblVendorRatioDao.insert(temp);
					if(count == 0){
						dto.setUploadFlag("导入失败");
						dto.setUploadFailedReason("数据异常，导入失败");
						resultList.add(dto);
					}else{
						dto.setUploadFlag("导入成功");
						resultList.add(dto);
					}
				}catch (RuntimeException e){
					dto.setUploadFlag("导入失败");
					dto.setUploadFailedReason("数据异常，导入失败");
					resultList.add(dto);
					continue;
				}
			}
		}
		return resultList;
	}
}

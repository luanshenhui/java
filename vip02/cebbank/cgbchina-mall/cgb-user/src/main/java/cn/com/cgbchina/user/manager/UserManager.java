package cn.com.cgbchina.user.manager;

import java.util.List;

import javax.annotation.Resource;

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
		List<TblVendorRatioModel> tblVendorRatioModelList = stageRateDto.getTblVendorRatioModelList();
		List<MailStagesModel> mailStagesModelList = mailStagesDto.getMailStagesModelList();
		// 将model数据插入到对应的表中
		boolean vendorInfoResult = vendorInfoDao.insert(vendorInfoModel) == 1;
		boolean vendorUserResult = vendorDao.insert(vendorModel) == 1;


		// 分期费率插入
		boolean stageRateResult = true;
		for (TblVendorRatioModel tblVendorRatioModel : tblVendorRatioModelList) {
			if (tblVendorRatioModel.getFixedamtFee() != null) {
				boolean result = tblVendorRatioDao.insert(tblVendorRatioModel) == 1;
				stageRateResult = stageRateResult && result;
			}
		}
		// 邮购分期插入
		boolean mailStagesResult = true;
		for (MailStagesModel mailStagesModel : mailStagesModelList) {
			if (StringUtils.isNotEmpty(mailStagesModel.getCode())) {
				boolean result = mailStagesDao.insert(mailStagesModel) == 1;
				mailStagesResult = mailStagesResult && result;
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
		String pwfirst = vendorModel.getPwfirst();
		if (StringUtils.isEmpty(vendorModel.getPwfirst())) {
			vendorModel.setPwfirst(null);
		} else {
			// 当一次密码不为空时，清空二次密码
			vendorModel.setPwsecond("");
		}
		List<TblVendorRatioModel> tblVendorRatioModelList = stageRateDto.getTblVendorRatioModelList();
		List<MailStagesModel> mailStagesModelList = mailStagesDto.getMailStagesModelList();
		BeanMapper.copy(vendorInfoDto, vendorInfoModel);
		// 将model数据插入到对应的表中
		boolean vendorInfoResult = vendorInfoDao.update(vendorInfoModel) == 1;
		boolean vendorUserResult = vendorDao.update(vendorModel) == 1;
		boolean stageRateResult = true;
		for (TblVendorRatioModel tblVendorRatioModel : tblVendorRatioModelList) {
			// id不为空则为编辑，id为空而固定金额手续费不为空，则为新增
			if (tblVendorRatioModel.getId() != null) {
				boolean result = tblVendorRatioDao.update(tblVendorRatioModel) == 1;
				stageRateResult = stageRateResult && result;
			} else if (tblVendorRatioModel.getFixedamtFee() != null) {
				boolean result = tblVendorRatioDao.insert(tblVendorRatioModel) == 1;
				stageRateResult = stageRateResult && result;
			}
		}

		// 根据id逻辑删除分期费率
		boolean stageRateDelete = true;
		for (int i = 0; i < stageRateIdList.size(); i++) {
			Long id = Long.parseLong(stageRateIdList.get(i).toString());
			boolean result = tblVendorRatioDao.updateForDelete(id) == 1;
			stageRateDelete = stageRateDelete && result;
		}

		boolean mailStagesResult = true;
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

		// 根据id逻辑删除分期邮购
		boolean mailStagesDelete = true;
		for (int i = 0; i < mailStagesIdList.size(); i++) {
			Long id = Long.parseLong(mailStagesIdList.get(i).toString());
			boolean result = mailStagesDao.updateForDelete(id) == 1;
			mailStagesDelete = stageRateDelete && result;
		}

		return vendorInfoResult && vendorUserResult && mailStagesResult && stageRateDelete && mailStagesDelete;
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
}

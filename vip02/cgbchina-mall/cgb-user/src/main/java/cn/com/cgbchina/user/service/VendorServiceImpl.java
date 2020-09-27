package cn.com.cgbchina.user.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.enums.ChannelType;
import cn.com.cgbchina.user.dao.*;
import cn.com.cgbchina.user.dto.CooperationDto;
import cn.com.cgbchina.user.dto.MailStagesDto;
import cn.com.cgbchina.user.dto.StageRateDto;
import cn.com.cgbchina.user.dto.VendorDto;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.dto.VendorInfoIdDto;
import cn.com.cgbchina.user.dto.VendorRatioUploadDto;
import cn.com.cgbchina.user.manager.UserManager;
import cn.com.cgbchina.user.model.*;
import com.google.common.base.Optional;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static com.spirit.util.Arguments.isNull;

/**
 * Created by niufw on 16-2-26.
 */
@Service
@Slf4j
public class VendorServiceImpl implements VendorService {
    @Resource
    private VendorInfoDao vendorInfoDao;
    @Resource
    private VendorDao vendorDao;
    @Resource
    private MailStagesDao mailStagesDao;
    @Resource
    private VendorRoleDao vendorRoleDao;
    @Resource
    private VendorRoleRefDao vendorRoleRefDao;
    @Resource
    private UserManager userManager;
    @Resource
    private TblVendorRatioDao tblVendorRatioDao;
    @Resource
    private ShopinfOutsystemDao shopinfOutsystemDao;

    ////////////////////////////////////////////////////////////////////////////////////// 本地缓存start add by
    ////////////////////////////////////////////////////////////////////////////////////// zhangshiqiang
    // 定义本地缓存（供应商信息表）
    private final LoadingCache<String, Optional<VendorInfoModel>> verdorInfoCache;
    // 定义本地缓存（供应商用户表）
    private final LoadingCache<String, Optional<VendorModel>> vendorCache;
    // 定义本地缓存（供应商信息表）
    private final LoadingCache<String, Optional<List<VendorInfoModel>>> verdorInfoAllCache;
    public VendorServiceImpl() {
        // 生成本地缓存（供应商信息表）
        verdorInfoCache = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
                .build(new CacheLoader<String, Optional<VendorInfoModel>>() {
                    @Override
                    public Optional<VendorInfoModel> load(String vendorId) throws Exception {
                        return Optional.fromNullable(vendorInfoDao.findByVendorId(vendorId));
                    }
                });
        // 生成本地缓存（供应商用户表）
        vendorCache = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
                .build(new CacheLoader<String, Optional<VendorModel>>() {
                    @Override
                    public Optional<VendorModel> load(String vendorId) throws Exception {
                        return Optional.fromNullable(vendorDao.findByVendorId(vendorId));
                    }
                });
        // 生成本地缓存（供应商用户表）
        verdorInfoAllCache = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
                .build(new CacheLoader<String, Optional<List<VendorInfoModel>>>() {
                    @Override
                    public Optional<List<VendorInfoModel>> load(String channel) throws Exception {
                        VendorInfoModel vendorInfoModel = new VendorInfoModel();
                        vendorInfoModel.setBusinessTypeId(channel);
                        vendorInfoModel.setStatus(Contants.VENDOR_COMMON_STATUS_0102);
                        return Optional.fromNullable(vendorInfoDao.findAll(vendorInfoModel));
                    }
                });
    }




    /**
     * 从本地缓存获取供应商信息
     *
     * @param vendorId
     * @return
     */
    private VendorInfoModel findVendorInfoByIdCache(String vendorId) {
        // 取供应商本地缓存信息
        Optional<VendorInfoModel> vendorInfoModelCache = verdorInfoCache.getUnchecked(vendorId);

        // 缓存信息不空的情况下，赋值给model
        if (vendorInfoModelCache.isPresent()) {
            return vendorInfoModelCache.get();
        }
        return new VendorInfoModel();
    }

    /**
     * 从本地缓存获取供应商用户信息
     *
     * @param vendorId
     * @return
     */
    private VendorModel findVendorByIdCache(String vendorId) {
        // 取供应商本地缓存信息
        Optional<VendorModel> vendorModelCache = vendorCache.getUnchecked(vendorId);

        // 缓存信息不空的情况下，赋值给model
        if (vendorModelCache.isPresent()) {
            return vendorModelCache.get();
        }
        return new VendorModel();
    }

    ////////////////////////////////////////////////////////////////////////////////////// 本地缓存end

    /**
     * 根据条件查询供应商(分页查询)
     *
     * @param pageNo
     * @param size
     * @param vendorId
     * @param simpleName
     * @param type       //和审核状态有关 1-所有状态 2- 待审核（新增）：0 待审核（编辑）：2
     * @return
     */

    @Override
    public Response<Pager<VendorInfoDto>> find(Integer pageNo, Integer size, String vendorId, String simpleName,
                                               String type, String shopType) {
        Response<Pager<VendorInfoDto>> response = new Response<Pager<VendorInfoDto>>();
        Map<String, Object> paramMap = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        // 去除前后空格
        if (StringUtils.isNotEmpty(vendorId)) {
            vendorId = vendorId.trim(); // 去除前后空格
        }
        if (StringUtils.isNotEmpty(simpleName)) {
            simpleName = simpleName.trim(); // 去除前后空格
        }
        if (StringUtils.isNotEmpty(vendorId)) {
            // 将查询条件放入到paramMap
            paramMap.put("vendorId", vendorId);// 供应商代码
        }
        if (StringUtils.isNotEmpty(simpleName)) {
            paramMap.put("simpleName", simpleName);// 供应商简称
        }
        if (StringUtils.isNotEmpty(type)) {
            paramMap.put("type", type);// 根据type区分查询所有供应商，还是查询待审核供应商
        }
        if (StringUtils.isNotEmpty(type)) {
            paramMap.put("shopType", shopType);// 商城类型
        }
        paramMap.put("isSub", '0');//只查询主帐号的信息
        try {
            Pager<VendorModel> pager = vendorDao.findByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
            if (pager.getTotal() > 0) {
                List<VendorModel> vendorModels = pager.getData();
                List<VendorInfoDto> vendorInfoDtos = Lists.newArrayList();
                VendorInfoDto vendorInfoDto = null;
                // vendor_info和vendor_user表关联
                for (VendorModel vendorModel : vendorModels) {
                    vendorInfoDto = new VendorInfoDto();
                    String id = vendorModel.getVendorId();
                    // 根据endorId在vendorInfo表中查询数据
                    VendorInfoModel vendorInfoModel = findVendorInfoByIdCache(id);
                    // 将model的数据复制（或者set）到dto里
                    BeanMapper.copy(vendorInfoModel, vendorInfoDto);
                    vendorInfoDto.setVendorModel(vendorModel);
                    // 将单条的数据放入到list中
                    vendorInfoDtos.add(vendorInfoDto);
                }
                response.setResult(new Pager<VendorInfoDto>(pager.getTotal(), vendorInfoDtos));
                return response;
            } else {
                response.setResult(new Pager<VendorInfoDto>(0L, Collections.<VendorInfoDto>emptyList()));
                return response;
            }
        } catch (Exception e) {
            log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.time.query.error");
            return response;
        }
    }

    /**
     * 内管供应商编辑页面组件(专用)
     *
     * @param vendorId
     * @return
     */
    @Override
    public Response<CooperationDto> findForEditById(@Param("vendorId") String vendorId) {
        Response<CooperationDto> response = new Response<CooperationDto>();
        CooperationDto cooperationDto = new CooperationDto();
        VendorInfoModel vendorInfoModel = new VendorInfoModel();
        VendorModel vendorModel = new VendorModel();
        VendorInfoDto vendorInfoDto = new VendorInfoDto();
        if (StringUtils.isEmpty(vendorId)) {
            response.setError("vendor.time.query.error");
            return response;
        }
        try {

            // 根据供应商ID从本地缓存获取供应商信息 modify by zhangshiqiang
            vendorInfoModel = findVendorInfoByIdCache(vendorId);
            // 根据供应商ID从本地缓存获取供应商用户 modify by zhangshiqiang
            vendorModel = findVendorByIdCache(vendorId);
            // 根据供应商ID从获取分期费率
            List<TblVendorRatioModel> tblVendorRatioModelList = tblVendorRatioDao.findStageByVendorId(vendorId);
            // 根据供应商ID从获取邮购分期
            List<MailStagesModel> mailStagesModelList = mailStagesDao.findMailStagesListByVendorId(vendorId);

            // 将查询到数据通过copy和set最终封装成response返回
            BeanMapper.copy(vendorInfoModel, vendorInfoDto);
            vendorInfoDto.setVendorModel(vendorModel);
            BeanMapper.copy(vendorInfoDto, cooperationDto);
            cooperationDto.setTblVendorRatioModelList(tblVendorRatioModelList);
            cooperationDto.setMailStagesModelList(mailStagesModelList);
            response.setResult(cooperationDto);
            return response;
        } catch (Exception e) {
            log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.time.query.error");
            return response;
        }
    }

    /**
     * 根据vendorId查询(内管平台用)
     *
     * @param vendorId
     * @return
     */
    @Override
    public Response<VendorInfoDto> findById(String vendorId) {
        Response<VendorInfoDto> response = new Response<VendorInfoDto>();
        VendorInfoModel vendorInfoModel = new VendorInfoModel();
        VendorModel vendorModel = new VendorModel();
        VendorInfoDto vendorInfoDto = new VendorInfoDto();
        // 如果vendor_id为空，则通过user获取；如果user获取也为空，返回错误信息
        if (StringUtils.isEmpty(vendorId)) {
            response.setError("vendor.time.query.error");
            return response;
        }
        try {

            // 根据供应商ID从本地缓存获取供应商信息 modify by zhangshiqiang
            vendorInfoModel = findVendorInfoByIdCache(vendorId);
            // 根据供应商ID获取供应商主帐号用户
            VendorModel param = new VendorModel();
            param.setVendorId(vendorId);
            param.setIsSub("0");//查询的是主帐号的信息
            vendorModel = vendorDao.findVendor(param);

			// 将查询到数据通过copy和set最终封装成response返回
			BeanMapper.copy(vendorInfoModel, vendorInfoDto);
			vendorInfoDto.setVendorModel(vendorModel);
			response.setResult(vendorInfoDto);
			return response;
		} catch (Exception e) {
			log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("vendor.time.query.error");
			return response;
		}
	}

	/**
	 * 根据vendorId查询(内管平台审核专用)
	 *
	 * @param vendorId
	 * @return
	 */
	@Override
	public Response<VendorInfoDto> findByIdForCheck(String vendorId) {
		Response<VendorInfoDto> response = new Response<VendorInfoDto>();
//		VendorInfoModel vendorInfoModel = new VendorInfoModel();
//		VendorModel vendorModel = new VendorModel();
		// StageRateModel stageRateModel = new StageRateModel();
		VendorInfoDto vendorInfoDto = new VendorInfoDto();
		// 如果vendor_id为空，则通过user获取；如果user获取也为空，返回错误信息
		if (StringUtils.isEmpty(vendorId)) {
			response.setError("vendor.time.query.error");
			return response;
		}
		try {
			return getVendorInfoDtoResponse(response, vendorInfoDto, vendorId);
		} catch (Exception e) {
			log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("vendor.time.query.error");
			return response;
		}
	}

	/**
	 * 根据vendorId查询(供应商平台用)
	 *
	 * @param user
	 * @return
	 */
	@Override
	public Response<VendorInfoDto> findByVendorId(@Param("") User user) {
		Response<VendorInfoDto> response = new Response<VendorInfoDto>();
//		VendorInfoModel vendorInfoModel = new VendorInfoModel();
//		VendorModel vendorModel = new VendorModel();
		// StageRateModel stageRateModel = new StageRateModel();
		VendorInfoDto vendorInfoDto = new VendorInfoDto();
		// 通过user获取vendorId；如果user获取也为空，返回错误信息
		String vendorId = user.getId();
		if (StringUtils.isEmpty(vendorId)) {
			response.setError("vendor.time.query.error");
			return response;
		}
		try {
			return getVendorInfoDtoResponse(response, vendorInfoDto, vendorId);

        } catch (Exception e) {
            log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.time.query.error");
            return response;
        }
    }

	/**
	 * 构建供应商信息集合
	 *
	 * @param response
	 * @param vendorInfoDto
	 * @param vendorId
	 * @return
	 */
	private Response<VendorInfoDto> getVendorInfoDtoResponse(Response<VendorInfoDto> response,
			VendorInfoDto vendorInfoDto, String vendorId) {
		VendorInfoModel vendorInfoModel;
		VendorModel vendorModel;
		// 根据vendorId查询vendor_info数据
		vendorInfoModel = findVendorInfoByIdCache(vendorId);
		String diffinfoForUpdate = vendorInfoModel.getDiffinfoForUpdate();
		if (diffinfoForUpdate != null && !"".equals(diffinfoForUpdate)) {
			// 如果diffinfoForUpdate不空，将diffinfoForUpdate取出并转为dto进行返回
			vendorInfoDto = JsonMapper.nonEmptyMapper().fromJson(diffinfoForUpdate, VendorInfoDto.class);
		} else {
			// 根据vendorId查询vendor_user数据
			vendorModel = findVendorByIdCache(vendorId);
			// 将查询到数据通过copy和set最终封装成response返回
			BeanMapper.copy(vendorInfoModel, vendorInfoDto);
			vendorInfoDto.setVendorModel(vendorModel);
		}
		response.setResult(vendorInfoDto);
		return response;
	}

	/**
	 * 商城合作商添加
	 *
	 * @param vendorInfoDto
	 * @param stageRateDto
	 * @return
	 */
	@Override
	public Response<Boolean> create(VendorInfoDto vendorInfoDto, StageRateDto stageRateDto,
			MailStagesDto mailStagesDto) {
		Response<Boolean> response = new Response<Boolean>();

		if (vendorInfoDto == null) {
			response.setError("create.vendor.error");
			return response;
		}
		// 将vendor_inf的vendorId赋值到vendor中的vendorId
		vendorInfoDto.getVendorModel().setVendorId(vendorInfoDto.getVendorId());
		// 将vendor_inf的simpleName赋值到vendor中的simpleName
		vendorInfoDto.getVendorModel().setSimpleName(vendorInfoDto.getSimpleName());
		//关于o2o供应商的逻辑   积分商城的O2O供应商，Action_flag设置成实时推送--00；广发商城的O2O供应商，Action_flag设置成批量推送--01。
		String businessTypeId = vendorInfoDto.getBusinessTypeId();//区分是广发商城还是积分商城供应商
		String vendorRole = vendorInfoDto.getVendorRole();//区分是不是o2o供应商
		if("3".equals(vendorRole)){
			if("YG".equals(businessTypeId)){
				vendorInfoDto.setActionFlag("01");
			}else if("JF".equals(businessTypeId)){
				vendorInfoDto.setActionFlag("00");
			}
		}
		//获取创建人
		String createOper = vendorInfoDto.getCreateOper();
		vendorInfoDto.getVendorModel().setCreateOper(createOper);
		if(stageRateDto !=null){
			List<TblVendorRatioModel> tblVendorRatioModelList = stageRateDto.getTblVendorRatioModelList();
			for (TblVendorRatioModel tblVendorRatioModel : tblVendorRatioModelList) {
				tblVendorRatioModel.setVendorId(vendorInfoDto.getVendorId());
				tblVendorRatioModel.setCreateOper(createOper);
			}
		}
		if(mailStagesDto != null){
			// 将vendor_inf的vendorId赋值到mail_stages中的vendorId
			List<MailStagesModel> mailStagesModelList = mailStagesDto.getMailStagesModelList();
			for (MailStagesModel mailStagesModel : mailStagesModelList) {
				mailStagesModel.setVendorId(vendorInfoDto.getVendorId());
				mailStagesModel.setCreateOper(createOper);
			}
		}
		try {
			// 校验
//			if (vendorInfoDto == null) {
//				response.setError("create.vendor.error");
//				return response;
//			}
			Boolean result = userManager.create(vendorInfoDto, stageRateDto, mailStagesDto);
			if (!result) {
				response.setError("create.vendor.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("create.vendor.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.vendor.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("create.vendor.error");
			return response;
		}
	}

	/**
	 * 商城合作商编辑
	 *
	 * @param vendorInfoDto
	 * @param stageRateDto
	 * @return
	 */
	@Override
	public Response<Boolean> update(VendorInfoDto vendorInfoDto, StageRateDto stageRateDto, MailStagesDto mailStagesDto,
			List stageRateIdList, List mailStagesIdList,String createName) {
		Response<Boolean> response = new Response<Boolean>();
		// 校验
		if (vendorInfoDto == null) {
			response.setError("update.vendor.error");
			return response;
		}
		// 将vendor_inf的vendorId赋值到vendor_user中的vendorId
		vendorInfoDto.getVendorModel().setVendorId(vendorInfoDto.getVendorId());
		// 将vendor_inf的simpleName赋值到vendor中的simpleName
		vendorInfoDto.getVendorModel().setSimpleName(vendorInfoDto.getSimpleName());
		//关于o2o供应商的逻辑   积分商城的O2O供应商，Action_flag设置成实时推送--00；广发商城的O2O供应商，Action_flag设置成批量推送--01。
		String businessTypeId = vendorInfoDto.getBusinessTypeId();//区分是广发商城还是积分商城供应商
		String vendorRole = vendorInfoDto.getVendorRole();//区分是不是o2o供应商
		if("3".equals(vendorRole)){
			if("YG".equals(businessTypeId)){
				vendorInfoDto.setActionFlag("01");
			}else if("JF".equals(businessTypeId)){
				vendorInfoDto.setActionFlag("00");
			}
		}else{
			vendorInfoDto.setActionFlag("");
		}
		if(stageRateDto != null){
			// 将vendor_inf的vendorId赋值到stage_rate中的vendorId
			List<TblVendorRatioModel> tblVendorRatioModelList = stageRateDto.getTblVendorRatioModelList();
			for (TblVendorRatioModel tblVendorRatioModel : tblVendorRatioModelList) {
				tblVendorRatioModel.setVendorId(vendorInfoDto.getVendorId());
				String createOper = tblVendorRatioModel.getCreateOper();
				if(StringUtils.isEmpty(createOper)){
					tblVendorRatioModel.setCreateOper(createName);
				}
			}
		}
		if(mailStagesDto != null){
			// 将vendor_inf的vendorId赋值到mail_stages中的vendorId
			List<MailStagesModel> mailStagesModelList = mailStagesDto.getMailStagesModelList();
			for (MailStagesModel mailStagesModel : mailStagesModelList) {
				mailStagesModel.setVendorId(vendorInfoDto.getVendorId());
				String createOper = mailStagesModel.getCreateOper();
				if(StringUtils.isEmpty(createOper)){
					mailStagesModel.setCreateOper(createName);
				}
			}
		}

		try {
			// 校验
//			if (vendorInfoDto == null) {
//				response.setError("update.vendor.error");
//				return response;
//			}
			Boolean result = userManager.update(vendorInfoDto, stageRateDto, mailStagesDto, stageRateIdList,
					mailStagesIdList);
			if (!result) {
				response.setError("update.vendor.error");
				return response;
			}
			// 使缓存失效
			verdorInfoCache.invalidate(vendorInfoDto.getVendorId());
			vendorCache.invalidate(vendorInfoDto.getVendorId());
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.vendor.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("update.vendor.error");
			return response;
		}
	}

    /**
     * 商城合作商删除
     *
     * @param vendorId
     * @return
     */
    @Override
    public Response<Boolean> delete(String vendorId) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            // 校验
            if (StringUtils.isEmpty(vendorId)) {
                response.setError("delete.vendor.error");
                return response;
            }
            Boolean result = userManager.delete(vendorId);
            if (!result) {
                response.setError("delete.vendor.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("delete.vendor.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("delete.vendor.error");
            return response;
        }
    }

    /**
     * 商城合作商审核
     *
     * @param vendorId
     * @return
     */
    @Override
    public Response<Boolean> vendorCheck(String vendorId, String pwsecond, String refuseDesc) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            // 校验
            if (StringUtils.isEmpty(vendorId)) {
                response.setError("check.vendor.error");
                return response;
            }
            Boolean result = userManager.vendorCheck(vendorId, pwsecond, refuseDesc);
            if (!result) {
                response.setError("check.vendor.error");
                return response;
            }
            // 使缓存失效
            verdorInfoCache.invalidate(vendorId);
            vendorCache.invalidate(vendorId);
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("check.vendor.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("check.vendor.error");
            return response;
        }
    }

    /**
     * 商城合作商拒绝
     *
     * @param vendorId
     * @param refuseDesc
     * @return
     */
    @Override
    public Response<Boolean> vendorRefuse(String vendorId, String refuseDesc) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            // 校验
            if (StringUtils.isEmpty(vendorId)) {
                response.setError("refuse.vendor.error");
                return response;
            }
            Boolean result = userManager.vendorRefuse(vendorId, refuseDesc);
            if (!result) {
                response.setError("refuse.vendor.error");
                return response;
            }
            // 使缓存失效
            verdorInfoCache.invalidate(vendorId);
            vendorCache.invalidate(vendorId);
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("refuse.vendor.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("refuse.vendor.error");
            return response;
        }
    }

    /**
     * 查询所有供应商
     *
     * @return
     */
    @Override
    public Response<List<VendorInfoModel>> findAll(VendorInfoModel vendorInfoModel) {
        Response<List<VendorInfoModel>> response = new Response<List<VendorInfoModel>>();
        try {
            // 查询vendor_info数据
            response.setResult(vendorInfoDao.findAll(vendorInfoModel));
            return response;
        } catch (Exception e) {
            log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.time.query.error");
            return response;
        }
    }

    /**
     * 根据供应商简称查询供应商id的集合
     *
     * @param simpleName
     * @return
     */
    @Override
    public Response<List<String>> findIdByName(String simpleName) {
        Response<List<String>> response = new Response<List<String>>();
        try {
            // 校验
            if (StringUtils.isEmpty(simpleName)) {
                response.setError("vendor.time.query.error");
                return response;
            }
            // 查询vendor_info数据
            response.setResult(vendorInfoDao.findIdByName(simpleName));
            return response;
        } catch (Exception e) {
            log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.time.query.error");
            return response;
        }
    }

    /**
     * 根据供应商ID停用该供应商下所有子帐号
     *
     * @param vendorId
     * @return
     */
    @Override
    public Response<Boolean> updateByParentId(String vendorId) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            // 校验
            if (StringUtils.isEmpty(vendorId)) {
                response.setError("vendorId.null");
                return response;
            }
            // 更新vendor数据
            Integer count = userManager.updateByParentId(vendorId);
            if (count < 0) {
                response.setResult(false);
            }
            response.setResult(true);
            return response;
        } catch (Exception e) {
            log.error("vendor.account.update.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.account.update.error");
            return response;
        }
    }

    /**
     * 根据供应商Id删除子帐号
     *
     * @param vendorId
     * @return
     */
    @Override
    public Response<Boolean> deleteByParentId(String vendorId) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            // 校验
            if (StringUtils.isEmpty(vendorId)) {
                response.setError("vendorId.null");
                return response;
            }
            // 更新vendor数据
            Integer count = userManager.deleteByParentId(vendorId);
            if (count < 0) {
                response.setResult(false);
            }
            response.setResult(true);
            return response;
        } catch (Exception e) {
            log.error("vendor.account.delete.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.account.delete.error");
            return response;
        }
    }

    /**
     * 新增时校验合作商编号和用户编号是否存在
     *
     * @param vendorId
     * @param vendorCode
     * @return
     */
    @Override
    public Response<Integer> vendorCreateCheck(String vendorId, String vendorCode) {
        Response<Integer> response = new Response<Integer>();
        response.setResult(4);//赋默认值，否则调取服务失败
        try {
            if (StringUtils.isNotEmpty(vendorId) && StringUtils.isEmpty(vendorCode)) {
                VendorInfoModel result = vendorInfoDao.checkById(vendorId);
                if (result != null) {
                    response.setResult(1);
                } // 合作商编码已存在
            }
            if (StringUtils.isNotEmpty(vendorCode) && StringUtils.isEmpty(vendorId)) {
                VendorModel result = vendorDao.checkByCode(vendorCode);
                if (result != null) {
                    response.setResult(2);
                } // 用户编号已存在
            }
            if (StringUtils.isNotEmpty(vendorCode) && StringUtils.isNotEmpty(vendorId)) {
                VendorInfoModel resulti = vendorInfoDao.checkById(vendorId);
                VendorModel result = vendorDao.checkByCode(vendorCode);
                if (resulti != null && result == null) {
                    response.setResult(1);// 合作商编码已存在
                } else if (resulti == null && result != null) {
                    response.setResult(2);// 用户编号已存在
                } else if ((result != null && resulti != null)) {
                    response.setResult(3);// 都存在
                }
            }
            return response;
        } catch (Exception e) {
            log.error("check.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("check.error");
            return response;
        }
    }

    /**
     * 根据父id查询其子帐号
     *
     * @param pageNo
     * @param size
     * @param vendorId
     * @return
     */
    @Override
    public Response<Pager<VendorDto>> findByParentId(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                                     @Param("vendorId") String vendorId) {
        Response<Pager<VendorDto>> response = new Response<Pager<VendorDto>>();
        Map<String, Object> paramMap = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        try {
            // 根据合作商编码查询父id
            Long parentId = vendorDao.findParIdByVenId(vendorId);
            paramMap.put("parentId", parentId);// 供应商父id
            // 子帐号集合
            Pager<VendorModel> pager = vendorDao.findByParentId(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
            // 逻辑整理：
            // 1、vendor表和vendor_role_ref表联查
            // 获取出子帐号集合后，根据vendor表子帐号的id和vendor_role_ref表user_id的对应关系，查找出role_id的集合；
            // 2、vendor_role_ref表和vendor_role表联查
            // 根据vendor_role_ref表role_id和vendor_role表中id一一对应的关系，查找出角色名称

            if (pager.getTotal() > 0) {
                List<VendorModel> vendorModels = pager.getData();
                List<VendorDto> vendorDtos = Lists.newArrayList();
                List<VendorRoleModel> vendorRoleModels = Lists.newArrayList();
                VendorDto vendorDto = null;
                // vendor和vendor_role表关联
                for (VendorModel vendorModel : vendorModels) {
                    vendorDto = new VendorDto();
                    String id = vendorModel.getId();
                    // 根据vendor表子帐号的id和vendor_role_ref表user_id的对应关系，查找出role_id的集合
                    List<Long> roleIdList = vendorRoleRefDao.getRoleIdByUserId(id);
                    if (roleIdList.size() > 0) {
                        vendorRoleModels = new ArrayList<VendorRoleModel>();
                        for (Long roleId : roleIdList) {
                            VendorRoleModel vendorRoleModel = vendorRoleDao.findById(roleId);
                            vendorRoleModels.add(vendorRoleModel);
                        }
                        vendorDto.setVendorRoleModels(vendorRoleModels);
                    }
                    // 将model的数据复制到dto里
                    BeanMapper.copy(vendorModel, vendorDto);
                    // 将单条的数据放入到list中
                    vendorDtos.add(vendorDto);
                }
                response.setResult(new Pager<VendorDto>(pager.getTotal(), vendorDtos));
                return response;
            } else {
                response.setResult(new Pager<VendorDto>(0L, Collections.<VendorDto>emptyList()));
                return response;
            }
        } catch (Exception e) {
            log.error("vendor.account.query.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.account.query.error");
            return response;
        }
    }

    /**
     * 供应商用户账号管理 启用未启用状态修改
     *
     * @param code
     * @param status
     * @return
     */
    @Override
    public Response<Boolean> changeStatus(String code, String status) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            // 校验
            if (StringUtils.isEmpty(code) || StringUtils.isEmpty(status)) {
                response.setError("update.error");
                return response;
            }
            // 根据用户编码code更新vendor表启用状态status
            VendorModel vendorModel = new VendorModel();
            vendorModel.setCode(code);
            vendorModel.setStatus(status);
            Boolean result = userManager.changeStatus(vendorModel);
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("vendor.account.change.status.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.account.change.status.error");
            return response;
        }
    }

    /**
     * 根据vendorIds查询(商城用)
     *
     * @param vendorIds
     * @return
     */
    @Override
    public Response<List<VendorInfoModel>> findByVendorIds(List<String> vendorIds) {
        Response<List<VendorInfoModel>> response = new Response<List<VendorInfoModel>>();
        try {
            List<VendorInfoModel> vendorInfoModelList = vendorInfoDao.findByVendorIds(vendorIds);
            response.setResult(vendorInfoModelList);
        } catch (Exception e) {
            log.error("vendor.findByVendorIds.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.findByVendorIds.error");
        }
        return response;
    }

    /**
     * 获取全部供应商供特殊积分倍率设置使用
     *
     * @param
     * @return
     */

    public Response<List<VendorInfoModel>> findAllVendor(String simpleName) {
        Response<List<VendorInfoModel>> response = new Response<List<VendorInfoModel>>();
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!StringUtils.isEmpty(simpleName)) {
            paramMap.put("simpleName", simpleName);
        }
        //优惠券只针对广发商城
        paramMap.put("businessTypeId","YG");
        try {
            // 查询vendor_info数据
            response.setResult(vendorInfoDao.findAllVendor(paramMap));
            return response;
        } catch (Exception e) {
            log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.time.query.error");
            return response;
        }
    }

    @Override
    public Response<List<VendorInfoIdDto>> findVenDtoByName(String simpleName) {
        Response<List<VendorInfoIdDto>> response = new Response<>();
        try {
            // 查询vendor_info数据
            String tempName = null;
            if (StringUtils.isNotEmpty(simpleName)) {
                tempName = simpleName;
            }
            response.setResult(vendorInfoDao.findVenDtoByName(tempName));
            return response;
        } catch (Exception e) {
            log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.time.query.error");
            return response;
        }
    }

    /**
     * 根据供应商id及分期数查询相应的比率信息
     *
     * @param vendorId
     * @param installmentNumber
     * @return
     */
    @Override
    public Response<TblVendorRatioModel> findRatioByVendorId(String vendorId, Integer installmentNumber) {
        Response<TblVendorRatioModel> response = new Response<>();
        try {
            Map<String, Object> params = Maps.newHashMap();
            if (!Strings.isNullOrEmpty(vendorId)) {
                params.put("vendorId", vendorId);
            }
            if (installmentNumber != null) {
                params.put("period", installmentNumber);
            }
            TblVendorRatioModel tblVendorRatioModel = tblVendorRatioDao.findVendorRatioInfo(params).get(0);
            response.setResult(tblVendorRatioModel);
            return response;
        } catch (Exception e) {
            log.error("find.ratio.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("find.ratio.error");
            return response;
        }
    }

    /**
     * 根据供应商id查询该供应商的比率信息
     *
     * @param vendorId
     * @return
     */
    @Override
    public Response<List<TblVendorRatioModel>> findRaditListByVendorId(String vendorId) {
        Response<List<TblVendorRatioModel>> response = new Response<>();
        try {
            List<TblVendorRatioModel> list = tblVendorRatioDao.findRaditListByVendorId(vendorId);
            response.setResult(list);
            return response;
        } catch (Exception e) {
            log.error("find.ratio.by.vendor.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("find.ratio.by.vendor.error");
            return response;
        }
    }

    /**
     * 根据名称模糊查询供应商，并且去除指定供应商ID的供应商信息
     *
     * @param vendorIds
     * @return
     */
    @Override
    public Response<List<VendorInfoIdDto>> findVenDtoByVendorIds(List<String> vendorIds) {
        Response<List<VendorInfoIdDto>> response = new Response<>();
        try {
            response.setResult(vendorInfoDao.findVenDtoByVendorIds(vendorIds));
            return response;
        } catch (Exception e) {
            log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.time.query.error");
            return response;
        }
    }

    /**
     * 根据供应商ID查询供应商信息
     *
     * @param vendorId
     * @return
     */
    public Response<VendorInfoModel> findVendorById(String vendorId) {
        Response<VendorInfoModel> response = new Response<VendorInfoModel>();
        try {
            response.setResult(vendorInfoDao.findByVendorId(vendorId));
            return response;
        } catch (Exception e) {
            log.error("find.vendor.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("find.vendor.error");
            return response;
        }
    }


	/**
	 * 根据vendorId查询(内管平台用)
	 *
	 * @param vendorIdList
	 * @return
	 */
	@Override
	public Response<List<VendorInfoDto>> findByListId(List<String> vendorIdList) {
		Response<List<VendorInfoDto>> response = new Response<List<VendorInfoDto>>();
//		List<VendorInfoModel> vendorInfoModelList = new ArrayList<VendorInfoModel>();
		try {
			// 根据供应商ID从本地缓存获取供应商信息 modify by zhangshiqiang
			List<VendorModel> vendorModels = vendorDao.findVendorByListId(vendorIdList);
			Map<String, VendorModel> venMap = new HashMap<>();
			if( vendorModels != null){
				for(VendorModel tempmodel : vendorModels){
					venMap.put(tempmodel.getVendorId(),tempmodel);
				}
			}
			List<VendorInfoDto> vendorInfoDtoList = new ArrayList<VendorInfoDto>();
//			List<VendorInfoDto> rVendorInfoDtoList = new ArrayList<VendorInfoDto>();
			for(String vendorId:vendorIdList){
				VendorInfoModel vendorInfoModel = findVendorInfoByIdCache(vendorId);
				VendorInfoDto vendorInfoDto = new VendorInfoDto();
				if(vendorInfoModel!=null){
					BeanMapper.copy(vendorInfoModel, vendorInfoDto);
				}
				vendorInfoDto.setVendorModel(venMap.get(vendorId));
				vendorInfoDtoList.add(vendorInfoDto);
			}
			response.setResult(vendorInfoDtoList);
			return response;
		} catch (Exception e) {
			log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("vendor.time.query.error");
			return response;
		}
	}

    /**
     * 根据查询条件查询供应商信息
     *
     * @param vendorId
     * @return
     */
    @Override
    public Response<VendorInfoModel> findInfoByConditions(String vendorId) {
        Response<VendorInfoModel> response = new Response<VendorInfoModel>();
        try {
            VendorInfoModel vendorInfoModel = vendorInfoDao.findInfoByConditions(vendorId);
            response.setResult(vendorInfoModel);
        } catch (Exception e) {
            log.error("findByCodes.item.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        return response;
    }


    /**
     * 供应商导入
     *
     * @param vendorRatioUploadDtos
     * @return
     */
	@Override
    public Response<List<VendorRatioUploadDto>> uploadVendorRatios(List<VendorRatioUploadDto> vendorRatioUploadDtos, User user) {
        Response<List<VendorRatioUploadDto>> result = new Response<List<VendorRatioUploadDto>>();
        String createOper = user.getId();
		List<VendorRatioUploadDto> resultList = userManager.uploadVendorRatios(vendorRatioUploadDtos,createOper);
		result.setResult(resultList);
        return result;
    }

    /**
     * 根据查询条件查询角色等信息
     *
     * @param vendorId
     * @return
     */
    @Override
    public Response<VendorInfoModel> findVendorRoleByConditions(String vendorId) {
        Response<VendorInfoModel> response = new Response<VendorInfoModel>();
        try {
            VendorInfoModel vendorInfoModel = vendorInfoDao.findVendorRoleByConditions(vendorId);
            response.setResult(vendorInfoModel);
        } catch (Exception e) {
            log.error("findByCodes.item.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        return response;
    }

    /**
     * 根据查询条件查询角色等信息
     *
     * @param vendorId
     * @return
     */
    @Override
    public Response<VendorInfoModel> findVendorInfosByVendorId(String vendorId) {
        Response<VendorInfoModel> response = new Response<VendorInfoModel>();
        try {
            VendorInfoModel vendorInfoModel = vendorInfoDao.findVendorInfosByVendorId(vendorId);
            response.setResult(vendorInfoModel);
        } catch (Exception e) {
            log.error("findByCodes.item.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        return response;
    }

    /**
     * 根据主键查询外系统信息
     *
     * @param id
     * @return
     */
    @Override
    public Response<ShopinfOutsystemModel> findShopInfoOutSysInfosById(Long id) {
        Response<ShopinfOutsystemModel> response = new Response<ShopinfOutsystemModel>();
        try {
            ShopinfOutsystemModel shopinfOutsystemModel = shopinfOutsystemDao.findInfoById(id);
            response.setResult(shopinfOutsystemModel);
        } catch (Exception e) {
            log.error("findByCodes.item.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        return response;
    }

    /**
     * 查询需要推送的数量
     *
     * @param vendorIdList 供应商id列表
     * @return 数量
     * <p>
     * geshuo 20160824
     */
    @Override
    public Response<Long> findNeedActionCount(List<String> vendorIdList) {
        Response<Long> response = new Response<Long>();
        try {
            Long count = vendorInfoDao.findNeedActionCount(vendorIdList);
            response.setResult(count);
        } catch (Exception e) {
            log.error("findByCodes.item.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        return response;
    }


	@Override
	public Response<String> getUserType(User user){
		Response<String> response = Response.newResponse();
		try {
			String userType = user.getUserType();
			response.setResult(userType);
		}catch (Exception e){
			log.error("get.user.type.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("get.user.type.error");
		}
		return response;
	}

	/**
	 * 根绝id查询供应商用户信息
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<VendorModel> findVendorUserById(Long id) {
		Response<VendorModel> response = Response.newResponse();
		try {
			VendorModel vendorModel = vendorDao.findById(id);
			response.setResult(vendorModel);
		}catch (Exception e){
			log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("vendor.time.query.error");
		}
		return response;
	}

    @Override
    public Response<List<VendorInfoModel>> findVendorByChannel(String channel) {
        Response<List<VendorInfoModel>> res = Response.newResponse();
        if(isNull(ChannelType.from(channel))) {
            log.error("channel is not exists,channel:{}",channel);
            res.setError("channel.not.exist");
            return res;
        }
        VendorInfoModel vendorInfoModel = new VendorInfoModel();
        vendorInfoModel.setBusinessTypeId(channel);
        vendorInfoModel.setStatus(Contants.VENDOR_COMMON_STATUS_0102);
        List<VendorInfoModel> optionals = vendorInfoDao.findAll(vendorInfoModel);
        //Optional<List<VendorInfoModel>> optionals = verdorInfoAllCache.getUnchecked(channel);
        if (optionals.size()==0 ||optionals.isEmpty()) {
            res.setResult(Collections.<VendorInfoModel>emptyList());
            return res;
        }
        res.setResult(optionals);
        return res;
    }

    /**
     * 查询 供应商 信息列表
     *
     * @param model 查询条件
     * @return models
     *
     */
    @Override
    public Response<List<VendorInfoModel>> findVendorsByModel(VendorInfoModel model) {
        Response<List<VendorInfoModel>> res = Response.newResponse();
        if(isNull(model)) {
            log.error("channel is not exists,channel: model");
            res.setError("model.not.exist");
            return res;
        }
        List<VendorInfoModel> optionals = vendorInfoDao.findAll(model);
        if (optionals.size()==0 ||optionals.isEmpty()) {
            res.setResult(Collections.<VendorInfoModel>emptyList());
            return res;
        }
        res.setResult(optionals);
        return res;
    }
    /**
     * 根据vendorIds查询(商城用)
     *
     * @param vendorIds
     * @return
     */
    @Override
    public Response<List<VendorInfoModel>> findByVendorIdsForBrandAuth(List<String> vendorIds) {
        Response<List<VendorInfoModel>> response = new Response<List<VendorInfoModel>>();
        try {
            List<VendorInfoModel> vendorInfoModelList = vendorInfoDao.findByVendorIdsForBrandAuth(vendorIds);
            response.setResult(vendorInfoModelList);
        } catch (Exception e) {
            log.error("vendor.findByVendorIds.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.findByVendorIds.error");
        }
        return response;
    }

    /**
     * 根据vendorId查询
     * @param vendorIdList
     * @return
     */
    @Override
    public Response<List<VendorModel>> findByListIds(List<String> vendorIdList) {
        Response<List<VendorModel>> response = Response.newResponse();
        try {
            List<VendorModel> vendorModels = vendorDao.findVendorByListId(vendorIdList);
            response.setResult(vendorModels);
            return response;
        } catch (Exception e) {
            log.error("vendor.time.query.error,error{}", Throwables.getStackTraceAsString(e));
            response.setError("vendor.time.query.error");
            return response;
        }
    }
}

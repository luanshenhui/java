/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;
import static com.spirit.util.Arguments.isNull;
import static com.spirit.util.Arguments.notNull;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.optimal.commons.util.StringUtil;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;

import cn.com.cgbchina.common.utils.NameValidator;
import cn.com.cgbchina.user.dao.VendorDao;
import cn.com.cgbchina.user.dao.VendorRoleDao;
import cn.com.cgbchina.user.dao.VendorRoleRefDao;
import cn.com.cgbchina.user.dto.VendorRoleDto;
import cn.com.cgbchina.user.dto.VendorsDto;
import cn.com.cgbchina.user.manager.VendorUserManager;
import cn.com.cgbchina.user.model.VendorModel;
import lombok.extern.slf4j.Slf4j;

/**
 * @author wusy
 * @version 1.0
 * @created at 2016/5/27.
 */
@Service
@Slf4j
public class VendorUserServiceImpl implements VendorUserService {

	// 本地缓存
	private final LoadingCache<Long, VendorModel> userCache;

	@Resource
	private VendorDao vendorDao;
    @Resource
    private VendorUserManager vendorUserManager;
    @Autowired
    private OrganiseService organiseService;
    @Autowired
    private AdminRoleService adminRoleService;
    @Resource
    private VendorRoleDao vendorRoleDao;
    @Resource
    private VendorRoleRefDao vendorRoleRefDao;
    @Autowired
    private VendorRoleService vendorRoleService;


	// 构造函数
	public VendorUserServiceImpl() {
		userCache = CacheBuilder.newBuilder().expireAfterWrite(5, TimeUnit.MINUTES)
				.build(new CacheLoader<Long, VendorModel>() {
					@Override
					public VendorModel load(Long id) throws Exception {
						return vendorDao.findById(id);
					}
				});
	}

	/**
	 * 供应商用户登录
	 *
	 * @param userName 用户名
	 * @param password 密码
	 * @return
	 */
	@Override
	public Response<VendorModel> vendorLogin(String userName, String password) {
		Response<VendorModel> result = new Response<VendorModel>();

		try {
			checkArgument(notNull(userName.trim()), "login.userName.empty");
			checkArgument(notNull(password.trim()), "login.password.can.not.be.empty");
			// 查询用户信息，没有返回账号密码不正确
			VendorModel vendorModel = queryUserBy(userName);
			checkState(notNull(vendorModel), "user.or.password.error");
            //用户是否被停用
            if(!"0102".equals(vendorModel.getStatus())){
                log.error("user status stop userId={}", userName);
                result.setError("user.status.stop");
                return result;
            }
            result.setResult(vendorModel);
            return result;

		} catch (IllegalArgumentException e) {
			log.error("fail to login with userName:{} ,error:{}", userName, e.getMessage());
			result.setError(e.getMessage());
		} catch (IllegalStateException e) {
			log.error("fail to login with userName:{} ,error:{}", userName, e.getMessage());
			result.setError(e.getMessage());
		} catch (Exception e) {
			log.error("fail to login with userName:{} ,cause:{}", userName, Throwables.getStackTraceAsString(e));
			result.setError("user.login.fail");
		}
		return result;
	}

	@Override
	public Response<VendorModel> findVendorById(Long vendorUserId) {
		Response<VendorModel> result = new Response<VendorModel>();
		// 校验用户Id
		if (vendorUserId == null) {
			log.error("user id can not be null");
			result.setError("userId.not.null.fail");
			return result;
		}
		try {
			// 根据用户ID查询用户信息，此处走本地缓存，缓存实现机制，guava cache
			VendorModel user = userCache.getUnchecked(vendorUserId);
			// 查询结果
			if (user == null) {
				log.error("failed to find UserInfo where userId={}", vendorUserId);
				result.setError("UserInfo.not.found");
				return result;
			}

			result.setResult(user);
			return result;
		} catch (Exception e) {
			log.error("failed to find userInfo where id={},cause:{}", vendorUserId,
					Throwables.getStackTraceAsString(e));
			result.setError("userInfo.query.fail");
			return result;
		}
	}

	/**
	 * 首次登录更新密码
	 * 
	 * @param vendorModel
	 * @return
	 */
	@Override
	public Response updatePwdByCode(VendorModel vendorModel) {
		Response result = new Response();
		// 校验用户登录名
		if (StringUtil.isNullOrEmpty(vendorModel.getCode())) {
			log.error("user id can not be null");
			result.setError("user id can not be null");
			return result;
		}
		try {
			// 首次登录成功后，更新数据库
			vendorDao.updatePwdByCode(vendorModel);
			userCache.invalidate(Long.parseLong(vendorModel.getId()));
			result.setResult(true);
			return result;

		} catch (Exception e) {
			log.error("failed to find userInfo where id={},cause:{}", vendorModel.getCode(),
					Throwables.getStackTraceAsString(e));
			result.setError("vendorUser.modifyPwd.fail");
			return result;
		}
	}

	/**
	 * 根据供应商登录名查询信息
	 *
	 * @param code
	 * @return
	 */
	@Override
	public Response<VendorModel> findByVendorCode(String code){
		Response<VendorModel> result = new Response<VendorModel>();
		try {
			// 首次登录成功后，更新数据库
			VendorModel vendorModel = vendorDao.checkByCode(code);
			if (vendorModel == null) {
				log.error("failed to find UserInfo where userId={}", vendorModel.getVendorId());
				result.setError("UserInfo.not.found");
				return result;
			}
			result.setResult(vendorModel);
			return result;

		} catch (Exception e) {
			log.error("failed to find userInfo,cause:{}",
					Throwables.getStackTraceAsString(e));
			result.setError("vendorUser.modifyPwd.fail");
			return result;
		}
	}

    /**
     * 查询供应商信息
     * @param userName
     * @return
     */
	private VendorModel queryUserBy(String userName) {
		VendorModel vendorModel = vendorDao.findByVendorCode(userName);
		return vendorModel;
	}

    /**
     * 新建供应商子帐号
     *
     * @param vendorModel
     * @return
     */
    @Override
    public Response<String> create(VendorModel vendorModel) {
        Response<String> result = new Response<String>();
        try {
            // 校验参数
            checkArgument(!isNull(vendorModel), "userInfo.is.null");
            if (Strings.isNullOrEmpty(vendorModel.getId())) {
                log.error("user name can not be null");
                result.setError("user.name.empty");
                return result;
            }
            if (!NameValidator.validate(vendorModel.getId())) {
                log.error("用户名称只能由字母,数字和下划线组成,but got {}", vendorModel.getName());
                result.setError("user.illegal.name");
                return result;
            }

//            // 判断用户是否存在
//            UserInfoModel isExist = userInfoDao.findByNameFlag(userInfoDto.getName());
//            if (isExist != null) {
//                // result.setError(Boolean.FALSE);
//                result.setResult("98");
//                return result;
//            }
            // 判断账号是否存在
            VendorModel isId = vendorDao.checkByCode(vendorModel.getCode());
            if (isId != null) {
                // result.setError(Boolean.FALSE);
                result.setResult("99");
                return result;
            }
            // 新建用户

            Integer res = vendorUserManager.insert(vendorModel);
            if(res==1){
                result.setResult("00");
            }else {
                result.setResult("01");
            }
            return result;
        } catch (Exception e) {
            log.error("user info create error ,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("user.info.create.error");
            return result;
        }
    }

    @Override
    public Response<Pager<VendorsDto>> findByPage(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                                   User user, @Param("id") String id, @Param("name") String name, @Param("orgSimpleName") String orgSimpleName,
                                                   @Param("roleName") String roleName, @Param("checkStatus") String checkStatus,
                                                   @Param("status") String status) {
        PageInfo pageInfo = new PageInfo(pageNo, size);
        Response<Pager<VendorsDto>> result = new Response<Pager<VendorsDto>>();
        String vendorId = user.getVendorId();
        try {
            Map<String, Object> param = Maps.newHashMap();
            // 查询条件
            param.put("offset", pageInfo.getOffset());
            param.put("limit", pageInfo.getLimit());
            if (StringUtils.isNotEmpty(vendorId)) {
                param.put("vendorId", vendorId);
            }
            if (StringUtils.isNotEmpty(id)) {
                param.put("code", id);
            }
            if (StringUtils.isNotEmpty(name)) {
                param.put("name", name);
            }
            param.put("isSub", "1");
            if (StringUtils.isNotEmpty(orgSimpleName)) {
                List<String> org = Lists.newArrayList();
                Response<List<String>> orgSimpleNames = organiseService.findBySimpleName(orgSimpleName);
                if (orgSimpleNames.isSuccess()) {
                    org = orgSimpleNames.getResult();
                    param.put("orgSimpleNames", org);
                }
            }
            if (StringUtils.isNotEmpty(roleName)) {
                param.put("roleName", roleName);
                List<String> role = Lists.newArrayList();
                Response<List<String>> roleNames = vendorRoleService.findByName(roleName);
                if (roleNames.isSuccess()) {
                    role = roleNames.getResult();
                    param.put("roleName", role);
                }
            }
            if (StringUtils.isNotEmpty(checkStatus)) {
                param.put("checkStatus", checkStatus);
            }
            if (StringUtils.isNotEmpty(status)) {
                param.put("status", status);
            }

            Pager<VendorModel> vendorModelPager = vendorDao.findByPage(param, pageInfo.getOffset(),
                    pageInfo.getLimit());
            if (vendorModelPager.getTotal() == 0) {
                result.setResult(new Pager<>(0L, Collections.<VendorsDto> emptyList()));
                return result;
            }
            List<VendorModel> vendorModelList = vendorModelPager.getData();
            List<VendorsDto> vendorDtovs = Lists.newArrayList();
            VendorsDto vendorDto = null;
            for (VendorModel vendorModel : vendorModelList) {
                vendorDto = new VendorsDto();
                BeanMapper.copy(vendorModel, vendorDto);
                // 根据用户id把角色关联查出来
                List<Long> roleIdByUserId = vendorRoleRefDao.getRoleIdByUserId(vendorModel.getId());
                // 根据角色id查出角色名并用于显示
                if (roleIdByUserId.size() != 0) {
                    List<VendorRoleDto> roleByRoleIds = vendorRoleDao.getRoleByRoleIds(roleIdByUserId);
                    vendorDto.setVendorRoleDtos(roleByRoleIds);
                }

                vendorDtovs.add(vendorDto);
            }
            result.setResult(new Pager<>(vendorModelPager.getTotal(), vendorDtovs));
            return result;
        } catch (Exception e) {
            log.error("query user info  error ,cause:{}", Throwables.getStackTraceAsString(e));
            result.setResult(new Pager<>(0L, Collections.<VendorsDto> emptyList()));
            return result;
        }
    }

    /**
     * 修改
     *
     * @param vendorModel 用户信息
     * @return
     * add by liuhan
     */
    @Override
    public Response<Boolean> updateAll(VendorModel vendorModel) {
        Response<Boolean> result = new Response<Boolean>();
        try {
            checkArgument(StringUtils.isNotEmpty(vendorModel.getId()), "user.id.not.null.fail");
            Boolean res = vendorUserManager.updateAll(vendorModel);
            result.setResult(res);
            return result;
        } catch (IllegalArgumentException e) {
            log.error("user update error,cause{}", Throwables.getStackTraceAsString(e));
            result.setError(e.getMessage());
            return result;
        } catch (Exception e) {
            log.error("user update error,cause{}", Throwables.getStackTraceAsString(e));
            result.setError("user.update.error");
            return result;
        }
    }
}

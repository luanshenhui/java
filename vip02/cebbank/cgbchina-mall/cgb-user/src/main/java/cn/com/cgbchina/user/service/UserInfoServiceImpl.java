package cn.com.cgbchina.user.service;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;
import static com.spirit.util.Arguments.*;

import java.util.*;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;
import javax.validation.ConstraintViolation;
import javax.validation.Validator;

import org.springframework.stereotype.Service;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.*;
import com.google.common.base.Objects;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.hash.HashFunction;
import com.google.common.hash.Hashing;
import com.optimal.commons.util.StringUtil;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;

import cn.com.cgbchina.common.utils.NameValidator;
import cn.com.cgbchina.user.dao.*;
import cn.com.cgbchina.user.dto.AdminRoleDto;
import cn.com.cgbchina.user.dto.UserInfoDto;
import cn.com.cgbchina.user.manager.UserInfoManager;
import cn.com.cgbchina.user.model.*;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11140721050130 on 2016/4/30.
 */
@Service
@Slf4j
public class UserInfoServiceImpl implements UserInfoService {

	private final static HashFunction sha512 = Hashing.sha512();
	private final static Splitter splitter = Splitter.on('@').trimResults();
	private final static Joiner joiner = Joiner.on('@').skipNulls();
	private final static HashFunction md5 = Hashing.md5();

	// 本地缓存
	private final LoadingCache<String, UserInfoModel> userCache;
	@Resource
	private OrganiseService organiseService;
	@Resource
	private TblVendorRatioDao vendorRatioDao;
	@Resource
	private VendorPayNoDao vendorPayNoDao;
	@Resource
	private UserInfoDao userInfoDao;
	@Resource
	private OrganiseDao organiseDao;
	@Resource
	private UserInfoManager userInfoManager;
	@Resource
	private Validator validator;
	@Resource
	private MemberLogonHistoryDao logonHistoryDao;
	@Resource
	private UserRoleDao userRoleDao;
	@Resource
	private AdminRoleDao adminRoleDao;
    @Resource
    private AdminRoleService adminRoleService;
	@Resource
	private VendorInfoDao vendorInfoDao;

	// 构造函数
	// 构造函数
	public UserInfoServiceImpl() {
		userCache = CacheBuilder.newBuilder().expireAfterWrite(5, TimeUnit.MINUTES)
				.build(new CacheLoader<String, UserInfoModel>() {
                    @Override
                    public UserInfoModel load(String id) throws Exception {
                        return userInfoDao.findById(id);
                    }
                });
	}

    @Override
    public Response<Pager<UserInfoDto>> findByPage(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                                   User user, @Param("id") String id, @Param("name") String name, @Param("orgSimpleName") String orgSimpleName,
                                                   @Param("roleName") String roleName, @Param("checkStatus") String checkStatus,
                                                   @Param("status") String status) {
        PageInfo pageInfo = new PageInfo(pageNo, size);
        Response<Pager<UserInfoDto>> result = new Response<>();
        String userId = user.getId();
        try {
            Map<String, Object> param = Maps.newHashMap();
            // 查询条件
            param.put("offset", pageInfo.getOffset());
            param.put("limit", pageInfo.getLimit());
            if (StringUtils.isNotEmpty(id)) {
                param.put("id", id);
            }
            if (StringUtils.isNotEmpty(name)) {
                param.put("name", name);
            }
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
                Response<List<String>> roleNames = adminRoleService.findByName(roleName);
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

            Pager<UserInfoModel> userInfoModelPager = userInfoDao.findByPage(param, pageInfo.getOffset(),
                    pageInfo.getLimit());
            if (userInfoModelPager.getTotal() == 0) {
                result.setResult(new Pager<>(0L, Collections.<UserInfoDto> emptyList()));
                return result;
            }
            List<UserInfoModel> userInfoModelList = userInfoModelPager.getData();
            List<UserInfoDto> userInfoDtos = Lists.newArrayList();
            UserInfoDto userInfoDto = null;
            for (UserInfoModel userInfoModel : userInfoModelList) {
                userInfoDto = new UserInfoDto();
                BeanMapper.copy(userInfoModel, userInfoDto);
                Response<OrganiseModel> organise = organiseService.findByCode(userInfoModel.getOrgCode());
                if (organise.isSuccess()) {
                    OrganiseModel organiseModel = organise.getResult();
                    userInfoDto.setOrgSimpleName(organiseModel.getSimpleName());
                    userInfoDto.setOrgFullName(organiseModel.getFullName());
                }
                // 根据用户id把角色关联查出来
                List<Long> roleIdByUserId = userRoleDao.getRoleIdByUserId(userInfoModel.getId());
                // 根据角色id查出角色名并用于显示
                if (roleIdByUserId.size() != 0) {
                    List<AdminRoleDto> roleByRoleIds = adminRoleDao.getRoleByRoleIds(roleIdByUserId);
                    userInfoDto.setAdminRoleDtos(roleByRoleIds);
                }

                userInfoDtos.add(userInfoDto);
            }
            result.setResult(new Pager<>(userInfoModelPager.getTotal(), userInfoDtos));
            return result;
        } catch (Exception e) {
            log.error("query user info  error ,cause:{}", Throwables.getStackTraceAsString(e));
            result.setResult(new Pager<>(0L, Collections.<UserInfoDto> emptyList()));
            return result;
        }
    }

	@Override
	public Response<UserInfoDto> findUserById(String userId) {
		Response<UserInfoDto> result = new Response<>();

		// 校验用户Id
		if (userId == null) {
			log.error("user id can not be null");
			result.setError("userId.not.null.fail");
			return result;
		}
		try {
			// 根据用户ID查询用户信息，此处走本地缓存，缓存实现机制，guava cache
			UserInfoModel user = userCache.getUnchecked(userId);
			// 查询结果
			if (user == null) {
				log.error("failed to find UserInfo where userId={}", userId);
				result.setError("UserInfo.not.found");
				return result;
			}
			UserInfoDto userInfoDto = new UserInfoDto();
			BeanMapper.copy(user, userInfoDto);
			// 机构信息
			OrganiseModel organiseModel = organiseDao.findById(user.getOrgCode());
			if (organiseModel != null) {
				userInfoDto.setOrgName(organiseModel.getFullName());
			}
			result.setResult(userInfoDto);
			return result;
		} catch (Exception e) {
			log.error("failed to find userInfo where id={},cause:{}", userId, Throwables.getStackTraceAsString(e));
			result.setError("userInfo.query.fail");
			return result;
		}
	}

	@Override
	public Response<UserInfoModel> userLogin(String userName, String password) {
		Response<UserInfoModel> result = new Response<UserInfoModel>();
		try {
			checkArgument(notNull(userName), "login.userName.empty");
			checkArgument(notNull(password), "login.password.can.not.be.empty");
			UserInfoModel userInfo = queryUserBy(userName);
			checkState(notNull(userInfo), "user.firstpwd.secondpwd.error=一次密码或二次密码不正确\n" +
					"user.password.error");
			// 获取存储的密码
			String storedPassword = userInfo.getPassword();
			// 密码验证
			if (passwordMatch(password, storedPassword)) {
				result.setResult(userInfo);
				return result;
			} else {
				log.error("failed to login user  where login userName ={},cause:password mismatch ", userName);
				result.setError("user.password.error");
				return result;
			}
		} catch (IllegalArgumentException e) {
			log.error("fail to login with userName:{} ,error:{}", userName, e.getMessage());
			result.setError(e.getMessage());
		} catch (Exception e) {
			log.error("fail to login with userName:{} ,cause:{}", userName, Throwables.getStackTraceAsString(e));
			result.setError("user.login.fail");
		}
		return result;
	}

	@Override
	public Response<String> create(UserInfoDto userInfoDto) {
		Response<String> result = new Response<String>();
		try {
			// 校验参数
			checkArgument(!isNull(userInfoDto), "userInfo.is.null");
			if (Strings.isNullOrEmpty(userInfoDto.getId())) {
				log.error("user name can not be null");
				result.setError("user.name.empty");
				return result;
			}
			if (!NameValidator.validate(userInfoDto.getId())) {
				log.error("用户名称只能由字母,数字和下划线组成,but got {}", userInfoDto.getName());
				result.setError("user.illegal.name");
				return result;
			}
			Set<ConstraintViolation<UserInfoDto>> violations = validator.validate(userInfoDto);
			if (!violations.isEmpty()) {
				StringBuilder sb = new StringBuilder();
				for (ConstraintViolation<?> violation : violations) {
					sb.append(violation.getMessage()).append("\n");
				}
				log.error("failed to create user {},cause:{}", userInfoDto, sb.toString());
				result.setError("illegal.param");
				return result;
			}
			// 判断用户是否存在
			UserInfoModel isExist = userInfoDao.findByNameFlag(userInfoDto.getName());
			if (isExist != null) {
				// result.setError(Boolean.FALSE);
				result.setResult("98");
				return result;
			}
			// 判断账号是否存在
			UserInfoModel isId = userInfoDao.findByNameId(userInfoDto.getUserId());
			if (isId != null) {
				// result.setError(Boolean.FALSE);
				result.setResult("99");
				return result;
			}
			// 新建用户
			UserInfoModel userInfoModel = new UserInfoModel();
			userInfoDto.setPwfirst(encryptPassword(userInfoDto.getPwfirst()));
			BeanMapper.copy(userInfoDto, userInfoModel);
			userInfoModel.setCheckStatus("0");// 审核状态，待审核
			boolean res = userInfoManager.insert(userInfoModel);
			if (res) {
				result.setResult("00");
			} else {
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
	public Response<Boolean> update(UserInfoDto userInfoDto) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			checkArgument(StringUtils.isNotEmpty(userInfoDto.getId()), "user.id.not.null.fail");
			UserInfoModel userInfoModel = new UserInfoModel();
			BeanMapper.copy(userInfoDto, userInfoModel);
			Boolean res = userInfoManager.update(userInfoModel);
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

	@Override
	public Response<Boolean> assign(UserInfoModel userInfoDto) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			checkArgument(StringUtils.isNotEmpty(userInfoDto.getId()), "user.id.not.null.fail");
			userInfoDto.setPwsecond(encryptPassword(userInfoDto.getPwsecond()));
//			BeanMapper.copy(userInfoDto, userInfoModel);
			Boolean res = userInfoManager.update(userInfoDto);
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

	/**
	 * 修改密码
	 *
	 * @param userInfoDto 用户信息
	 * @return add by liuhan
	 */
	@Override
	public Response<Boolean> updatePassWord(UserInfoDto userInfoDto) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			checkArgument(StringUtils.isNotEmpty(userInfoDto.getId()), "user.id.not.null.fail");
			UserInfoModel userInfoModel = new UserInfoModel();
			userInfoDto.setPwfirst(encryptPassword(userInfoDto.getPwfirst()));
			BeanMapper.copy(userInfoDto, userInfoModel);
			Boolean res = userInfoManager.update(userInfoModel);
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

	@Override
	public Response<UserInfoModel> findUserInfoById(String userId) {
		Response<UserInfoModel> result = new Response<UserInfoModel>();
		try {
            UserInfoModel userInfoModel = userInfoDao.findById(userId);
			if (userInfoModel == null) {
				log.error("failed to find UserInfo where userId={}", userId);
				result.setError("user.password.incorrect");
				return result;
			}
            // 账号是否被停用
            if (!"0".equals(userInfoModel.getStatus())){
                log.error("user status stop userId={}", userId);
                result.setError("user.status.stop");
                return result;
            }
			result.setResult(userInfoModel);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("user.password.incorrect,cause{}", Throwables.getStackTraceAsString(e));
			result.setError(e.getMessage());
			return result;
		} catch (Exception e) {
			log.error("user.password.incorrect,cause{}", Throwables.getStackTraceAsString(e));
			result.setError("user.update.error");
			return result;
		}
	}

	@Override
	public Response<UserInfoModel> findUser(User user) {
		Response<UserInfoModel> result = new Response<UserInfoModel>();
		UserInfoModel userInfoModel = new UserInfoModel();
		if (!isEmpty(user.getId())) {
			MemberLogonHistoryModel lhModel = logonHistoryDao.findByCustId(user.getId());
			userInfoModel.setName(user.getName());
			userInfoModel.setModifyTime(lhModel.getLoginTime());
		}
		result.setResult(userInfoModel);
		return result;
	}

	/**
	 * 首次登录成功后更新密码
	 *
	 * @param userInfoModel
	 * @return
	 */
	@Override
	public Response updateFirstPwdByCode(UserInfoModel userInfoModel) {
		Response result = new Response();
		// 校验用户登录名
		if (StringUtil.isNullOrEmpty(userInfoModel.getId())) {
			log.error("user id can not be null");
			result.setError("user id can not be null");
			return result;
		}
		try {
			Response<UserInfoDto> userInfo = findUserById(userInfoModel.getId());
			// 密码验证
			if (!passwordMatch(userInfoModel.getPwfirst(), userInfo.getResult().getPwfirst())
					|| !passwordMatch(userInfoModel.getPwsecond(), userInfo.getResult().getPwsecond())) {
				log.error("failed to login user  where login userName ={},cause:password mismatch ",
						userInfoModel.getId());
				result.setError("user.firstpwd.secondpwd.error");
				return result;
			}
			// 首次登录成功后，更新数据库
			userInfoModel.setPassword(encryptPassword(userInfoModel.getPassword()));
			userInfoDao.updatePwdByCode(userInfoModel);
			userCache.invalidate(userInfoModel.getId());
			result.setResult(true);
			return result;

		} catch (Exception e) {
			log.error("failed to find userInfo where id={},cause:{}", userInfoModel.getId(),
					Throwables.getStackTraceAsString(e));
			result.setError("adminUser.modifyPwd.fail");
			return result;
		}
	}

	/**
	 * 过期后更新页面密码
	 *
	 * @param userInfoModel
	 * @param passwordOld
	 * @return
	 */
	@Override
	public Response updatePwdByCode(UserInfoModel userInfoModel, String passwordOld) {
		Response result = new Response();
		// 校验用户登录名
		if (StringUtil.isNullOrEmpty(userInfoModel.getId())) {
			log.error("user id can not be null");
			result.setError("user id can not be null");
			return result;
		}
		try {
			Response<UserInfoDto> userInfo = findUserById(userInfoModel.getId());
			// 密码验证
			if (!passwordMatch(passwordOld, userInfo.getResult().getPassword())) {
				log.error("failed to login user  where login userName ={},cause:password mismatch ",
						userInfoModel.getId());
				result.setError("user.password.incorrect");
				return result;
			}
			// 首次登录成功后，更新数据库
			userInfoModel.setPassword(encryptPassword(userInfoModel.getPassword()));
			userInfoDao.updatePwdByCode(userInfoModel);
			userCache.invalidate(userInfoModel.getId());
			result.setResult(true);
			return result;

		} catch (Exception e) {
			log.error("failed to find userInfo where id={},cause:{}", userInfoModel.getId(),
					Throwables.getStackTraceAsString(e));
			result.setError("adminUser.modifyPwd.fail");
			return result;
		}
	}

	// 密码校验
	private boolean passwordMatch(String password, String storePassword) {
		Iterable<String> parts = splitter.split(storePassword);
		String salt = Iterables.get(parts, 0);
		String realPassword = Iterables.get(parts, 1);
		return Objects.equal(sha512.hashUnencodedChars(password + salt).toString().substring(0, 20), realPassword);
	}

	// 密码加密
	private static String encryptPassword(String password) {
		String salt = md5.newHasher().putUnencodedChars(UUID.randomUUID().toString())
				.putLong(System.currentTimeMillis()).hash().toString().substring(0, 4);
		String realPassword = sha512.hashUnencodedChars(password + salt).toString().substring(0, 20);
		return joiner.join(salt, realPassword);
	}

	public static void main(String[] args) {
		System.out.println(encryptPassword("admin123"));
	}

	private UserInfoModel queryUserBy(String userName) {
		return userInfoDao.findByUserId(userName);
	}

	@Override
	public Response<List<TblVendorRatioModel>> findVendorRatioInfo(String vendorId, String period) {
		Response<List<TblVendorRatioModel>> response = new Response<List<TblVendorRatioModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("vendorId", vendorId);
		paramMap.put("period", period);
		try {
			List<TblVendorRatioModel> vendorRatiolList = vendorRatioDao.findVendorRatioInfo(paramMap);
			response.setResult(vendorRatiolList);
		} catch (Exception e) {
			log.error("findByCodes.item.error", Throwables.getStackTraceAsString(e));
			response.setError("findByCodes.item.error");
		}
		return response;
	}

	@Override
	public Response<List<VendorPayNoModel>> findVendorPayNoInfo(String vendorId, String period) {
		Response<List<VendorPayNoModel>> response = new Response<List<VendorPayNoModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("vendorId", vendorId);
		paramMap.put("period", period);
		try {
			List<VendorPayNoModel> vendorPayNolList = vendorPayNoDao.findVendorPayNoInfo(paramMap);
			response.setResult(vendorPayNolList);
		} catch (Exception e) {
			log.error("findByCodes.item.error", Throwables.getStackTraceAsString(e));
			response.setError("findByCodes.item.error");
		}
		return response;
	}

	@Override
	public Response<VendorInfoModel> findVendorInfoByVendorId(String vendorId) {
		Response<VendorInfoModel> response = new Response<VendorInfoModel>();
		try {
			VendorInfoModel bendorInfoModel = vendorInfoDao.findVendorInfosByVendorId(vendorId);
			response.setResult(bendorInfoModel);
		} catch (Exception e) {
			log.error("findByCodes.item.error", Throwables.getStackTraceAsString(e));
			response.setError("findByCodes.item.error");
		}
		return response;
	}

	@Override
	public Response<List<VendorInfoModel>> findVendorInfoByVendorIds(List<String> vendorIdsList) {
		Response<List<VendorInfoModel>> response = new Response<List<VendorInfoModel>>();
		try {
			List<VendorInfoModel> vendorInfoList = vendorInfoDao.findVendorInfoByVendorIds(vendorIdsList);
			response.setResult(vendorInfoList);
		} catch (Exception e) {
			log.error("findByCodes.item.error", Throwables.getStackTraceAsString(e));
			response.setError("findByCodes.item.error");
		}
		return response;
	}

	/*
	 * 根据用户机构code查询
	 *
	 * @param orgCode
	 * 
	 * @return add by liuhan
	 */
	@Override
	public Response<List<UserInfoModel>> findUserInfoByOrgCode(String orgCode) {
		Response<List<UserInfoModel>> result = new Response<List<UserInfoModel>>();
		List<UserInfoModel> userInfoList = new ArrayList<UserInfoModel>();
		try {
			userInfoList = userInfoDao.findUserInfoByOrgCode(orgCode);
			result.setResult(userInfoList);
			return result;
		} catch (Exception e) {
			log.error("failed to find userInfo where id={},cause:{}", orgCode, Throwables.getStackTraceAsString(e));
			result.setError("userInfo.query.fail");
			return result;
		}
	}
}

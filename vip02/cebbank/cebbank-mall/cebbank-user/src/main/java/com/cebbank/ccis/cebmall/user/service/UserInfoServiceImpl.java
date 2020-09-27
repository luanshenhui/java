package com.cebbank.ccis.cebmall.user.service;

import com.cebbank.ccis.cebmall.user.dao.UserInfoDao;
import com.cebbank.ccis.cebmall.user.dto.UserInfoDto;
import com.cebbank.ccis.cebmall.user.manager.UserInfoManager;
import com.cebbank.ccis.cebmall.user.model.UserInfoModel;
import com.google.common.base.Joiner;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.hash.HashFunction;
import com.google.common.hash.Hashing;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.ConstraintViolation;
import javax.validation.Validator;
import java.util.*;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;
import static com.spirit.util.Arguments.isNull;
import static com.spirit.util.Arguments.notNull;

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
    private final DateTimeFormatter dateTimeFormatCal = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

    // 本地缓存
    private final LoadingCache<String, UserInfoModel> userCache;

    @Resource
    private UserInfoDao userInfoDao;

    @Resource
    private UserInfoManager userInfoManager;
    @Resource
    private Validator validator;

    // 构造函数
    // 构造函数
    public UserInfoServiceImpl() {
        userCache = CacheBuilder.newBuilder().build(new CacheLoader<String, UserInfoModel>() {
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
//        String userId = user.getId();
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
            
          
            if (StringUtils.isNotEmpty(checkStatus)) {
                param.put("checkStatus", checkStatus);
            }
            if (StringUtils.isNotEmpty(status)) {
                param.put("status", status);
            }

            Pager<UserInfoModel> userInfoModelPager = userInfoDao.findByPage(param, pageInfo.getOffset(),
                    pageInfo.getLimit());
            if (userInfoModelPager.getTotal() == 0) {
                result.setResult(new Pager<>(0L, Collections.<UserInfoDto>emptyList()));
                return result;
            }
            List<UserInfoDto> userInfoDtos = Lists.newArrayList();
            result.setResult(new Pager<>(userInfoModelPager.getTotal(), userInfoDtos));
            return result;
        } catch (Exception e) {
            log.error("query user info  error ,cause:{}", Throwables.getStackTraceAsString(e));
            result.setResult(new Pager<>(0L, Collections.<UserInfoDto>emptyList()));
            return result;
        }
    }

    @Override
    public Response<UserInfoDto> findUserById(String userId) {
        Response<UserInfoDto> result = new Response<>();
        UserInfoDto userInfoDto = new UserInfoDto();
        userInfoDto.setId("123");
        userInfoDto.setName("testUser");
        result.setResult(userInfoDto);
        return result;
        // 校验用户Id
//        if (userId == null) {
//            log.error("user id can not be null");
//            result.setError("userId.not.null.fail");
//            return result;
//        }
//        try {
//            //不能使用缓存机制，修改密码不能实时取时无法修改
//            UserInfoModel user = userInfoDao.findById(userId);
//            // 查询结果
//            if (user == null) {
//                log.error("failed to find UserInfo where userId={}", userId);
//                result.setError("UserInfo.not.found");
//                return result;
//            }
//            UserInfoDto userInfoDto = new UserInfoDto();
//            BeanMapper.copy(user, userInfoDto);
//
//            result.setResult(userInfoDto);
//            return result;
//        } catch (Exception e) {
//            log.error("failed to find userInfo where id={},cause:{}", userId, Throwables.getStackTraceAsString(e));
//            result.setError("userInfo.query.fail");
//            return result;
//        }
    }
    @Override
    public Response<UserInfoModel> userLogin(String userName, String password) {
        Response<UserInfoModel> result = Response.newResponse();
        try {
            checkArgument(notNull(userName), "login.userName.empty");
            checkArgument(notNull(password), "login.password.can.not.be.empty");
            UserInfoModel userInfo = queryUserBy(userName);
            checkState(notNull(userInfo), "user.firstpwd.secondpwd.error=一次密码或二次密码不正确\n" +
                    "user.password.error");
            // 获取存储的密码
            String storedPassword = userInfo.getPassword();
            // 密码验证
            if (password.equals(storedPassword)) {
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
        Response<String> result = Response.newResponse();
        try {
            // 校验参数
            checkArgument(!isNull(userInfoDto), "userInfo.is.null");
            if (Strings.isNullOrEmpty(userInfoDto.getId())) {
                log.error("user name can not be null");
                result.setError("user.name.empty");
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
        Response<Boolean> result = Response.newResponse();
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
            if (!"0".equals(userInfoModel.getStatus())) {
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
        Response<Boolean> result = Response.newResponse();
        // 校验用户登录名
        try {
            // 首次登录成功后，更新数据库
            userInfoModel.setPassword(userInfoModel.getPassword());
            userInfoManager.updatePwdByCode(userInfoModel);
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
        if (Strings.isNullOrEmpty(userInfoModel.getId())) {
            log.error("user id can not be null");
            result.setError("user id can not be null");
            return result;
        }
        try {
            Response<UserInfoDto> userInfo = findUserById(userInfoModel.getId());
            if(!userInfo.isSuccess()){
                log.error("Response.error,error code: {}", userInfo.getError());
                throw new ResponseException(500, "Response.error");
            }
            // 首次登录成功后，更新数据库
            userInfoManager.updatePwdByCode(userInfoModel);
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



    private UserInfoModel queryUserBy(String userName) {
        return userInfoDao.findByUserId(userName);
    }

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

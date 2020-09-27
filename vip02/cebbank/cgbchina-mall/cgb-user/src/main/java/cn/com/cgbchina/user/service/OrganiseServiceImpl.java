package cn.com.cgbchina.user.service;

import static com.google.common.base.Preconditions.checkArgument;
import static com.spirit.util.Arguments.isNull;
import static com.spirit.util.Arguments.notNull;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;

import cn.com.cgbchina.user.model.UserInfoModel;
import org.springframework.stereotype.Service;

import com.google.common.base.Optional;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.user.dao.OrganiseDao;
import cn.com.cgbchina.user.manager.OrganiseManager;
import cn.com.cgbchina.user.model.OrganiseModel;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11140721050130 on 2016/5/8.
 */
@Service
@Slf4j
public class OrganiseServiceImpl implements OrganiseService {

	@Resource
	private OrganiseDao organiseDao;

	@Resource
	private OrganiseManager organiseManager;
	@Resource
	private UserInfoService userInfoService;

	// 本地缓存
	private final LoadingCache<String, Optional<OrganiseModel>> cache;

	// 构造函数
	public OrganiseServiceImpl() {
		cache = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
				.build(new CacheLoader<String, Optional<OrganiseModel>>() {
					@Override
					public Optional<OrganiseModel> load(String code) throws Exception {
						// 允许为空
						return Optional.fromNullable(organiseDao.findById(code));
					}
				});
	}

	@Override
	public Response<Pager<OrganiseModel>> findByPager(Integer pageNo, Integer size, String code, String sName,
			String level) {
		Response<Pager<OrganiseModel>> result = new Response<Pager<OrganiseModel>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> param = Maps.newHashMap();
		try {
			if (!Strings.isNullOrEmpty(code)) {
				param.put("code", code);
			}
			if (!Strings.isNullOrEmpty(sName)) {
				param.put("sName", sName);
			}
			if (!Strings.isNullOrEmpty(level)) {
				param.put("level", level);
			}
			Pager<OrganiseModel> pager = organiseDao.findByPage(param, pageInfo.getOffset(), pageInfo.getLimit());
			if (pager.getTotal() == 0) {
				result.setResult(new Pager<OrganiseModel>(0L, Collections.<OrganiseModel> emptyList()));
				return result;
			} else {
				result.setResult(pager);
				return result;
			}
		} catch (Exception e) {
			log.error("organise.qurery.fail,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("organise.qurery.fail");
			return result;
		}
	}

	@Override
	public Response<OrganiseModel> findByCode(String code) {
		Response<OrganiseModel> result = new Response<OrganiseModel>();
		try {
			//
			checkArgument(!isNull(code), "code.is.not.empty");
			OrganiseModel organiseModel = findById(code);
			//
			if (organiseModel == null) {
				result.setError("organise.not.foound");
				return result;
			}
			result.setResult(organiseModel);
			return result;
		} catch (Exception e) {
			result.setError("Organise.query.error");
			return result;
		}
	}

	private OrganiseModel findById(String code) {
		Optional<OrganiseModel> organiseModelOptional = this.cache.getUnchecked(code);
		//
		if (organiseModelOptional.isPresent()) {
			return organiseModelOptional.get();
		}
		return null;
	}

	@Override
	public Response<Boolean> create(OrganiseModel organiseModel) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			// 校验参数
			checkArgument(notNull(organiseModel.getCode()), "organise.code.not.empty");
			// 验证是否已经存在
//			OrganiseModel isExist = findById(organiseModel.getCode());
			OrganiseModel isExist = organiseDao.findByIdAll(organiseModel.getCode());
			if (!isNull(isExist)) {
				result.setError("organise.already.exist");
                result.setResult(Boolean.FALSE);
				return result;
			}
			organiseManager.create(organiseModel);
			cache.invalidate(organiseModel.getCode());
			result.setResult(Boolean.TRUE);
			return result;
		} catch (Exception e) {
			log.error("organise create error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("organise.create.error");
			return result;
		}
	}

	@Override
	public Response<Boolean> update(OrganiseModel organiseModel) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			boolean updateStatus = organiseManager.update(organiseModel);
			cache.invalidate(organiseModel.getCode());
			result.setResult(updateStatus);
			return result;
		} catch (Exception e) {
			log.error("organise update error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("organise.update.error");
			return result;
		}
	}

	@Override
	public Response<Boolean> delete(OrganiseModel organiseModel) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			Response<List<UserInfoModel>> userInfoList = userInfoService.findUserInfoByOrgCode(organiseModel.getCode());
			if(userInfoList.getResult().size()==0){
				boolean updateStatus = organiseManager.update(organiseModel);
				cache.invalidate(organiseModel.getCode());
				result.setResult(updateStatus);
				return result;
			}else{
				result.setError("organise.already.found");
				return result;
			}
		} catch (Exception e) {
			log.error("organise delete error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("organise.delete.error");
			return result;
		}
	}

	@Override
	public Response<List<OrganiseModel>> findAll() {
		Response<List<OrganiseModel>> result = new Response<List<OrganiseModel>>();
		try {
			List<OrganiseModel> list = organiseDao.findAll();
			if (list == null || list.size() == 0) {
				result.setResult(Collections.<OrganiseModel> emptyList());
				return result;
			}
			result.setResult(list);
			return result;
		} catch (Exception e) {
			log.error("organise get error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("organise.find.error");
			return result;
		}
	}

    /**
     * 根据机构简称，模糊查询所有的机构信息
     *
     * @return 机构信息列表
     * add by liuhan
     */
    @Override
    public Response<List<String>> findBySimpleName(String simpleName) {
        Response<List<String>> result = new Response<List<String>>();
        try {
            List<String> list = organiseDao.findBySimpleName(simpleName);
            result.setResult(list);
            return result;
        } catch (Exception e) {
            log.error("organise get error,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("organise.find.error");
            return result;
        }
    }
}
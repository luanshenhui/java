package cn.com.cgbchina.user.service;

import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.user.dao.LocalProcodeDao;
import cn.com.cgbchina.user.dto.LocalProcodeDto;
import cn.com.cgbchina.user.manager.LocalProcodeManage;
import cn.com.cgbchina.user.model.LocalProcodeModel;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import lombok.extern.slf4j.Slf4j;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/6.
 */
@Service
@Slf4j
public class LocalProcodeServiceImpl implements LocalProcodeService {

	@Resource
	private LocalProcodeDao localProcodeDao;
	@Resource
	private LocalProcodeManage localProcodeManage;

	@Override
	public Response<Pager<LocalProcodeModel>> findAll(Integer pageNo, Integer size) {
		Response<Pager<LocalProcodeModel>> response = new Response<Pager<LocalProcodeModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		try {
			Pager<LocalProcodeModel> pager = localProcodeDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			response.setResult(pager);
		} catch (Exception e) {
			log.error("find to query localProcode", e);
			response.setError("query.error");
		}
		return response;
	}

	/**
	 * 白金卡等级新增
	 *
	 * @param localProcodeModel
	 * @return
	 */
	@Override
	public Response<Boolean> create(LocalProcodeModel localProcodeModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			Boolean result = localProcodeManage.create(localProcodeModel);
			if (!result) {
				response.setError("insert.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert localProcode error", Throwables.getStackTraceAsString(e));
			response.setError("insert.localProcode.error");
			return response;
		}
	}

	/**
	 * 白金卡等级删除
	 *
	 * @param localProcodeModel
	 * @return
	 */
	@Override
	public Response<Boolean> delete(LocalProcodeModel localProcodeModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			Boolean result = localProcodeManage.delete(localProcodeModel);
			if (!result) {
				response.setError("delete.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("delete servicePromise error", Throwables.getStackTraceAsString(e));
			response.setError("delete.error");
			return response;
		}
	}

	/**
	 * 白金卡等级更新
	 *
	 * @param localProcodeModel
	 * @return
	 */
	@Override
	public Response<Boolean> update(Long id, LocalProcodeModel localProcodeModel) {
		Response<Boolean> response = new Response<Boolean>();
		if (StringUtils.isEmpty(localProcodeModel.getProNm()) || StringUtils.isEmpty(localProcodeModel.getProCode())) {
			response.setError("not.empty");
			return response;
		}
		try {
			// 获取ID
			localProcodeModel.setId(id);
			Boolean result = localProcodeManage.update(localProcodeModel);
			if (!result) {
				response.setError("update.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.defaultserach.error", Throwables.getStackTraceAsString(e));
			response.setError("update.error");
			return response;
		}

	}

	/**
	 * 获取已绑定卡板的卡等级名称
	 * 
	 * @param proCode
	 * @return
	 */

	@Override
	public Response<LocalProcodeModel> findByProCode(String proCode) {
		Response<LocalProcodeModel> response = new Response<>();
		try {
			LocalProcodeModel pager = localProcodeDao.findByProCode(proCode);
			response.setResult(pager);
		} catch (Exception e) {
			log.error("find to query localProcode", e);
			response.setError("query.error");
		}
		return response;
	}

	/**
	 * 白金卡编码和名称唯一性校验
	 * 
	 * @param proCode
	 * @param proNm
	 * @param id
	 * @return
	 */
	public Response<LocalProcodeDto> findNameByName(String proCode, String proNm, Long id) {
		Response<LocalProcodeDto> response = new Response<LocalProcodeDto>();
		LocalProcodeDto localProcodeDto = new LocalProcodeDto();
		// 新增和编辑对proNm的校验区分 当id为null时是新增操作 不为null时是编辑操作
		if (id != null) {
			// 当为编辑操作时 先通过id查出该条数据的name
			LocalProcodeModel localProcodeModel = localProcodeDao.findById(id);
			// 如果name不相同 代表编辑操作更改了name 这样就是查询全部的name来校验 如果name相同 即可以编辑
			if (!proNm.equals(localProcodeModel.getProNm())) {
				// 取得搜索词名称相同的条数 大于0代表有重复
				Long total = localProcodeDao.findNameByName(proNm);
				if (total != 0) {
					localProcodeDto.setProNmCheck(false);
					response.setResult(localProcodeDto);
				} else {
					localProcodeDto.setProNmCheck(true);
					response.setResult(localProcodeDto);
				}
			}
			// 顺序校验
			if (!proCode.equals(localProcodeModel.getProCode())) {
				Long sortTotal = localProcodeDao.findProCodeByProCode(proCode);
				if (sortTotal != 0) {
					localProcodeDto.setProCodeCheck(false);
					response.setResult(localProcodeDto);
				} else {
					localProcodeDto.setProCodeCheck(true);
					response.setResult(localProcodeDto);
				}
			} else {
				localProcodeDto.setProCodeCheck(true);
				response.setResult(localProcodeDto);
			}
		} else {
			// 新增时走以下方法
			Long total = localProcodeDao.findNameByName(proNm);
			if (total != 0) {
				localProcodeDto.setProNmCheck(false);
				response.setResult(localProcodeDto);
			} else {
				localProcodeDto.setProNmCheck(true);
				response.setResult(localProcodeDto);
			}
			Long sortTotal = localProcodeDao.findProCodeByProCode(proCode);
			if (sortTotal != 0) {
				localProcodeDto.setProCodeCheck(false);
				response.setResult(localProcodeDto);
			} else {
				localProcodeDto.setProCodeCheck(true);
				response.setResult(localProcodeDto);
			}
		}

		return response;
	}
}

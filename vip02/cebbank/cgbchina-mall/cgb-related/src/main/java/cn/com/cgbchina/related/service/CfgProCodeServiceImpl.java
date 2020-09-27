package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.dao.*;
import cn.com.cgbchina.related.model.*;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

/**
 * @author
 * @version 1.0
 * @Since 2016/7/4.
 */
@Service
@Slf4j
public class CfgProCodeServiceImpl implements CfgProCodeService {

	@Resource
	private TblCfgProCodeDao tblCfgProCodeDao;


	/**
	 * 返回表头和参数信息
	 *
	 * @return
	 */
	@Override
	public Response<List<TblCfgProCodeModel>> findProCodeInfo() {
		Response<List<TblCfgProCodeModel>> response = new Response<List<TblCfgProCodeModel>>();
		try {
			List<TblCfgProCodeModel> cfgProCodeList = tblCfgProCodeDao.findProCodeInfo();
			response.setResult(cfgProCodeList);
		} catch (Exception e) {
			log.error("findByCodes.item.error", Throwables.getStackTraceAsString(e));
			response.setError("findByCodes.item.error");
		}
		return response;
	}

}

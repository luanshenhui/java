package cn.com.cgbchina.user.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;

import cn.com.cgbchina.user.dao.EspCustNewDao;
import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

import static com.google.common.base.Preconditions.checkNotNull;

@Service
@Slf4j
public class EspCustNewServiceImpl implements EspCustNewService {

	@Resource
	private EspCustNewDao espCustNewDao;

	/**
	 * 更新使用生日次数
	 *
	 * @param custId
	 * @return
	 */
	@Override
	public Response<Integer> updateBirthUsedCount(String custId) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer count = espCustNewDao.updateBirthUsedCount(custId);
			if (count > 0) {
				response.setResult(count);
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update.item.error", Throwables.getStackTraceAsString(e));
			response.setError("update.item.error");
		}
		return response;
	}

}
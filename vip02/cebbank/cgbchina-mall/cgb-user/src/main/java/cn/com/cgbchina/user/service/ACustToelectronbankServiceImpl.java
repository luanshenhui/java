package cn.com.cgbchina.user.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import cn.com.cgbchina.user.dao.ACustToelectronbankDao;
import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import org.springframework.stereotype.Service;

import com.spirit.Annotation.Param;


import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11150721040343 on 16-4-8.
 */
@Service("aCustToelectronbankServiceImpl")
@Slf4j
public class ACustToelectronbankServiceImpl implements ACustToelectronbankService {

	@Resource
	private ACustToelectronbankDao aCustToelectronbankDao;

	@Override
	public String getUserBirth(@Param("certNo") String certNo) {
		List<ACustToelectronbankModel> result = aCustToelectronbankDao.selectBirthDay(certNo);
		Date birth = result.get(0).getBirthDay();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String birthDay = sdf.format(birth);

		return birthDay;
	}
}

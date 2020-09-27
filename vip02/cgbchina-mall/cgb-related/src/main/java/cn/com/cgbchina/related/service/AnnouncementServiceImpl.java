package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.model.AnnounceInfo;
import com.google.common.collect.Lists;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by 11141021040453 on 16-4-13.
 */
@Service
public class AnnouncementServiceImpl implements AnnouncementService {
	static List<AnnounceInfo> announceInfos = Lists.newArrayList();

	static {
		AnnounceInfo announceInfo = null;
		SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-DD HH:mm:ss");
		String dateStr = "2016-04-13 17:14:59";
		Date date = null;
		try {
			date = sdf.parse(dateStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		for (int i = 0; i < 100; i++) {
			announceInfo = new AnnounceInfo();
			announceInfo.setTopic("公告" + i);
			announceInfo.setTime(date);
			announceInfo.setContent("卖女孩的小火柴");
			announceInfos.add(announceInfo);
		}
	}

	/**
	 * 查找公告
	 * 
	 * @param pageNo
	 * @return
	 */
	public Response<Pager<AnnounceInfo>> find(@Param("pageNo") Integer pageNo) {
		if (pageNo == null) {
			pageNo = 1;
		}
		Response<Pager<AnnounceInfo>> response = new Response<Pager<AnnounceInfo>>();
		List<AnnounceInfo> retaccountInfos = announceInfos;
		Integer start = (pageNo - 1) * 20;
		Integer end = pageNo * 20;
		retaccountInfos = announceInfos.subList(start, end);
		Pager<AnnounceInfo> pager = new Pager<AnnounceInfo>(Long.valueOf(announceInfos.size()), retaccountInfos);
		response.setResult(pager);
		return response;
	}

	/**
	 * 创建公告
	 * 
	 * @param announceInfo
	 * @return
	 */
	public Response<Boolean> create(AnnounceInfo announceInfo) {
		Response<Boolean> response = new Response<Boolean>();
		SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-DD HH:mm:ss");
		Date time = null;
		try {
			time = sdf.parse(sdf.format(new Date()));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		announceInfo.setTime(time);
		announceInfos.add(1, announceInfo);
		response.setResult(true);
		response.setSuccess(true);
		return response;
	}

}

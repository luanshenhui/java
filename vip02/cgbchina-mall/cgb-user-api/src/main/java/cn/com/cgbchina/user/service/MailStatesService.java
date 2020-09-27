package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.model.MailStagesModel;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/7.
 */
public interface MailStatesService {

	public Response<List<MailStagesModel>> findMailStagesListByVendorId(String vendorId);

	public Response<List<MailStagesModel>> findAll();

	public Response<MailStagesModel> findByCodeAndVendorId(String code,String vendorId);
}

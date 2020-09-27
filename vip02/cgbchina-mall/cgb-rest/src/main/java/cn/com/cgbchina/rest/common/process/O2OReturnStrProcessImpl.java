package cn.com.cgbchina.rest.common.process;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

@Service
public class O2OReturnStrProcessImpl implements PackProcess<String, BaseResultVo> {

	@Override
	public BaseResultVo packing(String r, Class<BaseResultVo> t) {
		BaseResultVo result = new BaseResultVo();
		String[] str1 = r.split("&");
		for (String s : str1) {
			String[] str2 = s.split("=");
			switch (str2[0]) {
			case "result_code":
				result.setRetCode(str2[1]);
				break;
			case "result_msg":
				result.setRetErrMsg(str2[1]);
				break;
			}
		}
		return result;
	}

}

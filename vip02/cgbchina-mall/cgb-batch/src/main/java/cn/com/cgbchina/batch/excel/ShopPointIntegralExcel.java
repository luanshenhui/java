package cn.com.cgbchina.batch.excel;

import java.io.IOException;
import java.util.List;

import javax.annotation.Resource;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

import cn.com.cgbchina.batch.dao.ShopPointIntegralDao;
import cn.com.cgbchina.batch.model.IntegralShopPoint;
import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import org.springframework.stereotype.Component;

/**
 * 积分兑换报表（购物积点）
 * 
 * @see IntegralShopPoint
 * @author huangcy on 2016年5月10日
 */
@Slf4j
@Component
public class ShopPointIntegralExcel {
	@Resource
	private ShopPointIntegralDao shopPointIntegralDao;
	private String directory;

	public Response<Boolean> exportShopPointXlsForWeek() {
		Response<Boolean> rps = new Response<>();
		try {
			// TODO directory这个变量什么意思？
			String outputPath = directory;
			String templateName = null;

			// 获取数据
			List<IntegralShopPoint> shopPointIntegrals = shopPointIntegralDao.getShopPointTntegral();
			if (shopPointIntegrals.isEmpty()) {
				log.info("没有导出的数据");
				rps.setError("没有导出的数据");
				return rps;
			}
			// 导出数据
			try {
				ExcelUtilAgency.exportExcel(shopPointIntegrals, templateName, outputPath);
			} catch (IOException e) {
				log.error("导出购物积点积分兑换报表出错..... erro:{}", Throwables.getStackTraceAsString(e));
				rps.setError(Throwables.getStackTraceAsString(e));
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("积分兑换报表（购物积点） 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

}

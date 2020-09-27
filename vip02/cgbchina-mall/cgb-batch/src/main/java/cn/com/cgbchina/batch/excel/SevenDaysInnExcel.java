package cn.com.cgbchina.batch.excel;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import cn.com.cgbchina.batch.manager.ReportManager;
import com.google.common.base.Throwables;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.trade.dto.SevenDaysInnDto;
import cn.com.cgbchina.batch.model.QueryParams;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

/**
 * 7天联名卡住宿券报表服务
 * 
 * @author xiewl
 * @version 2016年6月16日 上午10:03:24
 */
@Slf4j
@Component
public class SevenDaysInnExcel {

	@Value("${sevenDaysInn.tempPath}")
	private String templatePath; // 报表模版路径

	@Value("${sevenDaysInn.week.outpath}")
	private String weekOutputPath; // 周报表导出路径

	@Value("${sevenDaysInn.week.fileName}")
	private String weekReportName;// 周报表文件名

	@Value("${excel.MaxNum}")
	private int size;

	@Autowired
	private ReportManager reportManager;

	public Response<Boolean> exportSevenDaysInnModelForWeek(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startCommDate = BatchDateUtil.parseDate(batchDate);
			String endDate = BatchDateUtil.addDay(batchDate, 7);
			Date endCommDate = BatchDateUtil.parseDate(endDate);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(weekOutputPath, weekReportName, batchDate);
			String outputFile = queryDataToExcels(queryParams, filePath, weekReportName);
			// 压缩文件
			// TODO
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("7天联名卡住宿券报表服务 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 获取数据到Excel
	 * 
	 * @param queryParam 查询条件
	 * @param outPath 导出路径
	 * @param titleName
	 * @return outputFiles 已修正的导出文件路径
	 * @throws IOException
	 */
	private String queryDataToExcels(QueryParams queryParam, String outPath, String titleName) throws IOException {
		List<String> outputFiles = Lists.newArrayList();
		String filePath = "";
		String newOutput = "";
		try {
			int index = 1;
			int pageNo = 1;// sheet页码
			Map<String, String> params = Maps.newHashMap();
			params.put("title", titleName);
			Pager<SevenDaysInnDto> pager = getPager(pageNo, queryParam);
			long total = pager.getTotal();
			int totalPages = (int) Math.ceil((double) total / (double) size);
			List<SevenDaysInnDto> sevendaysInnDtos = null;
			while (pageNo <= totalPages) {
				if (totalPages > 1) {// 判断是否导出多份Excel导出
					newOutput = ExcelUtilAgency.addExcelNo(outPath, pageNo);
				} else {
					newOutput = outPath;
				}
				sevendaysInnDtos = pager.getData();
				for (SevenDaysInnDto sevenDaysInnDto : sevendaysInnDtos) {
					sevenDaysInnDto.setIndex(index++);
				}
				filePath = ExcelUtilAgency.exportExcel(sevendaysInnDtos, templatePath, newOutput, params);
				outputFiles.add(filePath);
				pageNo++;// 下一页
				if (totalPages > 1 && pageNo <= totalPages) {// 获取下一份数据
					pager = getPager(pageNo, queryParam);
				}
			}
			if (outputFiles.size() > 1) {
				filePath = ExcelUtilAgency.replacePostfix(outPath);
				filePath = ExcelUtilAgency.zipFiles(filePath, outputFiles);
			}
		} catch (IOException e) {
			log.error("导出模版错误" + e.getMessage());
			e.printStackTrace();
		}
		return filePath;
	}

	/**
	 * 获取数据
	 * 
	 * @param pageNo
	 * @param queryParam
	 * @return
	 */
	private Pager<SevenDaysInnDto> getPager(int pageNo, QueryParams queryParam) {
		Response<Pager<SevenDaysInnDto>> result = null;
		if (!result.isSuccess()) {
			// 调用失败，判断异常情况，异常处理，日志写入
			// log.error()
		}
		Pager<SevenDaysInnDto> pager = result.getResult();
		return pager;
	}
}

package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.BatchSmspInfDao;
import cn.com.cgbchina.batch.model.BatchSmspCustModel;
import cn.com.cgbchina.batch.model.BatchSmspInfModel;
import cn.com.cgbchina.batch.model.BatchSmspRecordModel;
import cn.com.cgbchina.batch.model.ClearQueryModel;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

@Component
@Slf4j
public class BatchSmsTemplateManager {
	@Resource
	private BatchSmspInfDao batchSmspInfDao;

	/**
	 * 内管短信模板编辑
	 *
	 * @param smspInfModel
	 * @return
	 */
	@Transactional
	public boolean update(BatchSmspInfModel smspInfModel) {
		return batchSmspInfDao.update(smspInfModel) == 1;
	}

	/**
	 * 新建履历表
	 *
	 * @param smspRecordModel
	 * @return
	 */
	@Transactional
	public boolean createRecord(BatchSmspRecordModel smspRecordModel) {
		return batchSmspInfDao.insert(smspRecordModel) == 1;
	}

	/**
	 * 数据--导入
	 *
	 * @param repeat 重复 数据
	 * @return boolean
	 */
	@Transactional
	public boolean updateImportData(List<BatchSmspCustModel> repeat) {
		boolean updateFlag = true;
		// 重复数据处理
		if (null != repeat && !repeat.isEmpty()) {
			// 对于重复名单的进行更新：成功更新db的存入成功的list,失败的存入失败的list
			for (BatchSmspCustModel rp : repeat) {
				int num = batchSmspInfDao.updateSmspCust(rp);
				if (0 == num) {
					updateFlag = Boolean.FALSE;
				}
			}
		}
		return updateFlag;
	}

	/**
	 * 数据--导入
	 *
	 * @param smspCustModelList 导入数据
	 * @return boolean
	 */
	@Transactional
	public boolean insertImportData(List<BatchSmspCustModel> smspCustModelList) {
		boolean createFlag = true;
		// 新增名单：成功插入db的存入成功的list,失败的存入失败的list
		if (!smspCustModelList.isEmpty()) {
			List<List<BatchSmspCustModel>> sms = Lists.partition(smspCustModelList, 500);
			for (List<BatchSmspCustModel> sm : sms) {
				int num = batchSmspInfDao.insertBatch(sm);
				log.info("新增名单:"+num + "---" + sm.size());
				if (0 == num || sm.size() != num) {
					createFlag = Boolean.FALSE;
				}
			}
		}
		return createFlag;
	}

	/**
	 * 数据--导入
	 *
	 * @param smspCustModelList 导入数据
	 * @return boolean
	 */
	@Transactional
	public int replaceImportData(List<BatchSmspCustModel> smspCustModelList) {
		int num = 0;
		// 新增名单：成功插入db的存入成功的list,失败的存入失败的list
		if (!smspCustModelList.isEmpty()) {
			num = batchSmspInfDao.replaceBatch(smspCustModelList);
			log.info("更新名单:"+(num - smspCustModelList.size()));
			if (num > 0) {
				num = num - smspCustModelList.size();
			} else {
				num = -1;
			}
		}
		return num;
	}
}

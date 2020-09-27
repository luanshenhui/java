package cn.com.cgbchina.batch.test;

import cn.com.cgbchina.batch.service.HotRankServiceImpl;
import cn.com.cgbchina.batch.service.PromotionSyncService;
import cn.com.cgbchina.batch.service.PromotionSyncServiceImpl;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/batch-context-test.xml")
@ActiveProfiles("dev")
public class PromotionSyncServiceTest extends AbstractJUnit4SpringContextTests {
	@Resource
	private PromotionSyncServiceImpl promotionSyncServiceImpl;

	@Resource
	private HotRankServiceImpl hotRankServiceImpl;

	@Test
	public void test() {
		promotionSyncServiceImpl.batchProm();
	}

	/**
	 * 测试荷兰拍释放接口
	 *
	 * geshuo 20160727
	 */
	@Test
	public void TestBatchDutchAuctionRelease(){
		promotionSyncServiceImpl.batchDutchAuctionRelease();
	}


	@Test
	public void test2() {
		promotionSyncServiceImpl.syncDBtoRedis("20160814");
	}

	/**
	 * 热销品类统计
	 */
	@Test
	public void testCountHotCategory(){
		hotRankServiceImpl.countHotCategory();
	}

	/**
	 * 通用统计（供应商销量统计）
	 */
	@Test
	public void testCountHotVendor(){
		hotRankServiceImpl.countHotVendor();
	}

	/**
	 * 通用统计（供应商一周数据统计）
	 */
	@Test
	public void testCountVendorWeekSale(){
		hotRankServiceImpl.countVendorWeekSale();
	}

}

package cn.com.cgbchina.item;

import cn.com.cgbchina.item.dto.itemSearchDto;
import cn.com.cgbchina.item.service.ItemIndexService;
import cn.com.cgbchina.item.service.ItemSearchService;
import com.spirit.common.model.Response;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import javax.annotation.Resource;
import java.io.IOException;

/**
 * Created by 133625 on 16-3-17.
 */
public class TestItemIndex extends BaseTestCase {

	@Resource
	private ItemIndexService itemIndexService;

	@Autowired
	private ItemSearchService itemSearchService;

	@Test
	public void testfullIndex() throws IOException {
		itemIndexService.fullItemIndex();
	}

	@Test
	public void testDetaIndex() throws IOException {
		itemIndexService.deltaItemIndex("dmin16060700156");
	}

	@Test
	public void testSearchItem() {
		Response<itemSearchDto> result = itemSearchService.searchItem("YG", null, "苹果", "price", "1", 1, 20,
				"{\"category1Id\":\"27\",\"brandId\":[\"32\",\"33\",\"63\"],\"priceRange\":\"100-50000\",\"2001\":[\"3000\"]}");

		System.out.println(result.getResult().getItemSearchResultList().size());
	}

	@Test
	public void testDeleteIndex() {
		itemIndexService.deleteItemIndex("dmin16060700156");
	}
}

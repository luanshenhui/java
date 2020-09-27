package cn.com.cgbchina.web;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.GoodsItemDto;
import cn.com.cgbchina.item.service.GoodsDetailService;
import cn.com.cgbchina.related.model.TblEspKeywordRecordModel;
import cn.com.cgbchina.web.common.ViewRender;
import cn.com.cgbchina.web.utils.SafeHtmlValidator;
import com.google.common.base.Strings;
import com.spirit.common.model.Response;
import com.spirit.core.exception.NotFound404Exception;
import com.spirit.exception.ResponseException;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 特殊页面渲染入口
 * <p>
 * Created by 11140721050130 on 2016/8/9.
 */
@Controller
@Slf4j
public class View {

    @Autowired
    private ViewRender viewRender;

    @Resource
    private GoodsDetailService goodsDetailService;

    @Resource
    private MessageSources messageSources;

    private String str;

    @PostConstruct
    public void init() {
        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n" +
                "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n" +
                "<head>\n" +
                "</head>\n" +
                "<body>");
        sb.append(Strings.repeat("0", 320000));
        sb.append("</body>\n" +
                "</html>");
        str = sb.toString();
    }

    /**
     * 商品详情页渲染入口
     *
     * @param request
     * @param response
     * @param domain
     * @param context
     */
    @RequestMapping(value = "/goods/{goodsCode}", method = RequestMethod.GET)
    public void item(HttpServletRequest request, HttpServletResponse response, @RequestHeader("Host") String domain,
                     @PathVariable String goodsCode, @RequestParam Map<String, Object> context,
                     @RequestParam(value = "itemCode", required = false) String itemCode) {
        context.put("goodsCode", goodsCode);
        context.put("buyerId", UserUtil.getUserId());
        if (SafeHtmlValidator.checkScriptAndEvent(goodsCode)) {
            log.error("bad request,cause:{}", goodsCode);
            throw new ResponseException(404, "goods.not.found");
        }
        Response<GoodsItemDto> GoodsR = goodsDetailService.findDetailByGoodCode(itemCode, goodsCode);
        if (!GoodsR.isSuccess()) {
            log.error("failed to find item(id={}),error code:{}", goodsCode, GoodsR.getError());
            throw new NotFound404Exception(messageSources.get(GoodsR.getError()));
        }
        GoodsItemDto item = GoodsR.getResult();
        context.put("spuId", item.getGoodsModel().getProductId());
        context.put("buyerId", UserUtil.getUserId());
        context.put("seo", buildSEOInfoForItem(item));
        context.put("_GOODSDATA_", item);
        String path = "";
        if (Contants.ORDERTYPEID_YG.equals(item.getGoodsModel().getOrdertypeId())) {
            path = "item/goods-details";
        } else {
            path = "item/gift-details";
        }
        viewRender.view(domain.split(":")[0], path, request, response, context);
    }

    private TblEspKeywordRecordModel buildSEOInfoForItem(GoodsItemDto item) {
        TblEspKeywordRecordModel titleKeyword = new TblEspKeywordRecordModel();
        titleKeyword.setTitle(messageSources.get("item.templates.title", item.getGoodsModel().getName()));
        titleKeyword.setKeyWords(messageSources.get("item.templates.keywords", item.getGoodsModel().getName()));
        titleKeyword.setDesc(messageSources.get("item.templates.description", item.getGoodsModel().getName()));
        return titleKeyword;
    }
}

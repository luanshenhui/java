package cn.com.cgbchina.trade.service;

/**
 * Created by shangqinbin on 2016/8/10.
 */
public interface PriorJudgeService {

    /**
     * @param cardNo    卡号
     * @param formatId  卡板
     * @param goodsId   商品编码
     * @param force_buy 强制兑换-1，非强制兑换-0
     * @return 0-正常 1-卡板不符合 2-已达购买次数
     */
    public String preJudge(String certNo, String cardNo, String formatId, String goodsId, String force_buy);

    /**
     * @param cardNo    卡号
     * @param formatId  卡板
     * @param goodsId   商品编码
     * @param force_buy 强制兑换-1，非强制兑换-0
     * @param limitCnt 积分数
     * @return 0-正常 1-卡板不符合 2-已达购买次数
     */
    public String preJudge(String certNo, String cardNo, String formatId, String goodsId, String force_buy, long limitCnt);

    /**
     * 判断是否是附属卡
     * @param goods_id   商品ID
     * @param entry_card 附属卡
     * @return 0-代表正常 -1-->代表此商品不是附属卡礼品   -2--->该卡不是附属卡
     */
    public String judgeEntryCard(String goods_id, String entry_card);

    /**
     * 判断是否年费产品（虚拟礼品）
     *
     * @param goods_xid
     * @return
     */
    public boolean isNianFee(String goods_xid);

    /**
     * 判断是否签帐额产品（虚拟礼品）
     * @param goods_xid
     * @return
     */
    public boolean isQianzhane(String goods_xid);

    /**
     * 判断是否移动充值卡
     * @param goods_xid
     * @return
     */
    public boolean isPrepaid(String goods_xid);

    /**
     * 判断是否为留学生意外险
     * @param goods_xid
     * @return
     */
    public boolean isLxsyx(String goods_xid);

    /**
     * 判断是否为白金卡附属卡年费产品
     *
     * @param goods_xid
     * @return
     */
    public boolean isBjfsk(String goods_xid);

    /**
     * 判断是否为ALL常旅客消费
     *
     * @param goods_xid
     * @return
     */
    public boolean isClkxf(String goods_xid);
    /**
     * 南航里程
     * @param goods_xid
     * @return
     */
    public boolean isSouthern(String goods_xid);
    /**
     * 判断是否为七天联名卡住宿券
     *
     * @param goods_xid
     * @return
     */
    public boolean isQtlmk(String goods_xid);

    /**
     * 判断是否为广发人保粤通卡
     * @param goods_xid
     * @return
     */
    public boolean isYueTong(String goods_xid);
    //备选方案
    public String preJudge(String certNo, String goodsId);
}

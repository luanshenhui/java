package com.dpn.ciqqlc.common.util;

import java.util.List;

public class PageBean {
    private int count = 0; // 记录总数
    private int pageSize=Constants.PAGE_NUM; // 每页显示记录
    private int pageCount = 0; // 总页数


    private int page = 1; // 当前页数
    private String high;
    private String low;
    private List dataList = null;
    
    /**
     * 
     * @param p 页码
     */
    public PageBean(int p){
        //pageSize = Integer.parseInt(IConstants.DUFAULT_PAGE_NUM);
        if(p != 0){
            int highNum = pageSize * p;
            int lowNum = pageSize * (p - 1) + 1;
            this.high = String.valueOf(highNum);
            this.low = String.valueOf(lowNum);
        }else{
            this.high = String.valueOf(pageSize);
            this.low = String.valueOf(1);
        }
    }
    
    public PageBean(int p ,String _pageSize){
        pageSize = Integer.parseInt(_pageSize);
        if(p != 0){
            int highNum = pageSize * p + 1;
            int lowNum = pageSize * (p - 1) + 1;
            this.high = String.valueOf(highNum);
            this.low = String.valueOf(lowNum);
        }else{
            this.high = String.valueOf(pageSize);
            this.low = String.valueOf(1);
        }
    }
    
    /**
     * 
     * @param _count    记录总数
     * @param _pageSize 每页显示记录
     */
    public PageBean(int _count, int _pageSize) {
        count = _count;
        pageSize = _pageSize;
        // 计算总页数


        pageCount = count / pageSize;
        int mod = count % pageSize;
        if (mod > 0) {
            pageCount++;
        }
    }
    
    /**
     * 
     * @param p 页码
     * @param pHigh 查询上限
     * @param pLow 查询下限
     */
    public PageBean(int p,int pHigh,int pLow){
//      pageSize = Integer.parseInt(IConstants.DUFAULT_PAGE_NUM);
    }
    
    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        if (pageSize != 0) {
            pageCount = count / pageSize;
            if (count % pageSize != 0) {
                pageCount++;
            }
        }
        this.count = count;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getPageCount() {
        return pageCount;
    }

    public void setPageCount(int pageCount) {
        this.pageCount = pageCount;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public List getDataList() {
        return dataList;
    }

    public void setDataList(List dataList) {
        this.dataList = dataList;
    }

    public String getHigh() {
        return high;
    }

    public void setHigh(String high) {
        this.high = high;
    }

    public String getLow() {
        return low;
    }

    public void setLow(String low) {
        this.low = low;
    }
    
}
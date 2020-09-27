package cn.com.cgbchina.item.dto;

import java.io.Serializable;

/**
 * Created by txy on 2016/6/27.
 */
public class GiftPartitionCheckDto implements Serializable {

    private static final long serialVersionUID = -7281821044590966296L;

    private boolean codeCheck;//分区代码

    public boolean isCodeCheck() {
        return codeCheck;
    }

    public void setCodeCheck(boolean codeCheck) {

        this.codeCheck = codeCheck;
    }

    private boolean nameCheck;//分区名称

    public boolean isNameCheck() {

        return nameCheck;
    }

    public void setNameCheck(boolean nameCheck) {
        this.nameCheck = nameCheck;
    }

    private boolean sortCheck;// 显示顺序

    public boolean isSortCheck() {
        return sortCheck;
    }

    public void setSortCheck(boolean sortCheck) {

        this.sortCheck = sortCheck;
    }

    private boolean regionTypeCheck;// goods分区

    public boolean isRegionTypeCheck() {
        return regionTypeCheck;
    }

    public void setRegionTypeCheck(boolean regionTypeCheck) {

        this.regionTypeCheck = regionTypeCheck;
    }

}

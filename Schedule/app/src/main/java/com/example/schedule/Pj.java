package com.example.schedule;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.Date;

public class Pj {

    @NotNull
    private String qq;
    @NotNull
    private String name;
    @Nullable
    private String profile;

    private int num  ;
    // private String member_a ;
    private String member_b ;
    // private int qq ;
    private String sex_a ;
    private String qq_age ;
    private Date join_date ;
    private String integrate ;
    private Date last_tell_time ;
    // private int send_count ;
    private int del_flg ;

    @NotNull
    public String getQq() {
        return qq;
    }

    public void setQq(@NotNull String qq) {
        this.qq = qq;
    }

    @NotNull
    public String getName() {
        return name;
    }

    public void setName(@NotNull String name) {
        this.name = name;
    }

    @Nullable
    public String getProfile() {
        return profile;
    }

    public void setProfile(@Nullable String profile) {
        this.profile = profile;
    }

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    public String getMember_b() {
        return member_b;
    }

    public void setMember_b(String member_b) {
        this.member_b = member_b;
    }

    public String getSex_a() {
        return sex_a;
    }

    public void setSex_a(String sex_a) {
        this.sex_a = sex_a;
    }

    public String getQq_age() {
        return qq_age;
    }

    public void setQq_age(String qq_age) {
        this.qq_age = qq_age;
    }

    public Date getJoin_date() {
        return join_date;
    }

    public void setJoin_date(Date join_date) {
        this.join_date = join_date;
    }

    public String getIntegrate() {
        return integrate;
    }

    public void setIntegrate(String integrate) {
        this.integrate = integrate;
    }

    public Date getLast_tell_time() {
        return last_tell_time;
    }

    public void setLast_tell_time(Date last_tell_time) {
        this.last_tell_time = last_tell_time;
    }

    public int getDel_flg() {
        return del_flg;
    }

    public void setDel_flg(int del_flg) {
        this.del_flg = del_flg;
    }
}

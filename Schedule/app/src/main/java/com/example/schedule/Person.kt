package com.example.schedule

import java.util.*

class Person(){
    var qq:String=""
    var name:String=""
    var profile:String?=null

    var num = 0
    // private String member_a ;
    var member_b: String? = null

    // private int qq ;
    var sex_a: String? = null
    var qq_age: String? = null
    var join_date: Date? = null
    var integrate: String? = null
    var last_tell_time: Date? = null

    // private int send_count ;

    var del_flg = 0
    init {
        this.qq=qq
        this.name=name
        this.profile=profile
        this.num=num
        this.member_b=member_b
        this.sex_a=sex_a
        this.qq_age=qq_age
        this.join_date=join_date
        this.integrate=integrate
        this.last_tell_time=last_tell_time
        this.del_flg=del_flg
    }

    override fun toString(): String {
        return "Person(qq='$qq', name='$name', profile=$profile, num=$num, member_b=$member_b, sex_a=$sex_a, qq_age=$qq_age, join_date=$join_date, integrate=$integrate, last_tell_time=$last_tell_time, del_flg=$del_flg)"
    }


}

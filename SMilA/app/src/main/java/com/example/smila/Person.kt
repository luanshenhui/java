package com.example.smila;

class Person(qq:String,name:String,profile:String=""){
    var qq:String=""
    var name:String=""
    var profile:String?=null
    init {
        this.qq=qq
        this.name=name
        this.profile=profile
    }

    override fun toString(): String {
        return "Person(qq='$qq', name='$name', profile=$profile)"
    }

}

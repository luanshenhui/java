package com.example.smila;


import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import java.util.*


class MyAdapter(context: Context?, list: ArrayList<Person>?) : BasicAdapter<Person>(context, list) {
    override fun getView(p0: Int, p1: View?, p2: ViewGroup?): View {
        var contentview = p1
        var holder: ViewHolder? = null
        if (contentview == null) {
            contentview = LayoutInflater.from(context).inflate(R.layout.person_list, null)
            var tv_userName: TextView = contentview.findViewById(R.id.tv_userName)
            var tv_age: TextView = contentview.findViewById(R.id.tv_age)
            var tv_profile: TextView = contentview.findViewById(R.id.tv_profile)
            holder = ViewHolder(tv_userName, tv_age, tv_profile)
            contentview.setTag(holder)
        } else {
            holder = contentview.getTag() as ViewHolder?
        }
        holder?.userName?.setText(listData?.get(p0)?.name)
        holder?.age?.setText(listData?.get(p0)?.qq)
        holder?.profile?.setText(listData?.get(p0)?.profile)
        return contentview!!
    }

    class ViewHolder(
        var tvName: TextView,
        var tvAge: TextView,
        var tvProfile: TextView
    ) {
        var userName: TextView = tvName.findViewById(R.id.tv_userName) as TextView
        var age: TextView = tvAge.findViewById(R.id.tv_age) as TextView
        var profile: TextView = tvProfile.findViewById(R.id.tv_profile) as TextView
    }

}

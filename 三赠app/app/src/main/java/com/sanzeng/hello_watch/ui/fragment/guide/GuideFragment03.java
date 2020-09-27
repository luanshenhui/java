package com.sanzeng.hello_watch.ui.fragment.guide;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.sanzeng.hello_watch.R;

import butterknife.ButterKnife;

/**
 * 引导页03
 * Created by YY on 2017/6/16.
 */
public class GuideFragment03 extends Fragment {

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.guide_img_three,container, false);
        ButterKnife.bind(getActivity(),view);
        return view;
    }

}

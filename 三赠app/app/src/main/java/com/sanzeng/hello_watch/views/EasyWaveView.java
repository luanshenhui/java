package com.sanzeng.hello_watch.views;

import android.animation.ValueAnimator;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.LinearInterpolator;

import com.sanzeng.hello_watch.R;

import java.util.ArrayList;

/**
 * Created by moshangjian on 2015/7/8.
 */
@SuppressWarnings("unused")
public class EasyWaveView extends View implements Handler.Callback {


    public EasyWaveView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initAttributeset(context,attrs,defStyle);
        init(context);
    }

    public EasyWaveView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initAttributeset(context,attrs,0);
        init(context);
    }

    public EasyWaveView(Context context) {
        super(context);
        init(context);
    }


    private void init(Context context) {
        interCirclePaint = new Paint();
        interCirclePaint.setAntiAlias(true);
        interCirclePaint.setStyle(Paint.Style.FILL_AND_STROKE);

        outPaint = new Paint();
        outPaint.setAntiAlias(true);
        outPaint.setStyle(Paint.Style.FILL_AND_STROKE);

        mHander = new Handler(Looper.getMainLooper() , this) ;
    }


    private  void initAttributeset(Context context , AttributeSet attrs , int defStyle){
        Resources resources = getResources();

        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.easywaveAttr, defStyle, 0);

        interRadius = typedArray.getDimensionPixelSize(R.styleable.easywaveAttr_innerRadius, 0) ;
        interCircleColor = typedArray.getColor(R.styleable.easywaveAttr_innerColor , Color.BLACK) ;
        outCircleMaxRadius = typedArray.getDimensionPixelSize(R.styleable.easywaveAttr_outMaxRadius,0);
        outCircleColor = typedArray.getColor(R.styleable.easywaveAttr_outRadiusColor , Color.BLACK) ;
        outCircleWidth = typedArray.getDimensionPixelSize(R.styleable.easywaveAttr_outRadiusWidth, 5);
        delayDuration = typedArray.getDimensionPixelSize(R.styleable.easywaveAttr_nextDuration , 1000) ;

        typedArray.recycle() ;

    }

    private Handler mHander ;


    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        initConfig();
    }

    private int width;
    private int height;
    private int outCircleMaxRadius ;

    private void initConfig() {
        width = getWidth();
        height = getHeight();
        if (interRadius <= 0){
            interRadius = width / 12;
        }
        interCirclePaint.setColor(interCircleColor);

        outCircleMinRadius = interRadius;
        if (outCircleMaxRadius <= 0 ){
            outCircleMaxRadius = Math.min(width,height)  / 4 ;
        }
    }

    private int outCircleWidth ;
    public void setOutCircleWidth(int width){
        this.outCircleWidth = width ;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (list != null  && list.size() > 0){
            int listSize = list.size() ;
            int removeIndex = -1 ;
            for (int i = 0 ; i < listSize ; i ++){
                CircleInfo mcircleInfo = list.get(i);
                outPaint.setColor(mcircleInfo.color);
                outPaint.setAlpha( 255 - mcircleInfo.radius  * 255  / outCircleMaxRadius);
                mcircleInfo.radius = mcircleInfo.radius + 1 ;
                if (mcircleInfo.radius > outCircleMaxRadius){
                    removeIndex = i ;
                }else {
                    canvas.drawCircle(width/2 , height /2 , mcircleInfo.radius , outPaint);
                    canvas.drawCircle(width / 2, height / 2, interRadius, outPaint);
                }
            }
            if (removeIndex > 0 ){
                list.remove(removeIndex);
                removeIndex = -1 ;
            }
        }
        canvas.restore();

        if (list == null){
            animatorControl();
        }

        postInvalidate();
    }

    private ArrayList<CircleInfo> list ;

    private void animatorControl(){

        if (list == null){
            list = new ArrayList<CircleInfo>();
        }

        list.add(new CircleInfo()) ;

        Message message = mHander.obtainMessage();
        message.what = 1 ;
        mHander.sendMessageDelayed(message , delayDuration) ;
    }

    private int delayDuration = 1000 ;


    private void initAnimator() {
        ValueAnimator valueAnimator = ValueAnimator.ofInt(255, 0);
        valueAnimator.setInterpolator(new LinearInterpolator());
        valueAnimator.setDuration(animatorDuration) ;


    }


    @TargetApi(Build.VERSION_CODES.KITKAT)
    @Override
    protected void onVisibilityChanged(View changedView, int visibility) {
        super.onVisibilityChanged(changedView, visibility);
//        if (visibility == View.GONE && animatorSet != null && animatorSet.isRunning()) {
//            animatorSet.pause();
//        }else if (visibility == View.VISIBLE && animatorSet != null && animatorSet.isPaused()){
//            animatorSet.start();
//        }

    }

    private int animatorDuration  = DEFULT_DURATION;
    private final  static  int DEFULT_DURATION = 10000 ;

    public void setAnimatorDuration (int animatorDuration){
        this.animatorDuration = animatorDuration ;
    }


    private int interRadius;

    public void setInterCircleRadius(int radius) {
        this.interRadius = radius;
    }


    private int interCircleColor;
    private Paint interCirclePaint;
    private Paint outPaint;
    private int outCircleMinRadius;
    private int outCircleColor ;


    public void setInterCircleColor(int color) {
        this.interCircleColor = color;
    }


    public void setOutCircleColor(int color) {
        this.outCircleColor = color;
    }

    @Override
    public boolean handleMessage(Message msg) {
        switch (msg.what){
            case 1:
                animatorControl();
                break;
        }
        return false;
    }


    private class CircleInfo {
        CircleInfo(){
            radius = outCircleMinRadius ;
            color = outCircleColor ;
        }

        public int radius;
        public int color;
    }
}



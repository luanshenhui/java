package com.sanzeng.hello_watch.views;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.View;

import com.sanzeng.hello_watch.R;
import com.sanzeng.hello_watch.views.exception.MisMatchException;
import com.sanzeng.hello_watch.views.exception.OnDrawingException;


/**
 * Created with Android Studio.
 * Package_Name：com.fly.project.view
 * Project_Name：ChatDemo1
 * User：郭鹏飞
 * Date：2015/8/12
 * Email：love518420@foxmail.com
 * Description：绘制环形比例图
 * 当View制定一个精确的尺寸 以该尺寸为标准
 * 当view尺寸小于环形尺寸 通过环形尺寸去计算view尺寸
 * 关于对齐不可以多个一起使用
 * 默认以左开始
 */
public class RingView extends View implements Runnable {

    private static final int TYPE_ALIGN_CENTER = 0;
    private static final int TYPE_ALIGN_LEFT = 1;
    private static final int TYPE_ALIGN_RIGHT = 2;
    private static final int TYPE_ALIGN_CENTER_HORIZONTAL = 3;
    private static final int TYPE_ALIGN_CENTER_VERTICAL = 4;

    private Context mContext;

    private Paint paint;

    // 环形比例图的颜色值配置 代表的数据配置
    private int[] colors, values;

    // 每一个弧形扫过的角度
    float[] sweepAngle;
    // 在生成环形比列图的过程中 动态变化的每一个弧型扫过的角度
    float[] dynamicSweepAngle;
    // 在生成环形比例图的时候 动态变化的每一个弧型起始的角度
    float[] dynamicStartAngle;

    // 绘制图形区域的尺寸
    private int width, height;
    // 环形图的矩形区域
    private RectF rectF;
    // 环形尺寸
    private int rSize;
    // 环形的宽度
    private int strokeWidth;
    // 环形的对齐方式 默认左对齐
    private int align = TYPE_ALIGN_LEFT;

    // 绘制标记
    private boolean flag = false;

    public RingView(Context context) {
        this(context, null);
    }

    public RingView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public RingView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        mContext = context;

        rSize = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,
                100, getResources().getDisplayMetrics());
        strokeWidth = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,
                10, getResources().getDisplayMetrics());

        TypedArray mArray = mContext.obtainStyledAttributes(attrs,
                R.styleable.RingView, defStyleAttr, 0);

        int mIndexCount = mArray.getIndexCount();
        for (int i = 0; i < mIndexCount; i++) {
            int index = mArray.getIndex(i);
            switch (index) {
                case R.styleable.RingView_ringSize:
                    rSize = mArray.getDimensionPixelOffset(index, rSize);
                    break;
                case R.styleable.RingView_strokeWidth:
                    strokeWidth = mArray.getDimensionPixelOffset(index, strokeWidth);
                    break;
                case R.styleable.RingView_align:
                    align = mArray.getInt(index, align);
                    break;
            }
        }

        mArray.recycle();

        initPaint();

    }

    /**
     * 初始化画笔
     */
    private void initPaint() {
        paint = new Paint();
        paint.setAntiAlias(true);
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(strokeWidth);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);

        int widthMode = MeasureSpec.getMode(widthMeasureSpec);
        int widthSize = MeasureSpec.getSize(widthMeasureSpec);
        if (widthMode == MeasureSpec.EXACTLY) {
            width = widthSize;
        } else {
            if (widthMode == MeasureSpec.AT_MOST) {
                int tempWidth = getPaddingRight() + rSize + getPaddingLeft();
                width = Math.min(widthSize, tempWidth);
            }
        }

        int heightMode = MeasureSpec.getMode(heightMeasureSpec);
        int heightSize = MeasureSpec.getSize(heightMeasureSpec);
        if (heightMode == MeasureSpec.EXACTLY) {
            height = heightSize;
        } else {
            if (heightMode == MeasureSpec.AT_MOST) {
                int tempHeight = getPaddingBottom() + rSize + getPaddingTop();
                height = Math.min(heightSize, tempHeight);
            }
        }

        int sideLen = Math.min(width, height);
        if (sideLen < rSize) {
            width = rSize + getPaddingLeft() + getPaddingRight();
            height = rSize + getPaddingTop() + getPaddingBottom();
        }

        initRect();
        setMeasuredDimension(width, height);
    }

    /**
     * 初始化绘制区域
     */
    private void initRect() {
        // 得到绘制的矩形区域
        // 内圆环 默认值 其实就是左对齐的值
        float left = getPaddingLeft() + strokeWidth,
                top = getPaddingTop() + strokeWidth,
                right = getPaddingLeft() + rSize - strokeWidth,
                bottom = getPaddingTop() + rSize - strokeWidth;
        switch (align) {
            case TYPE_ALIGN_CENTER: // 居中
                left = width / 2 - rSize / 2 + strokeWidth;
                right = left + (rSize / 2 - strokeWidth) * 2;
                top = height / 2 - rSize / 2 + strokeWidth;
                bottom = top + (rSize / 2 - strokeWidth) * 2;
                break;
            case TYPE_ALIGN_LEFT: // 左对齐
                break;
            case TYPE_ALIGN_RIGHT: // 右对齐
                right = width - getPaddingRight() - strokeWidth;
                left = right - (rSize / 2 - strokeWidth) * 2;
                break;
            case TYPE_ALIGN_CENTER_HORIZONTAL: // 水平居中
                left = width / 2 - rSize / 2 + strokeWidth;
                right = left + (rSize / 2 - strokeWidth) * 2;
                break;
            case TYPE_ALIGN_CENTER_VERTICAL: // 垂直居中
                top = height / 2 - rSize / 2 + strokeWidth;
                bottom = top + (rSize / 2 - strokeWidth) * 2;
                break;
        }
        rectF = new RectF(left, top, right, bottom);
    }

    @Override
    protected void onDraw(final Canvas canvas) {
        super.onDraw(canvas);

        if (flag) {
            for (int i = 0; i < values.length; i++) {
                paint.setColor(colors[i]);
                canvas.drawArc(rectF, dynamicStartAngle[i], dynamicSweepAngle[i], false, paint);
            }
        }

    }

    /**
     * 初始化扫过角度
     *
     * @param sweepAngle 角度
     */
    private void initSweepAngle(float[] sweepAngle) {
        int total = 0;
        for (int value : values) {
            total += value;
        }
        for (int i = 0; i < values.length; i++) {
            sweepAngle[i] = values[i] * 1.0f / total * 360;
        }
    }

    /**
     * 设置颜色配置
     *
     * @param colors 颜色
     */
    public void setColors(int[] colors) {
        this.colors = colors;
    }

    /**
     * 设置比例
     *
     * @param values 值
     */
    public void setValues(int[] values) {
        this.values = values;
    }

    /**
     * 开始绘制
     */
    public void startDraw() throws OnDrawingException {

        if (colors == null || colors.length == 0) {
            throw new NullPointerException("colors is null");
        }
        if (values == null || values.length == 0) {
            throw new NullPointerException("values is null");
        }
        if (colors.length != values.length) {
            throw new MisMatchException("colors and values mismatch");
        }

        if (!flag)
            flag = true;
        else
            throw new OnDrawingException();

        sweepAngle = new float[values.length];
        initSweepAngle(sweepAngle);
        dynamicSweepAngle = new float[values.length];
        dynamicStartAngle = new float[values.length];

        new Thread(this).start();

        invalidate();
    }

    @Override
    public void run() {
        float currentTotalAngle = 0f;
        while (currentTotalAngle < 360f) {
            currentTotalAngle = 0f;
            // 计算每一次绘制的每一个比例的起始角度
            for (int i = 0; i < dynamicStartAngle.length; i++) {
                if (i == 0) // 第一次绘制所有比例的其实角度都为0
                    dynamicStartAngle[i] = 0f;
                else // 以后每次绘制的启示角度等于上一次的起始角度+上一次绘制的角度
                    dynamicStartAngle[i] = dynamicStartAngle[i - 1] + dynamicSweepAngle[i - 1];
            }
            // 计算每次绘制的角度
            for (int i = 0; i < dynamicSweepAngle.length; i++) {
                currentTotalAngle += dynamicSweepAngle[i];
                if (dynamicSweepAngle[i] < sweepAngle[i]) {
                    dynamicSweepAngle[i] += 2f;
                    // 如果超过的分配值 则直接赋值为分配值
                    dynamicSweepAngle[i] = dynamicSweepAngle[i] >= sweepAngle[i] ? sweepAngle[i] : dynamicSweepAngle[i];
                }

            }
            postInvalidate();
            try {
                Thread.sleep(66);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        // 绘制完成
        flag = false;
    }
}

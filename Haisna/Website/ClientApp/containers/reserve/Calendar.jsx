import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';

import { connect } from 'react-redux';
import qs from 'qs';
import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';
import * as constants from '../../constants/common';

import { getScheduleHRequest, setSelectYearMonth } from '../../modules/preference/scheduleModule';
import { initDailyListParams, setDailyListParams } from '../../modules/reserve/consultModule';

const tdHoliday = { color: 'red', textDecoration: 'none', padding: '0' };
const tdWeekday = { color: 'black', textDecoration: 'none', padding: '0' };
const tdSaturday = { color: '#006699', textDecoration: 'none', padding: '0' };

const aToday = { color: '#FF9900', textDecoration: 'none' };
const aHoliday = { color: 'red', textDecoration: 'none' };
const aSaturday = { color: '#006699', textDecoration: 'none' };
const aKyusin = { color: 'green', textDecoration: 'none' };
const aWeekday = { color: 'black', textDecoration: 'none' };

const font12 = { fontSize: '12px', padding: '0', margin: '0' };

const iconvrev = (
  <svg width="12" height="12" viewBox="0 0 1024 1024" fill="#CCCCCC">
    <path d="M535.408 448l379.92 440v-880zM108.656 448l379.984 440v-880z" />
  </svg>);
const iconvback = (
  <svg width="12" height="12" viewBox="0 0 1024 1024" fill="#CCCCCC">
    <path d="M250.656 448l522.672 448v-896z" />
  </svg>);
const iconvplay = (
  <svg width="12" height="12" viewBox="0 0 1024 1024" fill="#CCCCCC">
    <path d="M773.328 448l-522.672-448v896z" />
  </svg>);
const iconvff = (
  <svg width="12" height="12" viewBox="0 0 1024 1024" fill="#CCCCCC">
    <path d="M488.576 448l-379.92-440v880zM915.328 448l-379.984-440v880z" />
  </svg>);

class Calendar extends React.Component {
  componentDidMount() {
    // ロード時処理を呼び出す
    const { setDspYearMonth } = this.props;
    // 引数値の取得
    let { lngDspYear, lngDspMonth } = this.props;

    if (lngDspYear === 0) {
      lngDspYear = moment().subtract(1, 'months').year();
    }
    if (lngDspMonth === 0) {
      lngDspMonth = moment().subtract(1, 'months').month() + 1;
    }
    setDspYearMonth(lngDspYear, lngDspMonth);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { initScheduleH, lngDspYear, lngDspMonth } = this.props;

    if (nextProps.lngDspYear !== lngDspYear || nextProps.lngDspMonth !== lngDspMonth) {
      const strStrDate = moment([nextProps.lngDspYear, nextProps.lngDspMonth - 1, 1]).format('YYYY/M/D');
      const strEndDate = moment([nextProps.lngDspYear, nextProps.lngDspMonth - 1, 1]).add(3, 'months').endOf('month').format('YYYY/M/D');
      initScheduleH({ strDate: strStrDate, endDate: strEndDate });
    }
  }

  // 日クリック時の処理
  handleDailyListClick(strYear, strMonth, strDay) {
    const { history, setNewParams } = this.props;
    const strDate = moment([strYear, strMonth - 1, strDay]).format('YYYY/M/D');
    setNewParams({ strDate });
    history.push({
      pathname: '/reserve/frontdoor/dailylist',
      search: qs.stringify({ strDate }),
    });
  }

  render() {
    const { data, lngDspYear, lngDspMonth, setDspYearMonth } = this.props;

    if (lngDspYear === 0 && lngDspMonth === 0) return null;
    // カレンダー作成用
    // 年
    let strEditYear;
    // 月
    let strEditMonth;
    // 日
    let strEditDay;
    // 月末日
    let strEndDay;

    const strHtml = [];

    for (let i = 0; i <= 2; i += 1) {
      const strHtmlWeekDayLoop = [];

      strEditYear = moment([lngDspYear, lngDspMonth - 1, 1]).add(i, 'months').year();
      strEditMonth = moment([lngDspYear, lngDspMonth - 1, 1]).add(i, 'months').month() + 1;

      // スタート日（先頭が何曜日かを取得）
      strEditDay = 1 - (moment([strEditYear, strEditMonth - 1, 1]).weekday() + 1);
      // 月末日
      strEndDay = moment([strEditYear, strEditMonth - 1, 1]).endOf('month').date();

      // カレンダー作成（最大６週あるので）
      for (let j = 1; j <= 6; j += 1) {
        // 週ごとに計算
        for (let k = 1; k <= 7; k += 1) {
          strEditDay += 1;

          if (strEditDay >= 1 && strEditDay <= strEndDay) {
            // 日付の表示色設定
            let strClass;

            // 今日の色指定
            const nowMoment = moment();
            if (strEditYear === nowMoment.year() && strEditMonth === nowMoment.month() + 1 && strEditDay === nowMoment.date()) {
              strClass = aToday;
            } else {
              // 祝日なのか休診日なのかを検索
              let strHoliday = '';
              const lngCount = data.length;
              for (let l = 0; l < lngCount; l += 1) {
                if (moment(data[l].csldate).isSame(moment([strEditYear, strEditMonth - 1, strEditDay]))) {
                  strHoliday = data[l].holiday;
                  break;
                }
              }

              if (strHoliday === '2') {
                // 祝日の色設定
                strClass = aHoliday;
              } else if (k === constants.VBSATURDAY) {
                // 土曜日の色指定
                strClass = aSaturday;
              } else if (k === constants.VBSUNDAY) {
                // 日曜日の色指定
                strClass = aHoliday;
              } else if (strHoliday === '1') {
                // 休診日の色指定
                strClass = aKyusin;
              } else {
                // 平日の色指定
                strClass = aWeekday;
              }
            }

            const strYear = strEditYear;
            const strMonth = strEditMonth;
            const strDay = strEditDay;

            strHtmlWeekDayLoop.push((
              <GridListTile key={`${strEditYear}-${strEditMonth}-${j}-${strEditDay}`} style={{ backgroundColor: '#ffffff', padding: '0', border: '1px solid #eee' }}>
                <a role="presentation" onClick={() => (this.handleDailyListClick(strYear, strMonth, strDay))} style={{ ...strClass, cursor: 'pointer' }}>
                  {`${strEditDay}`.length === 1 && <span style={{ color: '#FFFFFF' }}>0</span>}<span>{strEditDay}</span>
                </a>
              </GridListTile>));
          } else {
            strHtmlWeekDayLoop.push((
              <GridListTile key={`${strEditYear}-${strEditMonth}-${j}-${strEditDay}`} style={{ backgroundColor: '#ffffff', padding: '0', border: '1px solid #eee' }}>
                <span>&nbsp;</span>
              </GridListTile>));
          }
        }
      }

      strHtml.push((
        <div key={`${strEditYear}-${strEditMonth}`} style={{ ...font12, marginTop: '7px', marginBottom: '10px', width: '114px', padding: '0' }}>
          <div style={{ height: '14px', fontWeight: 'bolder', marginBottom: '3px' }}>
            <b>{ strEditYear }</b>年<b>{ strEditMonth }</b>月
          </div>
          <GridList cellHeight={11} style={{ width: '114px', padding: '0' }} cols={7}>
            <GridListTile key={`${strEditYear}-${strEditMonth}-sun`} style={tdHoliday}><div><b>日</b></div></GridListTile>
            <GridListTile key={`${strEditYear}-${strEditMonth}-mon`} style={tdWeekday}><div><b>月</b></div></GridListTile>
            <GridListTile key={`${strEditYear}-${strEditMonth}-tue`} style={tdWeekday}><div><b>火</b></div></GridListTile>
            <GridListTile key={`${strEditYear}-${strEditMonth}-wen`} style={tdWeekday}><div><b>水</b></div></GridListTile>
            <GridListTile key={`${strEditYear}-${strEditMonth}-thi`} style={tdWeekday}><div><b>木</b></div></GridListTile>
            <GridListTile key={`${strEditYear}-${strEditMonth}-fri`} style={tdWeekday}><div><b>金</b></div></GridListTile>
            <GridListTile key={`${strEditYear}-${strEditMonth}-sat`} style={tdSaturday}><div><b>土</b></div></GridListTile>
            { strHtmlWeekDayLoop }
          </GridList>
        </div>));
    }

    const strNextYear = moment([lngDspYear, lngDspMonth - 1, 1]).add(1, 'months').year();
    const strNextMonth = moment([lngDspYear, lngDspMonth - 1, 1]).add(1, 'months').month() + 1;
    const strPrevYear = moment([lngDspYear, lngDspMonth - 1, 1]).subtract(1, 'months').year();
    const strPrevMonth = moment([lngDspYear, lngDspMonth - 1, 1]).subtract(1, 'months').month() + 1;
    const strNext3Year = moment([lngDspYear, lngDspMonth - 1, 1]).add(3, 'months').year();
    const strNext3Month = moment([lngDspYear, lngDspMonth - 1, 1]).add(3, 'months').month() + 1;
    const strPrev3Year = moment([lngDspYear, lngDspMonth - 1, 1]).subtract(3, 'months').year();
    const strPrev3Month = moment([lngDspYear, lngDspMonth - 1, 1]).subtract(3, 'months').month() + 1;

    return (
      <div style={{ margin: '3px 0 0 8px', backgroundColor: '#eee' }}>
        {/* 見出し */}
        <div style={{ backgroundColor: '#cccccc', marginTop: '10px', width: '114px' }}>
          <div style={{ ...font12, textAlign: 'center', height: '16px', color: '#ffffff', fontWeight: 'bolder' }}>
            Calendar
          </div>
        </div>

        {/* カレンダ */}
        {strHtml}

        <div style={{ backgroundColor: '#cccccc', width: '110px', marginTop: '10px', padding: '0' }}>
          <div style={{ ...font12, textAlign: 'center', height: '17px', color: '#ffffff', fontWeight: 'bolder' }}>
            表示月変更
          </div>
          <div style={{ textAlign: 'center', verticalAlign: 'middle', height: '25px', backgroundColor: '#ffffff' }}>

            <span style={{ fontSize: '18px', color: '#006699' }} title="前の３ヶ月を表示">
              <a role="presentation" onClick={() => setDspYearMonth(strPrev3Year, strPrev3Month)} style={{ cursor: 'pointer' }}>
                {iconvrev}
              </a>
            </span>
            <span style={{ fontSize: '18px', color: '#006699' }} title="前月を表示">
              <a role="presentation" onClick={() => setDspYearMonth(strPrevYear, strPrevMonth)} style={{ cursor: 'pointer' }}>
                {iconvback}
              </a>
            </span>
            <span style={{ marginLeft: '30px', fontSize: '18px', color: '#006699' }} title="次月を表示">
              <a role="presentation" onClick={() => setDspYearMonth(strNextYear, strNextMonth)} style={{ cursor: 'pointer' }}>
                {iconvplay}
              </a>
            </span>
            <span style={{ fontSize: '18px', color: '#006699' }} title="次の３ヶ月を表示">
              <a role="presentation" onClick={() => setDspYearMonth(strNext3Year, strNext3Month)} style={{ cursor: 'pointer' }}>
                {iconvff}
              </a>
            </span>

          </div>
        </div>

      </div>
    );
  }
}

// プロパティの型を定義する
Calendar.propTypes = {
  initScheduleH: PropTypes.func.isRequired,
  setDspYearMonth: PropTypes.func.isRequired,
  setNewParams: PropTypes.func.isRequired,
  lngDspYear: PropTypes.number.isRequired,
  lngDspMonth: PropTypes.number.isRequired,
  history: PropTypes.shape().isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

// defaultPropsの定義
Calendar.defaultProps = {

};

const mapStateToProps = (state) => ({
  lngDspYear: state.app.preference.schedule.scheduleHList.selectYear,
  lngDspMonth: state.app.preference.schedule.scheduleHList.selectMonth,
  data: state.app.preference.schedule.scheduleHList.data,
});

const mapDispatchToProps = (dispatch) => ({
  initScheduleH: (params) => {
    dispatch(getScheduleHRequest({ params }));
  },
  setDspYearMonth: (selectYear, selectMonth) => {
    dispatch(setSelectYearMonth({ selectYear, selectMonth }));
  },
  setNewParams: (params) => {
    dispatch(initDailyListParams());
    dispatch(setDailyListParams({ newParams: params }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Calendar);
